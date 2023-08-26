import 'package:flutter/material.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';

import '../../../../../utils/ui_utils/card_border_shape.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../model/transaction.dart';
import '../transaction_detail_screen.dart';

class TransactionItem extends StatelessWidget {
  final Transaction order;
  const TransactionItem({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TransactionDetailScreen(
                      order: order,
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
                order.customer.name,
                style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
              ),
              hightSpacer4,
              Text(
                '$SALES_ID - ${order.id}',
                style: getTextStyle(fontSize: SMALL_FONT_SIZE),
              ),
              hightSpacer4,
              Text(
                '${order.date}, ${order.time}',
                style: getItalicStyle(fontSize: SMALL_FONT_SIZE),
              ),
              hightSpacer7,
              Row(
                children: [
                  Text(
                    '$appCurrency ${order.orderAmount.toStringAsFixed(2)}',
                    style: getTextStyle(
                        fontSize: SMALL_PLUS_FONT_SIZE, color: MAIN_COLOR),
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
