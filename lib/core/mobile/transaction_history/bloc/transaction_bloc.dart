import 'dart:async';
import 'dart:developer';
import 'dart:typed_data';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:nb_posx/core/service/sales_history/api/get_previous_order.dart';
import 'package:nb_posx/database/db_utils/db_sale_order.dart';
import 'package:nb_posx/database/models/attribute.dart';
import 'package:nb_posx/database/models/sale_order.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../../../constants/app_constants.dart';
import '../../../../database/db_utils/db_constants.dart';
import '../../../../database/db_utils/db_preferences.dart';
import '../../../../database/models/customer.dart';
import '../../../../database/models/option.dart';
import '../../../../database/models/order_item.dart';
import '../../../../network/api_constants/api_paths.dart';
import '../../../../network/service/api_utils.dart';
import '../../../../utils/helper.dart';
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
        if (state.hasReachedMax) return;
        final transactions = await _searchTransactions(event.text,
            orderSize: event.isSearchTextChanged ? 0 : state.orders.length);

        if (event.isSearchTextChanged) {
          return emit(state.copyWith(
              status: TransactionStatus.success,
              orders: transactions,
              hasReachedMax: false));
        } else {
          return emit(transactions.isEmpty
              ? state.copyWith(hasReachedMax: true)
              : state.copyWith(
                  status: TransactionStatus.success,
                  orders: List.of(state.orders)..addAll(transactions),
                  hasReachedMax: transactions.length < _listSize,
                ));
        }
      } else if (event.text.isEmpty) {
        //final transactions = await _fetchTransactions(0);
        return emit(state.copyWith(
          status: TransactionStatus.initial,
          orders: [],
          hasReachedMax: false,
        ));
      }
    }, transformer: throttleDroppable(throttleDuration));
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

//Future<List<Transaction>> _fetchTransactions([int orderSize = 0]) async {
//     if (await Helper.isNetworkAvailable()) {
//       int pageNo = 1;
//       if (orderSize > 0) {
//         var ord = orderSize / _listSize;
//         pageNo = (ord.ceilToDouble() + 1).toInt();
//       }
//       debugPrint("Current Page No: $pageNo");
//  await DbSaleOrder().modifySevenDaysOrdersFromToday();
//       String hubManagerId = await DBPreferences().getPreference(HubManagerId);

//       //Creating GET api url
//       String apiUrl = SALES_HISTORY;
//       apiUrl += '?hub_manager=$hubManagerId&page_no=$pageNo';


//    return _processRequest(apiUrl);
//     } 
Future<List<Transaction>> _fetchTransactions([int orderSize = 0]) async {
  // Fetch offline orders
  List<SaleOrder> offlineOrders = await DbSaleOrder().getOfflineOrders();

  // Combine both previous orders and offline orders
  List<Transaction> allTransactions = [];

  // Add offline orders to allTransactions
  for (var order in offlineOrders) {
    Transaction transaction = Transaction(
      id: order.id,
      date: order.date,
      time: order.time,
      customer: order.customer,
      items: order.items,
      orderAmount: order.orderAmount,
      tracsactionDateTime: order.tracsactionDateTime,
    );

    allTransactions.add(transaction);
  }

  // If the user is online, fetch online orders
  if (await Helper.isNetworkAvailable()) {
    int pageNo = 1;
    if (orderSize > 0) {
      var ord = orderSize / _listSize;
      pageNo = (ord.ceilToDouble() + 1).toInt();
    }
    debugPrint("Current Page No: $pageNo");
    
    await DbSaleOrder().modifySevenDaysOrdersFromToday();
    String hubManagerId = await DBPreferences().getPreference(HubManagerId);

    // Creating GET api url
    String apiUrl = SALES_HISTORY;
    apiUrl += '?hub_manager=$hubManagerId&page_no=$pageNo';

    // Fetch online orders
    List<Transaction> onlineTransactions = await _processRequest(apiUrl);

    // Add online orders to allTransactions
    for (var transaction in onlineTransactions) {
      // Check whether an order with the same id already exists
      bool orderExists =
          allTransactions.any((offlineTransaction) => offlineTransaction.id == transaction.id);

      // If the order doesn't exist, add it to allTransactions
      if (!orderExists) {
        allTransactions.add(transaction);
      }
    }
  

  return allTransactions;
}
  
   
    else {
    
    // Fetch offline orders
List<SaleOrder> offlineOrders = await DbSaleOrder().getOfflineOrders();

// Combine both previous orders and offline orders
List<Transaction> allTransactions = [];

// Add offline orders to allTransactions
for (var order in offlineOrders) {
  Transaction transaction = Transaction(
    id: order.id,
    date: order.date,
    time: order.time,
    customer: order.customer,
    items: order.items,
    orderAmount: order.orderAmount,
    tracsactionDateTime: order.tracsactionDateTime,
  );

  allTransactions.add(transaction);
}

GetPreviousOrder getPreviousOrder = GetPreviousOrder();
    List<Transaction> previousOrders = await getPreviousOrder.getSavedOrders();

   // return savedOrders;

//     // Fetch all previous orders from the local database
// List<SaleOrder> previousOrders = await DbSaleOrder().getOrders();

// to avoid duplicacy
for (var order in previousOrders) {
  // Check whether an order with the same id already exists
  bool orderExists = allTransactions.any((transaction) => transaction.id == order.id);

  // If the order doesn't exist, add it to allTransactions
  if (!orderExists) {
    Transaction transaction = Transaction(
      id: order.id,
      date: order.date,
      time: order.time,
      customer: order.customer,
      items: order.items,
      orderAmount: order.orderAmount,
      tracsactionDateTime: order.tracsactionDateTime,
    );

    allTransactions.add(transaction);
  }
  
}


return allTransactions;

    }
  
  }

   

