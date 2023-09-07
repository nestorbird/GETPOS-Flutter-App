import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/category.dart';
import 'package:nb_posx/database/models/hub_manager.dart';
import 'package:nb_posx/database/models/order_item.dart';
import 'package:nb_posx/database/models/park_order.dart';
import 'package:nb_posx/database/models/product.dart';
import 'package:nb_posx/database/models/sale_order.dart';
import 'package:nb_posx/utils%20copy/helper.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../database/models/customer.dart';
import '../utils/ui_utils/card_border_shape.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/spacer_widget.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';

class SimplePopup extends StatefulWidget {
  final String message;
  final String buttonText;
  final Function onOkPressed;
  final bool hasCancelAction;
  bool? barrier = false;

  SimplePopup(
      {Key? key,
      required this.message,
      this.barrier,
      required this.buttonText,
      required this.onOkPressed,
      this.hasCancelAction = false})
      : super(key: key);

  @override
  State<SimplePopup> createState() => _SimplePopupState();
}

Box<dynamic>? box;

class _SimplePopupState extends State<SimplePopup> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: widget.barrier == true ? _onBackPressed : _onBack,
        child: Container(
            height: 100,
            margin: morePaddingAll(x: 20),
            child: Center(
                child: Card(
              shape: cardBorderShape(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  hightSpacer15,
                  Text(
                    widget.message,
                    textAlign: TextAlign.center,
                    style: getTextStyle(fontSize: MEDIUM_PLUS_FONT_SIZE),
                  ),
                  hightSpacer20,
                  const Divider(),
                  widget.hasCancelAction
                      ? SizedBox(
                          height: 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                  onTap: () => widget.onOkPressed(),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: Center(
                                          child: Text(
                                        widget.buttonText,
                                        style: getTextStyle(
                                            fontSize: MEDIUM_MINUS_FONT_SIZE),
                                      )))),
                              const VerticalDivider(
                                thickness: 1,
                              ),
                              InkWell(
                                  onTap: () => Navigator.of(context).pop(),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          2.5,
                                      child: Center(
                                          child: Text(
                                        OPTION_CANCEL,
                                        style: getTextStyle(
                                            fontSize: MEDIUM_MINUS_FONT_SIZE,
                                            color: DARK_GREY_COLOR),
                                      ))))
                            ],
                          ),
                        )
                      : InkWell(
                          onTap: () => widget.onOkPressed(),
                          child: SizedBox(
                              height: 20,
                              width: MediaQuery.of(context).size.width - 30,
                              child: Center(
                                  child: Text(
                                widget.buttonText,
                                style: getTextStyle(
                                    fontSize: MEDIUM_MINUS_FONT_SIZE),
                              )))),
                  hightSpacer10
                ],
              ),
            ))));
  }

  /// HANDLE BACK BTN PRESS ON LOGIN SCREEN
  Future<bool> _onBackPressed() async {
    deleteCustomer();
    deleteHubManager();
    deleteProduct();
    deleteSales();
    deleteParkedOrder();

    deleteCategory();
    deleteCustomer();
    deleteURL();

    deleteOrderItem();
    SystemNavigator.pop();

    return false;
  }

  Future<bool> _onBack() async {
    return true;
  }
}

Future<void> deleteCustomer() async {
  box = await Hive.openBox<Customer>(CUSTOMER_BOX);
  await box!.clear();
  box!.close();
}

Future<void> deleteHubManager() async {
  box = await Hive.openBox<HubManager>(HUB_MANAGER_BOX);
  await box!.clear();
  box!.close();
}

Future<void> deleteProduct() async {
  box = await Hive.openBox<Product>(PRODUCT_BOX);
  await box!.clear();
  box!.close();
}

Future<void> deleteSales() async {
  box = await Hive.openBox<SaleOrder>(SALE_ORDER_BOX);
  await box!.clear();
  box!.close();
}

Future<void> deleteParkedOrder() async {
  box = await Hive.openBox<ParkOrder>(PARKED_ORDER_BOX);
  await box!.clear();
  box!.close();
}


Future<void> deleteCategory() async {
  box = await Hive.openBox<Category>(CATEGORY_BOX);
  await box!.clear();
  box!.close();
}



Future<void> deleteOrderItem() async {
  box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
  await box!.clear();
  box!.close();
}

Future<void> deleteURL() async {
  box = await Hive.openBox<String>(URL_BOX);
  await box!.clear();
  box!.close();
}
