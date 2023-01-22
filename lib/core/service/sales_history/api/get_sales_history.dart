import 'dart:developer';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import '../../../../../constants/app_constants.dart';
import '../../../mobile/sales_history/ui/sales_history.dart';
import '../model/sale_order_list_response.dart';

import '../../../../../database/db_utils/db_constants.dart';
import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/db_utils/db_preferences.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../../database/models/order_item.dart';
import '../../../../../database/models/sale_order.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';

class GetSalesHistory {
  int totalOrders = 1;
  double noOfPages = 0;

  Future<CommanResponse> getSalesHistory(int pageNo, String query) async {
    //If internet is available
    if (await Helper.isNetworkAvailable()) {
      //Fetching hub manager id/email from DbPreferences
      String hubManagerId = await DBPreferences().getPreference(HubManagerId);

      //Getting the hub manager
      HubManager? hubManager = await DbHubManager().getManager();

      //Fetching the local orders data
      List<SaleOrder> sales = [];

      //Creating GET api url
      String apiUrl = SALES_HISTORY;
      // apiUrl += '?hub_manager=$hubManagerId&page_no=$pageNo';
      if (query.length > 2) {
        apiUrl += '?hub_manager=$hubManagerId&txt=$query';
      } else {
        apiUrl += '?hub_manager=$hubManagerId&page_no=$pageNo';
      }

      //Call to Sales History api
      var apiResponse = await APIUtils.getRequestWithHeaders(apiUrl);

      // log('Sales History Response :: $apiResponse}');
      if (apiResponse["message"]["message"] != "success") {
        return CommanResponse(
            status: false,
            message: NO_DATA_FOUND,
            apiStatus: ApiStatus.NO_DATA_AVAILABLE);
      }

      //Parsing the JSON Response
      SalesOrderResponse salesOrderResponse =
          SalesOrderResponse.fromJson(apiResponse);

      SalesHistory.pageSize = salesOrderResponse.message!.numberOfOrders!;
      totalOrders = salesOrderResponse.message!.numberOfOrders!;
      noOfPages = (totalOrders / SalesHistory.pageSize).ceilToDouble();

      //If success response from api
      if (salesOrderResponse.message!.orderList!.isNotEmpty) {
        //Convert the api response to local model
        for (var order in salesOrderResponse.message!.orderList!) {
          if (!sales.any((element) => element.id == order.name)) {
            List<OrderItem> orderedProducts = [];

            //Ordered products
            for (var orderedProduct in order.items!) {
              OrderItem product = OrderItem(
                  id: orderedProduct.itemCode!,
                  // code: orderedProduct.itemCode,
                  name: orderedProduct.itemName!,
                  group: '',
                  description: '',
                  stock: 0,
                  price: orderedProduct.rate!,
                  attributes: [],
                  orderedQuantity: orderedProduct.qty!,
                  productImage: Uint8List.fromList([]),
                  productImageUrl: orderedProduct.image,
                  productUpdatedTime: DateTime.now());

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

            //Creating a SaleOrder
            SaleOrder saleOrder = SaleOrder(
              id: order.name!,
              date: date,
              time: time,
              customer: Customer(
                id: order.customer!,
                name: order.customerName!,
                phone: order.contactPhone!,
                email: order.contactEmail!,
              ),
              items: orderedProducts,
              manager: hubManager!,
              orderAmount: order.grandTotal!,
              tracsactionDateTime: DateTime.parse(
                  '${order.transactionDate} ${order.transactionTime}'),
              transactionId: order.mpesaNo!,
              paymentMethod: order.modeOfPayment!,
              paymentStatus: "",
              transactionSynced: true,
            );

            sales.add(saleOrder);
          }
        }

        return CommanResponse(
            status: true, message: sales, apiStatus: ApiStatus.REQUEST_SUCCESS);
      }

      //If failure response from api
      else {
        //Returning the comman response as false
        return CommanResponse(
            status: false,
            message: NO_DATA_FOUND,
            apiStatus: ApiStatus.REQUEST_FAILURE);
      }
    }

    //If internet connection is not available
    else {
      return CommanResponse(
          status: false,
          message: NO_INTERNET_LOADING_DATA_FROM_LOCAL,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }
}
