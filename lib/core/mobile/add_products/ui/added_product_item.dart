import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../database/models/attribute.dart';
import '../../../../database/models/order_item.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';

// ignore: must_be_immutable
class AddedProductItem extends StatefulWidget {
  Function? onDelete;
  Function? onItemAdd;
  Function? onItemRemove;
  OrderItem product;
  bool? disableDeleteOption;
  bool isUsedinVariantsPopup;

  AddedProductItem(
      {Key? key,
      required this.onDelete,
      required this.onItemAdd,
      required this.onItemRemove,
      this.disableDeleteOption = false,
      required this.product,
      this.isUsedinVariantsPopup = false})
      : super(key: key);

  @override
  State<AddedProductItem> createState() => _AddedProductItemState();
}

class _AddedProductItemState extends State<AddedProductItem> {
  final Widget _greySizedBox = SizedBox(
      width: 1.0,
      child: Container(
        color: AppColors.getPrimary(),
      ));

  @override
  Widget build(BuildContext context) {
    String selectedQty = widget.product.orderedQuantity < 10
        ? "0${widget.product.orderedQuantity.round()}"
        : "${widget.product.orderedQuantity.round()}";

    return Row(
      children: [
        Container(
          height: 90,
          width: 90,
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: AppColors.getPrimary().withOpacity(0.1),
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: widget.product.productImage.isEmpty
              ? SvgPicture.asset(
                  PRODUCT_IMAGE_SMALL,
                  fit: BoxFit.contain,
                )
              : Image.memory(
                  widget.product.productImage,
                  fit: BoxFit.fill,
                ),
        ),
        widthSpacer(15),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.product.name,
                  style: getTextStyle(fontSize: SMALL_PLUS_FONT_SIZE),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Row(children: [
                  Visibility(
                      visible: !widget.disableDeleteOption!,
                      child: InkWell(
                          onTap: () => widget.onDelete!(),
                          child: Padding(
                              padding: miniPaddingAll(),
                              child: SvgPicture.asset(DELETE_IMAGE,
                                  height: 16,
                                  color: AppColors.getAsset(),
                                  fit: BoxFit.contain)))),
                  Visibility(
                      visible: widget.isUsedinVariantsPopup,
                      child: InkWell(
                          onTap: () => Navigator.pop(context),
                          child: Padding(
                              padding: miniPaddingAll(),
                              child: SvgPicture.asset(CROSS_ICON,
                                  height: 12,
                                  color: AppColors.getTextandCancelIcon(),
                                  fit: BoxFit.contain))))
                ]),
              ],
            ),
            // Text(
            //   widget.isUsedinVariantsPopup
            //       ? 'Item Code - ${widget.product.id}'
            //       : "${_getItemVariants(widget.product.attributes)} x ${widget.product.orderedQuantity.toInt()}",
            //   style: getTextStyle(
            //       fontSize: SMALL_FONT_SIZE, fontWeight: FontWeight.normal),
            //   overflow: TextOverflow.ellipsis,
            //   maxLines: 2,
            // ),
            hightSpacer15,
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$appCurrency ${widget.product.price.toStringAsFixed(2)}',
                    style: getTextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: SMALL_PLUS_FONT_SIZE,
                        color: AppColors.getPrimary()),
                  ),
                  Visibility(
                      visible: widget.isUsedinVariantsPopup,
                      child: Text(
                        "Stock - ${widget.product.stock}",
                        style: getTextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: SMALL_PLUS_FONT_SIZE,
                          color: AppColors.getSecondary(),
                        ),
                      )),
                ],
              ),
              Container(
                  width: 150,
                  height: 30,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.getPrimary(),
                      ),
                      borderRadius:
                          BorderRadius.circular(BORDER_CIRCULAR_RADIUS_08)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () => widget.onItemRemove!(),
                          child: const Icon(
                            Icons.remove,
                            size: 18,
                          )),
                      //   _greySizedBox,
                      Container(
                          color: AppColors.getPrimary().withOpacity(0.1),
                          child: Text(
                            selectedQty,
                            style: getTextStyle(
                              fontSize: MEDIUM_FONT_SIZE,
                              fontWeight: FontWeight.w600,
                              color: AppColors.getPrimary(),
                            ),
                          )),
                      //  _greySizedBox,
                      InkWell(
                          onTap: () => widget.onItemAdd!(),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                          )),
                    ],
                  ))
            ]),
          ],
        )),
      ],
    );

    // return ListTile(
    //   isThreeLine: true,
    //   contentPadding: horizontalSpace(x: 10),
    //   minVerticalPadding: 10,
    //   leading: SizedBox(
    //       // height: 70,
    //       // width: 70,
    //       child: Container(
    //           height: 100,
    //           width: 100,
    //           decoration: BoxDecoration(
    //               color: MAIN_COLOR.withOpacity(0.1),
    //               borderRadius: const BorderRadius.all(Radius.circular(10))),
    //           child: widget.product.productImage.isEmpty
    //               ? SvgPicture.asset(
    //                   PRODUCT_IMAGE_SMALL,
    //                   // height: 50,
    //                   // width: 50,
    //                   fit: BoxFit.contain,
    //                 )
    //               : Image.memory(widget.product.productImage))),
    //   title: Padding(
    //       padding: horizontalSpace(x: 5),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Expanded(
    //               child: Column(
    //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 widget.product.name,
    //                 style: getTextStyle(fontSize: SMALL_PLUS_FONT_SIZE),
    //                 overflow: TextOverflow.ellipsis,
    //                 maxLines: 2,
    //               ),
    //               Text(
    //                 "Item Code - ${widget.product.id}",
    //                 style: getTextStyle(
    //                     fontSize: SMALL_MINUS_FONT_SIZE,
    //                     color: DARK_GREY_COLOR,
    //                     fontWeight: FontWeight.normal),
    //               )
    //             ],
    //           )),
    //           Visibility(
    //             visible: !widget.disableDeleteOption!,
    //             child: InkWell(
    //                 onTap: () => widget.onDelete!(),
    //                 child: Padding(
    //                     padding: miniPaddingAll(),
    //                     child: SvgPicture.asset(
    //                       DELETE_IMAGE,
    //                       height: 15,
    //                       // width: 20,
    //                       color: DARK_GREY_COLOR,
    //                       fit: BoxFit.contain,
    //                     ))),
    //           )
    //         ],
    //       )),
    //   subtitle: Padding(
    //       padding: horizontalSpace(x: 5),
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //         children: [
    //           Column(
    //             mainAxisAlignment: MainAxisAlignment.end,
    //             crossAxisAlignment: CrossAxisAlignment.start,
    //             children: [
    //               Text(
    //                 "$ADD_PRODUCTS_AVAILABLE_STOCK_TXT - ${widget.product.stock}",
    //                 style: getTextStyle(
    //                   fontWeight: FontWeight.normal,
    //                   fontSize: SMALL_MINUS_FONT_SIZE,
    //                   color: WHITE_COLOR,
    //                 ),
    //               ),
    //               Text(
    //                 '$APP_CURRENCY ${widget.product.orderedPrice}',
    //                 style: getTextStyle(
    //                     fontWeight: FontWeight.w400,
    //                     fontSize: SMALL_PLUS_FONT_SIZE,
    //                     color: MAIN_COLOR),
    //               ),
    //             ],
    //           ),
    //           Container(
    //               width: 100,
    //               height: 25,
    //               decoration: BoxDecoration(
    //                   border: Border.all(
    //                     color: GREY_COLOR,
    //                   ),
    //                   borderRadius:
    //                       BorderRadius.circular(BORDER_CIRCULAR_RADIUS_08)),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                 children: [
    //                   InkWell(
    //                       onTap: () => widget.onItemAdd!(),
    //                       child: const Icon(
    //                         Icons.add,
    //                         size: 18,
    //                         color: DARK_GREY_COLOR,
    //                       )),
    //                   _greySizedBox,
    //                   Text(
    //                     selectedQty,
    //                     style: getTextStyle(
    //                         fontSize: MEDIUM_FONT_SIZE,
    //                         fontWeight: FontWeight.w600,
    //                         color: MAIN_COLOR),
    //                   ),
    //                   _greySizedBox,
    //                   InkWell(
    //                       onTap: () => widget.onItemRemove!(),
    //                       child: const Icon(
    //                         Icons.remove,
    //                         size: 18,
    //                         color: DARK_GREY_COLOR,
    //                       )),
    //                 ],
    //               ))
    //         ],
    //       )),
    // );
  }

  String _getItemVariants(List<Attribute> itemVariants) {
    String variants = '';
    if (itemVariants.isNotEmpty) {
      for (var variantData in itemVariants) {
        for (var selectedOption in variantData.options) {
          if (selectedOption.selected) {
            variants = variants.isEmpty
                ? '${selectedOption.name} [$appCurrency ${selectedOption.price.toStringAsFixed(2)}]'
                : "$variants, ${selectedOption.name} [$appCurrency ${selectedOption.price.toStringAsFixed(2)}]";
          }
        }
      }
    }
    return variants;
  }
}
