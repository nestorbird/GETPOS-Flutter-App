import 'dart:convert';
import 'dart:developer';

import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/core/mobile/create_order_new/ui/widget/calculate_taxes.dart';
import 'package:nb_posx/core/mobile/orderwise_taxation/orderwise_tax_response.dart'
    as cat_resp;
import 'package:nb_posx/core/service/create_order/model/create_sales_order_response.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import 'package:nb_posx/network/service/api_utils.dart';
import 'package:nb_posx/utils/helper.dart';

class OrderwiseTaxes {
  Future<CommanResponse> getOrderwiseTaxes() async {
    if (await Helper.isNetworkAvailable()) {
      var orderwisetaxespath = "$ORDERWISE_TAXES_PATH";
      //Call to orderwise taxes api
      var apiResponse =
          await APIUtils.getRequestWithHeaders(orderwisetaxespath);
      log(jsonEncode(apiResponse));

      cat_resp.OrderWiseTaxation resp =
          cat_resp.OrderWiseTaxation.fromJson(apiResponse);

      cat_resp.OrderWiseTaxation.fromJson(apiResponse);

      if (resp.message.isNotEmpty) {
        await Future.forEach(resp.message, (catObj) async {
          var catData = catObj as cat_resp.Message;
          Messages messages = Messages(
              name: catData.name,
              isDefault: catData.isDefault,
              disabled: catData.disabled,
              taxCategory: catData.taxCategory,
              tax: []);
          //var data =(catData.disabled.)
          List<OrderTax> taxes = [];

          await Future.forEach(catData.tax, (taxObj) async {
            var taxData = taxObj as cat_resp.Tax;

            OrderTax ordertax = OrderTax(
              
              itemTaxTemplate: taxData.itemTaxTemplate,
              taxType: taxData.taxType,
              taxRate: taxData.taxRate,
            );
            taxes.add(ordertax);
          });
        });

        // await DbTaxes().addTaxes(taxes);

        await DBPreferences().savePreference(
            PRODUCT_LAST_SYNC_DATETIME, Helper.getCurrentDateTime());

        return CommanResponse(
            status: true,
            message: SUCCESS,
            apiStatus: ApiStatus.REQUEST_SUCCESS);
      }

      // API Failure
      else {
        //returning the CommanResponse as false with message from api.
        return CommanResponse(
            status: false,
            message: NO_PRODUCTS_FOUND_MSG,
            apiStatus: ApiStatus.REQUEST_FAILURE);
      }
    }

    // If internet is not available
    else {
      return CommanResponse(
          status: false,
          message: NO_INTERNET,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }
}
