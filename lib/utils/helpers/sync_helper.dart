
import 'package:flutter/material.dart';
import 'package:nb_posx/core/service/orderwise_taxation/api/orderwise_api_service.dart';
import 'package:nb_posx/core/service/select_customer/api/create_customer.dart';
import 'package:nb_posx/database/db_utils/db_instance_url.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';

import '../../core/service/create_order/api/create_sales_order.dart';
import '../../core/service/customer/api/customer_api_service.dart';
import '../../core/service/my_account/api/get_hub_manager_details.dart';
import '../../core/service/product/api/products_api_service.dart';
import '../../core/service/sales_history/api/get_previous_order.dart';
import '../../database/db_utils/db_customer.dart';
import '../../database/db_utils/db_hub_manager.dart';
import '../../database/db_utils/db_preferences.dart';
import '../../database/db_utils/db_product.dart';
import '../../database/db_utils/db_sale_order.dart';
import '../../database/models/customer.dart';
import '../../database/models/sale_order.dart';
import '../helper.dart';

class SyncHelper {
  ///
  /// when user login into the app we follow this sync process
  ///
  Future<bool> loginFlow() async {
    await getDetails();
    await GetPreviousOrder().getOrdersOnLogin();

    return true;
  }

  ///
  /// when user is logged In and launching the app
  ///
  Future<bool> launchFlow(bool isUserLoggedIn) async {
    if (isUserLoggedIn) {
      await syncNowFlow();
      await DbSaleOrder().modifySevenDaysOrdersFromToday();
    }
    return true;
  }

  ///
  /// when user logout from the app we follow this sync process
  ///
  Future<bool> logoutFlow() async {
    await DbCustomer().deleteCustomers();
    await DbHubManager().delete();
    await DbProduct().deleteProducts();
    await DbSaleOrder().delete();
    await DBPreferences().delete();
    await DbInstanceUrl().deleteUrl();
    instanceUrl = 'getpos.in';
    return true;
  }

  ///
  /// This method take care of the offline order saved in the
  /// mobile database and then fetch the other updated details
  ///
  Future<bool> syncNowFlow() async {
    List<Customer> offlineCustomers = await DbCustomer().getOfflineCustomers();
    if (offlineCustomers.isNotEmpty) {
      await Future.forEach(offlineCustomers, (Customer customer) async {
        var res = await CreateCustomer()
            .createNew(customer.phone, customer.name, customer.email);
        if (res.status!) {
          Customer newCustomer = res.message as Customer;
          customer.id = newCustomer.id;
          customer.isSynced = true;
          customer.modifiedDateTime = DateTime.now();
          customer.save();
          //await DbCustomer().updateCustomer(customer);
        }
      });
    }

    List<SaleOrder> offlineOrders = await DbSaleOrder().getOfflineOrders();
    //List<SaleOrder> offlineOrders = await DbSaleOrder().getAllOrders();

    if (offlineOrders.isNotEmpty) {
      debugPrint("offline order is not empty");
      // ignore: unused_local_variable
      var result = await Future.forEach(offlineOrders, (SaleOrder order) async {
        var customers = await DbCustomer().getCustomer(order.customer.phone);
        order.customer.id = customers.first.id;
        order.save();

        var res = await CreateOrderService().createOrder(order);
        if (res.status!) {
          await DbSaleOrder().updateOrder(res.message, order);
        }
      });
    }
    await getDetails();
    // var isResp = await getDetails();
    // if (isResp== true){
    //   log('isResp:$isResp');
    //   return true;

    // }

    return true;
  }

  ///
  /// this take care of the hubmanager details, customer updated list and the product updated list
  /// if the Hubmanager device is connected to the Internet
  ///
  Future<bool> getDetails() async {
    if (await Helper.isNetworkAvailable()) {
      await HubManagerDetails().getAccountDetails();
      await CustomerService().getCustomers();
      await ProductsService().getCategoryProduct();
      await OrderwiseTaxes().getOrderwiseTaxes();
      // _ = await ProductsService().getProducts();
    }
    return true;
  }

  ///
  /// this process through the list of wards and if any ward's is_assigned property is set to 0
  /// customer of that ward will be deleted from the mobile database
  ///
  Future<void> checkCustomer(List wardList) async {
    debugPrint("TODO::: DOING NOTHING");
    // for (var item in wardList) {
    //   if (item["is_assigned"] == 0) {
    //     await DbCustomer().deleteWardCustomer(item["ward"]);
    //   }
    // }
  }
}
