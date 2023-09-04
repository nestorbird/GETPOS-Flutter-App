import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_posx/database/db_utils/db_parked_order.dart';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/models/park_order.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../widget/alert_dialog_widget.dart';

// ignore: must_be_immutable
class ParkedDataItemLandscape extends StatelessWidget {
  ParkOrder order;
  Function onDelete;
  Function onSelect;
  ParkedDataItemLandscape(
      {Key? key,
      required this.order,
      required this.onDelete,
      required this.onSelect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelect(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: GREY_COLOR, width: 0.4),
          borderRadius: BorderRadius.circular(5),
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
                        fontWeight: FontWeight.w400),
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
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () => _handleDelete(context),
                    child: SvgPicture.asset(
                      DELETE_IMAGE,
                      color: MAIN_COLOR,
                      width: 15,
                    ),
                  ),
                  hightSpacer10,
                  Text(
                    // '27th Jul 2021, 11:00AM ',
                    '${order.date} ${order.time}',
                    style: getTextStyle(
                        fontSize: MEDIUM_PLUS_FONT_SIZE,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleDelete(BuildContext context) async {
    var response = await AlertDialogWidget().show(
        "Do you want to delete this parked order", OPTION_YES,
        hasCancelAction: true);

    if (response == "yes") {
      DbParkedOrder().deleteOrder(order);
      onDelete();
      await AlertDialogWidget()
          .show("Parked order deleted successfully", OPTION_CONTINUE);
    }
  }

  _handleOrderDetails() async {
    ///TODO:::
    /// Handle park order click to move to order screen
  }
}
