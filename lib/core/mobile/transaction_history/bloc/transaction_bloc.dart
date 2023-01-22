import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_posx/database/db_utils/db_sale_order.dart';
import 'package:nb_posx/database/models/attribute.dart';
import 'package:nb_posx/database/models/sale_order.dart';
import '../../../../constants/app_constants.dart';

import '../../../../database/db_utils/db_constants.dart';
import '../../../../database/db_utils/db_preferences.dart';
import '../../../../database/models/customer.dart';
import '../../../../database/models/option.dart';
import '../../../../database/models/order_item.dart';
import '../../../../network/api_constants/api_paths.dart';
import '../../../../network/service/api_utils.dart';
import '../../../../utils/helper.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../service/sales_history/model/sale_order_list_response.dart';

import '../model/transaction.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

const throttleDuration = Duration(milliseconds: 100);
const _listSize = 10;

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final http.Client httpClient;

  TransactionBloc({required this.httpClient})
      : super(const TransactionState()) {
    on<TransactionFetched>(_onPostFetched,
        transformer: throttleDroppable(throttleDuration));

    on<TransactionSearched>((event, emit) async {
      if (event.text.length > 2) {
        final transactions = await _searchTransactions(event.text);
        return emit(state.copyWith(
          status: TransactionStatus.success,
          orders: transactions,
          hasReachedMax: true,
        ));
      } else if (event.text.isEmpty) {
        final transactions = await _fetchTransactions();
        return emit(state.copyWith(
          status: TransactionStatus.success,
          orders: transactions,
          hasReachedMax: false,
        ));
      }
    });
  }

  FutureOr<void> _onPostFetched(
      TransactionFetched event, Emitter<TransactionState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == TransactionStatus.initial) {
        final transactions = await _fetchTransactions();
        return emit(state.copyWith(
          status: TransactionStatus.success,
          orders: transactions,
          hasReachedMax: false,
        ));
      }
      final transactions = await _fetchTransactions(state.orders.length);
      emit(transactions.isEmpty
          ? state.copyWith(hasReachedMax: true)
          : state.copyWith(
              status: TransactionStatus.success,
              orders: List.of(state.orders)..addAll(transactions),
              hasReachedMax: transactions.length < _listSize,
            ));
    } catch (_) {
      emit(state.copyWith(status: TransactionStatus.failure));
    }
  }

  Future<List<Transaction>> _fetchTransactions([int orderSize = 0]) async {
    if (await Helper.isNetworkAvailable()) {
      int pageNo = 1;
      if (orderSize > 0) {
        var ord = orderSize / _listSize;
        pageNo = (ord.ceilToDouble() + 1).toInt();
      }
      debugPrint("Current Page No: $pageNo");

      String hubManagerId = await DBPreferences().getPreference(HubManagerId);

      //Creating GET api url
      String apiUrl = SALES_HISTORY;
      apiUrl += '?hub_manager=$hubManagerId&page_no=$pageNo';

      return _processRequest(apiUrl);
    } else {
      List<SaleOrder> offlineOrders = await DbSaleOrder().getOfflineOrders();
      List<Transaction> offlineTransactions = [];
      for (var order in offlineOrders) {
        Transaction transaction = Transaction(
            id: order.id,
            date: order.date,
            time: order.time,
            customer: order.customer,
            items: order.items,
            orderAmount: order.orderAmount,
            tracsactionDateTime: order.tracsactionDateTime);

        offlineTransactions.add(transaction);
      }
      return offlineTransactions;
    }

    //throw Exception("Error fetching transactions");
  }

  Future<List<Transaction>> _processRequest(String apiUrl) async {
    try {
      List<Transaction> sales = [];
      //Call to Sales History api
      var apiResponse = await APIUtils.getRequestWithHeaders(apiUrl);
//Fetching the local orders data

      if (apiResponse["message"]["message"] != "success") {
        throw Exception(NO_DATA_FOUND);
      }
      //Parsing the JSON Response
      SalesOrderResponse salesOrderResponse =
          SalesOrderResponse.fromJson(apiResponse);
      if (salesOrderResponse.message!.orderList!.isNotEmpty) {
        //Convert the api response to local model
        for (var order in salesOrderResponse.message!.orderList!) {
          if (!sales.any((element) => element.id == order.name)) {
            List<OrderItem> orderedProducts = [];

            //Ordered products
            for (var orderedProduct in order.items!) {
              List<Attribute> attributes = [];

              for (var attribute in orderedProduct.subItems!) {
                Option option = Option(
                    id: attribute.itemCode!,
                    name: attribute.itemName!,
                    price: attribute.amount!,
                    selected: false,
                    tax: attribute.tax!);

                Attribute orderedAttribute = Attribute(
                  name: attribute.itemName!,
                  type: '',
                  moq: 0,
                  options: [option],
                );

                attributes.add(orderedAttribute);
              }

              OrderItem product = OrderItem(
                  id: orderedProduct.itemCode!,
                  name: orderedProduct.itemName!,
                  group: '',
                  description: '',
                  stock: 0,
                  price: orderedProduct.rate!,
                  attributes: attributes,
                  orderedQuantity: orderedProduct.qty!,
                  productImage: Uint8List.fromList([]),
                  productImageUrl: orderedProduct.image,
                  productUpdatedTime: DateTime.now(),
                  tax: 0);

              orderedProducts.add(product);
            }

            String transactionDateTime =
                "${order.transactionDate} ${order.transactionTime}";
            String date = DateFormat('EEEE d, LLLL y')
                .format(DateTime.parse(transactionDateTime))
                .toString();
            log('Date :2 $date');

            //Need to convert 2:26:17 to 02:26 AM
            String time = DateFormat()
                .add_jm()
                .format(DateTime.parse(transactionDateTime))
                .toString();
            log('Time : $time');

            Transaction sale = Transaction(
              id: order.name!,
              customer: Customer(
                id: order.customer!,
                name: order.customerName!,
                phone: order.contactMobile!,
                email: order.contactEmail!,
              ),
              items: orderedProducts,
              orderAmount: order.grandTotal!,
              date: date,
              time: time,
              tracsactionDateTime: DateTime.parse(
                  '${order.transactionDate} ${order.transactionTime}'),
            );

            sales.add(sale);
          }
        }
        return sales;
      } else {
        return [];
      }
    } catch (ex) {
      debugPrint("Exception occured $ex");
      debugPrintStack();
      log(ex.toString());
      return [];
    }
  }

  Future<List<Transaction>> _searchTransactions(String query) async {
    if (await Helper.isNetworkAvailable()) {
      String hubManagerId = await DBPreferences().getPreference(HubManagerId);
      //Creating GET api url
      String apiUrl = SALES_HISTORY;
      apiUrl += '?hub_manager=$hubManagerId&txt=$query';
      return _processRequest(apiUrl);
    }

    throw Exception("Error fetching transactions");
  }
}
