import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../database/models/order_item.dart';
import '../../../../utils/ui_utils/card_border_shape.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';

// ignore: must_be_immutable
class AddedProductItem extends StatefulWidget {
  Function? onDelete;
  Function? onItemAdd;
  Function? onItemRemove;
  OrderItem product;
  bool? disableDeleteOption;

  AddedProductItem(
      {Key? key,
      required this.onDelete,
      required this.onItemAdd,
      required this.onItemRemove,
      this.disableDeleteOption = false,
      required this.product})
      : super(key: key);

  @override
  State<AddedProductItem> createState() => _AddedProductItemState();
}

class _AddedProductItemState extends State<AddedProductItem> {
  final Widget _greySizedBox =
      SizedBox(width: 1.0, child: Container(color: GREY_COLOR));

  @override
  Widget build(BuildContext context) {
    String selectedQty = widget.product.orderedQuantity < 10
        ? "0${widget.product.orderedQuantity.round()}"
        : "${widget.product.orderedQuantity.round()}";

    return ListTile(
      isThreeLine: false,
      contentPadding: horizontalSpace(x: 10),
      minVerticalPadding: 10,
      leading: SizedBox(
          // height: 70,
          // width: 70,
          child: Card(
              color: MAIN_COLOR.withOpacity(0.1),
              shape: cardBorderShape(),
              elevation: 0.0,
              child: widget.product.productImage.isEmpty
                  ? SvgPicture.asset(
                      PRODUCT_IMAGE_SMALL,
                      // height: 50,
                      // width: 50,
                      fit: BoxFit.contain,
                    )
                  : Image.memory(widget.product.productImage))),
      title: Padding(
          padding: horizontalSpace(x: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    style: getTextStyle(fontSize: SMALL_PLUS_FONT_SIZE),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    "Item Code - ${widget.product.id}",
                    style: getTextStyle(
                        fontSize: SMALL_MINUS_FONT_SIZE,
                        color: DARK_GREY_COLOR,
                        fontWeight: FontWeight.normal),
                  )
                ],
              )),
              Visibility(
                visible: !widget.disableDeleteOption!,
                child: InkWell(
                    onTap: () => widget.onDelete!(),
                    child: Padding(
                        padding: miniPaddingAll(),
                        child: SvgPicture.asset(
                          DELETE_IMAGE,
                          height: 15,
                          // width: 20,
                          color: DARK_GREY_COLOR,
                          fit: BoxFit.contain,
                        ))),
              )
            ],
          )),
      subtitle: Padding(
          padding: horizontalSpace(x: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$ADD_PRODUCTS_AVAILABLE_STOCK_TXT - ${widget.product.stock}",
                    style: getTextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: SMALL_MINUS_FONT_SIZE,
                      color: WHITE_COLOR,
                    ),
                  ),
                  Text(
                    '$APP_CURRENCY ${widget.product.orderedPrice}',
                    style: getTextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: SMALL_PLUS_FONT_SIZE,
                        color: MAIN_COLOR),
                  ),
                ],
              ),
              Container(
                  width: 100,
                  height: 25,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: GREY_COLOR,
                      ),
                      borderRadius:
                          BorderRadius.circular(BORDER_CIRCULAR_RADIUS_08)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      InkWell(
                          onTap: () => widget.onItemAdd!(),
                          child: const Icon(
                            Icons.add,
                            size: 18,
                            color: DARK_GREY_COLOR,
                          )),
                      _greySizedBox,
                      Text(
                        selectedQty,
                        style: getTextStyle(
                            fontSize: MEDIUM_FONT_SIZE,
                            fontWeight: FontWeight.w600,
                            color: MAIN_COLOR),
                      ),
                      _greySizedBox,
                      InkWell(
                          onTap: () => widget.onItemRemove!(),
                          child: const Icon(
                            Icons.remove,
                            size: 18,
                            color: DARK_GREY_COLOR,
                          )),
                    ],
                  ))
            ],
          )),
    );
  }
}
