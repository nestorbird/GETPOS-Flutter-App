import 'package:flutter/material.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';

import '../../../../database/models/sale_order.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/comman_tile_options.dart';
import '../../../../widgets/custom_appbar.dart';
import 'sales_details_item.dart';
import 'sales_header_data.dart';

// ignore: must_be_immutable
class SalesDetailsScreen extends StatefulWidget {
  SaleOrder? saleOrder;

  SalesDetailsScreen({Key? key, this.saleOrder}) : super(key: key);

  @override
  State<SalesDetailsScreen> createState() => _SalesDetailsScreenState();
}

class _SalesDetailsScreenState extends State<SalesDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomAppbar(title: SALES_DETAILS_TXT),
            hightSpacer30,
            Padding(
                padding: horizontalSpace(x: 13),
                child: Row(
                  children: [
                    Expanded(
                        flex: 2,
                        child: SalesHeaderAndData(
                          heading: SALES_ID,
                          content: widget.saleOrder!.id,
                        )),
                    Expanded(
                        flex: 2,
                        child: SalesHeaderAndData(
                          heading: SALE_AMOUNT_TXT,
                          content:
                              '$appCurrency ${widget.saleOrder!.orderAmount}',
                          headingColor: BLACK_COLOR,
                          contentColor: MAIN_COLOR,
                          crossAlign: CrossAxisAlignment.center,
                        )),
                    Expanded(
                        flex: 1,
                        child: SalesHeaderAndData(
                          heading: PAYMENT_STATUS,
                          content: widget.saleOrder!.paymentStatus,
                          crossAlign: CrossAxisAlignment.end,
                          contentColor: Helper.getPaymentStatusColor(
                              widget.saleOrder!.paymentStatus),
                        )),
                  ],
                )),
            hightSpacer20,
            Padding(
                padding: horizontalSpace(x: 13),
                child: SalesHeaderAndData(
                  heading: DATE_TIME,
                  content:
                      '${widget.saleOrder!.date} ${widget.saleOrder!.time}',
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
                      style: getTextStyle(fontWeight: FontWeight.w500),
                    )),
                hightSpacer5,
                CommanTileOptions(
                  isCheckBoxEnabled: false,
                  isDeleteButtonEnabled: false,
                  isSubtitle: true,
                  customer: widget.saleOrder!.customer,
                )
              ],
            ),
            hightSpacer20,
            Padding(
                padding: horizontalSpace(x: 13),
                child: Text(
                  '$ITEMS_SUMMARY (${widget.saleOrder!.items.length} $ITEM_TXT)',
                  style: getTextStyle(fontWeight: FontWeight.w500),
                )),
            hightSpacer10,
            ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: widget.saleOrder!.items.length,
                itemBuilder: (context, position) {
                  return SalesDetailsItems(
                    product: widget.saleOrder!.items[position],
                  );
                })
          ],
        )),
      ),
    );
  }
}