// // Fetch offline orders
// List<SaleOrder> offlineOrders = await DbSaleOrder().getOfflineOrders();

// // Combine both previous orders and offline orders
// List<Transaction> allTransactions = [];

// // Add offline orders to allTransactions
// for (var order in offlineOrders) {
//   Transaction transaction = Transaction(
//     id: order.id,
//     date: order.date,
//     time: order.time,
//     customer: order.customer,
//     items: order.items,
//     orderAmount: order.orderAmount,
//     tracsactionDateTime: order.tracsactionDateTime,
//   );

//   allTransactions.add(transaction);
// }

// // Fetch all previous orders from the local database
// List<SaleOrder> previousOrders = await DbSaleOrder().getOrders();

// // to avoid duplicacy
// for (var order in previousOrders) {
//   // Check whether an order with the same id already exists
//   bool orderExists = allTransactions.any((transaction) => transaction.id == order.id);

//   // If the order doesn't exist, add it to allTransactions
//   if (!orderExists) {
//     Transaction transaction = Transaction(
//       id: order.id,
//       date: order.date,
//       time: order.time,
//       customer: order.customer,
//       items: order.items,
//       orderAmount: order.orderAmount,
//       tracsactionDateTime: order.tracsactionDateTime,
//     );

//     allTransactions.add(transaction);
//   }
// }

// return allTransactions;

//     }
 // }
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
                  tax: []);

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
                  isSynced: false,
                  modifiedDateTime: DateTime.now()),
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
     //await DbSaleOrder().saveOrders(sales);
        return sales;
          
        
      } 
      else {
        return [];
      }
      
    }
     catch (ex) {
      debugPrint("Exception occured $ex");
      debugPrintStack();
      log(ex.toString());
      return [];
    }
  }
  

      
    

  Future<List<Transaction>> _searchTransactions(String query,
      {int orderSize = 0}) async {
    if (await Helper.isNetworkAvailable()) {
      int pageNo = 1;
      if (orderSize > 0) {
        var ord = orderSize / _listSize;
        pageNo = (ord.ceilToDouble() + 1).toInt();
      }
      debugPrint("Search Sales Order - Current Page No: $pageNo");

      String hubManagerId = await DBPreferences().getPreference(HubManagerId);
      //Creating GET api url
      String apiUrl = SALES_HISTORY;
      apiUrl += '?hub_manager=$hubManagerId&mobile_no=$query&page_no=$pageNo';
      return _processRequest(apiUrl);
    }

    throw Exception("Error fetching transactions");
  }
  // Future<void> getOrdersFromDB(val) async {
  //   //Fetch the data from local database
  // order = await DbSaleOrder().getOrders();
  //   isOrdersFound = order.isNotEmpty;
  //   if (val == 0) setState(() {});
    
  // }
}
  