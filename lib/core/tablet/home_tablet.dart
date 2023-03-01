import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/ui_utils/padding_margin.dart';

import 'create_order/create_order_landscape.dart';
import 'customer/customers_landscape.dart';
import 'home/home_landscape.dart';
import 'my_account/my_account_landscape.dart';
import 'parked_order/orderlist_parked_landscape.dart';
import 'product/products_landscape.dart';
import 'transaction/transaction_screen_landscape.dart';
import 'widget/left_side_menu.dart';

// ignore: must_be_immutable
class HomeTablet extends StatelessWidget {
  HomeTablet({Key? key}) : super(key: key);

  final selectedTab = "Order".obs;

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    _getHubManager();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LeftSideMenu(selectedView: selectedTab),
          Container(
            color: const Color(0xFFF9F8FB),
            padding: paddingXY(),
            child: Obx(() => SizedBox(
                  width: size.width - 100,
                  height: size.height,
                  child: _getSelectedView(),
                )),
          )
        ],
      )),
    );
  }

  _getHubManager() async {
    HubManager manager = await DbHubManager().getManager() as HubManager;
    Helper.hubManager = manager;
  }

  _getSelectedView() {
    switch (selectedTab.value) {
      case "Home":
        //return const HomeLandscape();
        return CreateOrderLandscape(selectedView: selectedTab);
      case "Order":
        return CreateOrderLandscape(selectedView: selectedTab);
      case "Product":
        return const ProductsLandscape();
      case "Customer":
        return const CustomersLandscape();
      case "My Profile":
        return const MyAccountLandscape();
      case "History":
        return TransactionScreenLandscape(
          selectedView: selectedTab,
        );
      case "Parked Order":
        return OrderListParkedLandscape(selectedView: selectedTab);
    }
  }
}
