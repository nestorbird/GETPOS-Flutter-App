import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
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
          border: Border.all(color: AppColors.shadowBorder!, width: 0.4),
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
                     overflow: TextOverflow.ellipsis,
                    style: getTextStyle(
                        fontSize: MEDIUM_PLUS_FONT_SIZE, fontWeight: FontWeight.w800),
                  ),
                  hightSpacer5,
                  Text(
                    order.customer.phone.isEmpty
                        ? "9090909090"
                        : order.customer.phone,
                    style: getTextStyle(
                        fontSize: MEDIUM_PLUS_FONT_SIZE,
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
                    fontSize: MEDIUM_PLUS_FONT_SIZE,
                    color: AppColors.getPrimary(),
                    fontWeight: FontWeight.w800),
              ),
            ),
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Order ID: ${order.id}',
                    overflow: TextOverflow.clip,
                    style: getTextStyle(
                        fontSize: MEDIUM_PLUS_FONT_SIZE,
                        fontWeight: FontWeight.w600),
                  ),
                  hightSpacer5,
                  Text(
                    // '27th Jul 2021, 11:00AM ',
                    '${order.date} ${order.time}',
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    
                    
                    style: getTextStyle(
                        fontSize: MEDIUM_FONT_SIZE,
                        color: const Color(0xFF707070),
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
