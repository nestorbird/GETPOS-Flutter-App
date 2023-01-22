import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';

import '../../../../database/db_utils/db_sale_order.dart';
import '../../../../database/models/sale_order.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';

import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/long_button_widget.dart';
import '../../../service/create_order/api/create_sales_order.dart';
import '../../create_order_new/ui/new_create_order.dart';

class SaleSuccessScreen extends StatefulWidget {
  final SaleOrder placedOrder;
  const SaleSuccessScreen({Key? key, required this.placedOrder})
      : super(key: key);

  @override
  State<SaleSuccessScreen> createState() => _SaleSuccessScreenState();
}

class _SaleSuccessScreenState extends State<SaleSuccessScreen> {
  @override
  void initState() {
    super.initState();
    log("${widget.placedOrder}");
    CreateOrderService().createOrder(widget.placedOrder).then((value) {
      if (value.status!) {
        // print("create order response::::YYYYY");
        SaleOrder order = widget.placedOrder;
        order.transactionSynced = true;
        order.id = value.message;
        order.save();

        DbSaleOrder()
            .createOrder(order)
            .then((value) => debugPrint('order sync and saved to db'));
      } else {
        DbSaleOrder()
            .createOrder(widget.placedOrder)
            .then((value) => debugPrint('order saved to db'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              SUCCESS_IMAGE,
              height: SALE_SUCCESS_IMAGE_HEIGHT,
              width: SALE_SUCCESS_IMAGE_WIDTH,
              fit: BoxFit.contain,
            ),
          ),
          hightSpacer30,
          Text(
            SALES_SUCCESS_TXT,
            style: getTextStyle(
                fontSize: LARGE_FONT_SIZE,
                color: BLACK_COLOR,
                fontWeight: FontWeight.w600),
          ),
          hightSpacer30,
          LongButton(
            isAmountAndItemsVisible: false,
            buttonTitle: "Print Reciept",
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          LongButton(
            isAmountAndItemsVisible: false,
            buttonTitle: RETURN_TO_HOME_TXT,
            onTap: () {
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
          LongButton(
            isAmountAndItemsVisible: false,
            buttonTitle: "New Order",
            onTap: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => NewCreateOrder()),
                  (route) => route.isFirst);
            },
          ),
        ],
      ),
    );
  }
}
