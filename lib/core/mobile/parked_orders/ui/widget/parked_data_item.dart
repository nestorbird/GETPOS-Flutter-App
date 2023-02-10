import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/models/park_order.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';

// ignore: must_be_immutable
class ParkedDataItem extends StatelessWidget {
  ParkOrder? saleOrder;
  Function onDelete;
  Function onClick;

  ParkedDataItem(
      {Key? key, this.saleOrder, required this.onDelete, required this.onClick})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String dateTime = "${saleOrder!.date} ${saleOrder!.time}";
    String date = DateFormat('EEEE, d LLLL y')
        .format(DateTime.parse(dateTime))
        .toString();

    String time =
        DateFormat().add_jm().format(DateTime.parse(dateTime)).toString();

    return InkWell(
      onTap: () => onClick(),
      child: Container(
        decoration: BoxDecoration(
          // color: GREY_COLOR,
          border: Border.all(color: GREY_COLOR),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: mediumPaddingAll(),
        padding: mediumPaddingAll(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  saleOrder!.customer.name,
                  // '${saleOrder!.date} ${saleOrder!.time}',
                  style: getTextStyle(
                      fontSize: MEDIUM_FONT_SIZE, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  saleOrder!.customer.phone,
                  // '${saleOrder!.date} ${saleOrder!.time}',
                  style: getTextStyle(
                      fontSize: MEDIUM_FONT_SIZE, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            hightSpacer4,
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$date, $time",
                      // '$PARKED_ORDER_ID - ${saleOrder!.id}',
                      style: getItalicStyle(fontSize: SMALL_FONT_SIZE),
                    ),
                    hightSpacer7,
                    Text(
                      '$appCurrency ${saleOrder!.orderAmount.toStringAsFixed(2)}',
                      style: getTextStyle(
                          fontSize: SMALL_PLUS_FONT_SIZE, color: MAIN_COLOR),
                    ),
                  ],
                ),
                const Spacer(),
                InkWell(
                  onTap: () => onDelete(),
                  child: Padding(
                    padding: mediumPaddingAll(),
                    child: SvgPicture.asset(
                      DELETE_IMAGE,
                      color: MAIN_COLOR,
                      width: 15,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
