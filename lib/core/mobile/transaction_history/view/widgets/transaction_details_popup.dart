import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';

import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../model/transaction.dart';

class TransactionDetailsPopup extends StatelessWidget {
  final Transaction order;
  const TransactionDetailsPopup({Key? key, required this.order})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width / 2.2,
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 10),
                child: SvgPicture.asset(
                  CROSS_ICON,
                  color: BLACK_COLOR,
                  width: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.customer.name,
                      style: getTextStyle(
                          fontSize: LARGE_FONT_SIZE,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'ID: ${order.id}',
                      style: getTextStyle(
                          fontSize: LARGE_MINUS_FONT_SIZE,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                hightSpacer10,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      order.customer.phone.isEmpty
                          ? "9090909090"
                          : order.customer.phone,
                      style: getTextStyle(
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '27th Jul 2021, 11:00AM ',
                      // '${order.date} ${order.time}',
                      style: getTextStyle(
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.w300),
                    )
                  ],
                ),
                hightSpacer30,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${order.items.length} Items",
                      style: getTextStyle(
                          color: MAIN_COLOR,
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '₹ ${order.orderAmount}',
                      style: getTextStyle(
                          color: MAIN_COLOR,
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                const Divider(
                  color: GREY_COLOR,
                  thickness: 1,
                ),
                _getOrderDetails(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _getOrderDetails() {
    final itemCount = order.items.length;
    return SizedBox(
      height: itemCount < 10 ? itemCount * 70 : 10 * 50,
      child: ListView.builder(
        itemCount: itemCount, //order.items.length,
        itemBuilder: (context, index) => Padding(
          padding: paddingXY(x: 0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 50,
                  height: 50,
                  color: MAIN_COLOR,
                ),
              ),
              widthSpacer(15),
              Text(
                order.items.first.name,
                style: getTextStyle(
                    fontSize: MEDIUM_PLUS_FONT_SIZE,
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              Text(
                "₹ ${order.items.first.price}",
                style: getTextStyle(
                    color: GREEN_COLOR,
                    fontSize: MEDIUM_PLUS_FONT_SIZE,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                " x${order.items.first.orderedQuantity.round() == 0 ? index + 1 : order.items.first.orderedQuantity.round()}",
                style: getTextStyle(
                    color: MAIN_COLOR,
                    fontSize: MEDIUM_PLUS_FONT_SIZE,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
      ),
    );

    // return ListView.builder(
    //     itemCount: 5,
    //     itemBuilder: (BuildContext context, index) {
    //       return Row(
    //         children: [
    //           ClipRRect(
    //             child: Container(
    //               width: 50,
    //               height: 50,
    //               color: MAIN_COLOR,
    //             ),
    //             borderRadius: BorderRadius.circular(50),
    //           ),
    //           widthSpacer(15),
    //           Text(
    //             order.items.first.name,
    //             style: getTextStyle(
    //                 fontSize: MEDIUM_PLUS_FONT_SIZE,
    //                 fontWeight: FontWeight.w500),
    //           ),
    //           const Spacer(),
    //           Text(
    //             "₹ ${order.items.first.price}",
    //             style: getTextStyle(
    //                 color: GREEN_COLOR,
    //                 fontSize: MEDIUM_PLUS_FONT_SIZE,
    //                 fontWeight: FontWeight.w500),
    //           ),
    //           Text(
    //             " x${order.items.first.stock.round()}",
    //             style: getTextStyle(
    //                 color: MAIN_COLOR,
    //                 fontSize: MEDIUM_PLUS_FONT_SIZE,
    //                 fontWeight: FontWeight.w500),
    //           ),
    //         ],
    //       );
    //     });
  }
}
