import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../utils/ui_utils/card_border_shape.dart';

import '../../../../utils/helper.dart';
import '../../../../database/models/sale_order.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';

import 'package:flutter/material.dart';

import 'sales_details.dart';

// ignore: must_be_immutable
class SalesDataItem extends StatelessWidget {
  SaleOrder? saleOrder;

  SalesDataItem({Key? key, this.saleOrder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SalesDetailsScreen(
                      saleOrder: saleOrder,
                    )));
      },
      child: Card(
        shape: cardBorderShape(),
        margin: const EdgeInsets.fromLTRB(10, 2, 10, 5),
        child: Container(
          padding: mediumPaddingAll(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$SALES_ID - ${saleOrder!.id}',
                style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
              ),
              hightSpacer4,
              Text(
                '${saleOrder!.date} ${saleOrder!.time}',
                style: getItalicStyle(fontSize: SMALL_FONT_SIZE),
              ),
              hightSpacer7,
              Row(
                children: [
                  Text(
                    '$appCurrency ${saleOrder!.orderAmount}',
                    style: getTextStyle(
                        fontSize: SMALL_PLUS_FONT_SIZE, color: MAIN_COLOR),
                  ),
                  const Spacer(),
                  Text(
                    saleOrder!.paymentStatus,
                    style: getTextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: SMALL_PLUS_FONT_SIZE,
                        color: Helper.getPaymentStatusColor(
                            saleOrder!.paymentStatus)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
