import 'package:flutter/material.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/customer_tile.dart';
import '../model/transaction.dart';
import 'widgets/header_data.dart';
import 'widgets/transaction_detail_item.dart';

class TransactionDetailScreen extends StatefulWidget {
  final Transaction order;
  const TransactionDetailScreen({Key? key, required this.order})
      : super(key: key);

  @override
  State<TransactionDetailScreen> createState() =>
      _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppbar(
              title: SALES_DETAILS_TXT,
              hideSidemenu: true,
            ),
            hightSpacer30,
            Padding(
                padding: horizontalSpace(x: 13),
                child: Row(
                  children: [
                    TransactionHeaderData(
                      heading: SALES_ID,
                      headingColor: DARK_GREY_COLOR,
                      content: widget.order.id,
                    ),
                    widthSpacer(50),
                    TransactionHeaderData(
                      heading: SALE_AMOUNT_TXT,
                      content:
                          '$appCurrency ${widget.order.orderAmount.toStringAsFixed(2)}',
                      headingColor: DARK_GREY_COLOR,
                      contentColor: MAIN_COLOR,
                      // crossAlign: CrossAxisAlignment.center,
                    ),
                  ],
                )),
            hightSpacer20,
            Padding(
                padding: horizontalSpace(x: 13),
                child: TransactionHeaderData(
                  heading: DATE_TIME,
                  headingColor: DARK_GREY_COLOR,
                  content: '${widget.order.date} ${widget.order.time}',
                )),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                hightSpacer20,
                Padding(
                    padding: horizontalSpace(x: 13),
                    child: Text(
                      CUSTOMER_INFO,
                      style: getTextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: MEDIUM_MINUS_FONT_SIZE,
                          color: DARK_GREY_COLOR),
                    )),
                hightSpacer5,
                CustomerTile(
                  isCheckBoxEnabled: false,
                  isDeleteButtonEnabled: false,
                  isSubtitle: false,
                  customer: widget.order.customer,
                  isHighlighted: true,
                )
              ],
            ),
            hightSpacer20,
            Padding(
                padding: horizontalSpace(x: 13),
                child: Text(
                  ITEMS_SUMMARY,
                  style: getTextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: MEDIUM_MINUS_FONT_SIZE,
                      color: DARK_GREY_COLOR),
                )),
            hightSpacer10,
            ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: widget.order.items.length,
                itemBuilder: (context, position) {
                  return TransactionDetailItem(
                    product: widget.order.items[position],
                  );
                })
          ],
        )),
      ),
    );
  }
}
