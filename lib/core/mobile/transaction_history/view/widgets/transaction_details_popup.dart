import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/database/models/attribute.dart';
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
                padding: const EdgeInsets.only(right: 15),
                child: SvgPicture.asset(
                  CROSS_ICON,
                  color: BLACK_COLOR,
                  width: 20,
                  height: 20,
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
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Order ID: ${order.id}',
                      style: getTextStyle(
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
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
                      //'27th Jul 2021, 11:00AM ',
                      '${order.date} ${order.time}',
                      style: getTextStyle(
                          fontSize: MEDIUM_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.w500),
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
                      '$appCurrency ${order.orderAmount}',
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
                hightSpacer20,
                _promoCodeSection(),
                _subtotalSection("Subtotal", "$appCurrency 0.00"),
                _subtotalSection("Discount", "- $appCurrency 0.00",
                    isDiscount: true),
                // _subtotalSection("Tax (0%)", "$appCurrency 0.00"),
                _totalSection("Total", "$appCurrency ${order.orderAmount}"),
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
                  child: Image.network(
                    order.items[index].productImageUrl ??
                        "assets/images/burgar_img.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              widthSpacer(15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.items[index].name,
                    style: getTextStyle(
                        fontSize: MEDIUM_PLUS_FONT_SIZE,
                        fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  SizedBox(
                    width: 350,
                    child: Text(
                      "${_getItemVariants(order.items[index].attributes)} x ${order.items[index].orderedQuantity}",
                      style: getTextStyle(
                          fontSize: SMALL_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      softWrap: false,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                "$appCurrency ${order.items[index].price.toStringAsFixed(2)}",
                style: getTextStyle(
                    color: GREEN_COLOR,
                    fontSize: MEDIUM_PLUS_FONT_SIZE,
                    fontWeight: FontWeight.w500),
              ),
              widthSpacer(5),
              Text(
                " x${order.items[index].orderedQuantity.round() == 0 ? index + 1 : order.items[index].orderedQuantity.round()}",
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

  Widget _promoCodeSection() {
    return Container(
      // height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
          color: MAIN_COLOR.withOpacity(0.1),
          border: Border.all(width: 1, color: MAIN_COLOR.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Promo Code",
            style: getTextStyle(
                fontWeight: FontWeight.w500,
                color: MAIN_COLOR,
                fontSize: MEDIUM_PLUS_FONT_SIZE),
          ),
          // Column(
          //   children: [
          //     // Text(
          //     //   "Deal 20",
          //     //   style: getTextStyle(
          //     //       fontWeight: FontWeight.w600,
          //     //       color: MAIN_COLOR,
          //     //       fontSize: MEDIUM_PLUS_FONT_SIZE),
          //     // ),
          //     const SizedBox(height: 2),
          //     Row(
          //       children: List.generate(
          //           15,
          //           (index) => Container(
          //                 width: 2,
          //                 height: 1,
          //                 margin: const EdgeInsets.symmetric(horizontal: 1),
          //                 color: MAIN_COLOR,
          //               )),
          //     )
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _subtotalSection(title, amount, {bool isDiscount = false}) => Padding(
        padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getTextStyle(
                  fontWeight: FontWeight.w500,
                  color: isDiscount ? GREEN_COLOR : BLACK_COLOR,
                  fontSize: MEDIUM_PLUS_FONT_SIZE),
            ),
            Text(
              amount,
              style: getTextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDiscount ? GREEN_COLOR : BLACK_COLOR,
                  fontSize: MEDIUM_PLUS_FONT_SIZE),
            ),
          ],
        ),
      );

  Widget _totalSection(title, amount) => Padding(
        padding: const EdgeInsets.only(top: 6, left: 8, right: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getTextStyle(
                  fontWeight: FontWeight.w700,
                  color: BLACK_COLOR,
                  fontSize: LARGE_FONT_SIZE),
            ),
            Text(
              amount,
              style: getTextStyle(
                  fontWeight: FontWeight.w700, fontSize: LARGE_FONT_SIZE),
            ),
          ],
        ),
      );
}

String _getItemVariants(List<Attribute> itemVariants) {
  String variants = '';
  if (itemVariants.isNotEmpty) {
    for (var variantData in itemVariants) {
      for (var selectedOption in variantData.options) {
        if (!selectedOption.selected) {
          variants = variants.isEmpty
              ? '${selectedOption.name} [$appCurrency ${selectedOption.price.toStringAsFixed(2)}]'
              : "$variants, ${selectedOption.name} [$appCurrency ${selectedOption.price.toStringAsFixed(2)}]";
        }
      }
    }
  }
  return variants;
}
