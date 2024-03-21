import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_posx/core/tablet/close_shift/close_shift_landscape.dart';
import 'package:nb_posx/core/tablet/open_shift/open_shift_management_landscape.dart';
import 'package:nb_posx/database/models/park_order.dart';
import 'package:nb_posx/database/db_utils/db_hub_manager.dart';
import 'package:nb_posx/database/models/hub_manager.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:nb_posx/utils/ui_utils/padding_margin.dart';
import 'package:nb_posx/widgets/customer_tile.dart';

import 'create_order/create_order_landscape.dart';
import 'customer/customers_landscape.dart';
import 'my_account/my_account_landscape.dart';
import 'parked_order/orderlist_parked_landscape.dart';
import 'transaction/transaction_screen_landscape.dart';
import 'widget/left_side_menu.dart';

// Define a callback function type
typedef OnCheckChangedCallback = void Function(bool isChecked);
// ignore: must_be_immutable
class HomeTablet extends StatefulWidget {
  bool isShiftCreated;
   final OnCheckChangedCallback? onCheckChanged;
  HomeTablet({Key? key, required this.isShiftCreated, this.onCheckChanged}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeTabletState createState() => _HomeTabletState();
}

class _HomeTabletState extends State<HomeTablet> {
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
            LeftSideMenu(selectedView: selectedTab, isShiftCreated:widget.isShiftCreated),
            Container(
              color: const Color(0xFFF9F8FB),
              padding: paddingXY(x: 10),
              child: Obx(() => SizedBox(
                width: size.width - 100,
                height: size.height,
                child: _getSelectedView(),
              )),
            )
          ],
        ),
      ),
    );
  }

  _getHubManager() async {
    HubManager manager = await DbHubManager().getManager() as HubManager;
    Helper.hubManager = manager;
  }

  _getSelectedView() {
    switch (selectedTab.value) {
      case "Order":
        return CreateOrderLandscape(
          selectedView: selectedTab,
          order: parkOrder,
          isShiftCreated: widget.isShiftCreated,
          // Pass the callback function to the child widget
          onCheckChanged: widget.onCheckChanged,
        );
        // onChanged(val){}
      case "Customer":
        return const CustomersLandscape();
      case "My Profile":
        return const MyAccountLandscape();
      case "History":
        return TransactionScreenLandscape(selectedView: selectedTab);
      case "Parked Order":
        return OrderListParkedLandscape(selectedView: selectedTab);
      case "Open Shift":
        return OpenShiftManagement(selectedView: selectedTab, updateShiftStatus: _updateShiftStatus);
      case "Close Shift":
        return CloseShiftManagement(selectedView: selectedTab);
      default:
        return Container(); // Handle default case here
    }
  }

  // Callback function to update the shift status
  void _updateShiftStatus(bool isShiftCreated) {
    setState(() {
      widget.isShiftCreated = isShiftCreated;
    });
  }
}
