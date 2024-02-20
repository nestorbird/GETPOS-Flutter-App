import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_posx/core/tablet/close_shift/close_shift_landscape.dart';
import 'package:nb_posx/core/tablet/open_shift/open_shift_management_landscape.dart';
import 'package:nb_posx/database/models/park_order.dart';
import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/ui_utils/padding_margin.dart';

import 'create_order/create_order_landscape.dart';
import 'customer/customers_landscape.dart';
import 'my_account/my_account_landscape.dart';
import 'parked_order/orderlist_parked_landscape.dart';
import 'transaction/transaction_screen_landscape.dart';
import 'widget/left_side_menu.dart';

// ignore: must_be_immutable
class HomeTablet extends StatelessWidget {
  bool isShiftCreated;
  HomeTablet({Key? key,this.isShiftCreated=false}) : super(key: key);

  final selectedTab = "Order".obs;
  
 ParkOrder? parkOrder;
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
          // isShiftCreated?LeftSideMenu(selectedView: "Open Shift".obs):
          LeftSideMenu(selectedView: selectedTab),
          Container(
            color: const Color(0xFFF9F8FB),
            padding: paddingXY(x:10),
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
/*case "Home":
        //return const HomeLandscape();
        return CreateOrderLandscape(selectedView: selectedTab);*/
      case "Order":
        return CreateOrderLandscape(selectedView: selectedTab, order:parkOrder ,isShiftCreated: true,);
      /*   case "Product":
        return const ProductsLandscape();*/
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
        case "Open Shift":
        return OpenShiftManagement(selectedView: selectedTab);
    }
  }
}
