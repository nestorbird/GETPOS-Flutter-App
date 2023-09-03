import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';

import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../model/transaction.dart';
import 'transaction_details_popup.dart';

class TransactionItemLandscape extends StatelessWidget {
  final Transaction order;
  const TransactionItemLandscape({Key? key, required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _handleOrderDetails(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: GREY_COLOR, width: 0.4),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: morePaddingAll(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.customer.name,
                    style: getTextStyle(
                        fontSize: LARGE_FONT_SIZE, fontWeight: FontWeight.w500),
                  ),
                  hightSpacer10,
                  Text(
                    order.customer.phone.isEmpty
                        ? "9090909090"
                        : order.customer.phone,
                    style: getTextStyle(
                        fontSize: MEDIUM_FONT_SIZE,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            // hightSpacer7,
            Expanded(
              flex: 2,
              child: Text(
                '$appCurrency ${order.orderAmount}',
                style: getTextStyle(
                    fontSize: LARGE_MINUS_FONT_SIZE,
                    color: MAIN_COLOR,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Expanded(
              flex: 4,
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Order ID: ${order.id}',
                    overflow: TextOverflow.clip,
                    style: getTextStyle(
                        fontSize: MEDIUM_PLUS_FONT_SIZE,
                        fontWeight: FontWeight.w500),
                  ),
                  hightSpacer10,
                  Text(
                    textAlign: TextAlign.start,
                    // '27th Jul 2021, 11:00AM ',
                    '${order.date} ${order.time}',
                    overflow: TextOverflow.clip,
                    // textAlign: TextAlign.right,
                    style: getTextStyle(
                        fontSize: MEDIUM_MINUS_FONT_SIZE,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _handleOrderDetails() async {
    await Get.defaultDialog(
      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 0, y: 0),
      // custom: Container(),
      content: TransactionDetailsPopup(
        order: order,
      ),
    );
  }
}
