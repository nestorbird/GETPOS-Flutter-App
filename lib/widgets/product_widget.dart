import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:intl/intl.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../constants/asset_paths.dart';
import '../database/models/product.dart';
import '../utils/helper.dart';
import '../utils/ui_utils/box_shadow.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';

// ignore: must_be_immutable
class ProductWidget extends StatefulWidget {
  bool enableAddProductButton;
  String? title;
  Uint8List? asset;
  Product? product;
  Function? onAddToCart;

  ProductWidget(
      {Key? key,
      this.enableAddProductButton = false,
      this.title,
      this.asset,
      this.product,
      this.onAddToCart})
      : super(key: key);

  @override
  State<ProductWidget> createState() => _ProductWidgetState();
}

class _ProductWidgetState extends State<ProductWidget> {
  late double stockQty;
  String? price;
  String? productStockUpdateDate;

  @override
  void initState() {
    stockQty = widget.product!.stock > 0 ? widget.product!.stock : 0;
    price = Helper().formatCurrency(widget.product!.price);
    productStockUpdateDate = _getDateTimeString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_20),
          boxShadow: [boxShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: widget.enableAddProductButton ? 100 : 120,
              decoration: BoxDecoration(
                  color: MAIN_COLOR.withOpacity(.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(10),
                  )),
              child: Center(
                child: _getProductImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Text(
                widget.product!.name,
                style: getTextStyle(fontSize: MEDIUM_MINUS_FONT_SIZE),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 2),
              child: Text("$ITEM_CODE_TXT - ${widget.product!.id}",
                  style: getItalicStyle(
                    color: LIGHT_GREY_COLOR,
                    fontSize: SMALL_MINUS_FONT_SIZE,
                  )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 8, bottom: 5),
              child: Text("$appCurrency $price",
                  style: getTextStyle(
                      color: MAIN_COLOR,
                      fontWeight: FontWeight.w600,
                      fontSize: MEDIUM_MINUS_FONT_SIZE)),
            ),
            Padding(
              padding: leftSpace(x: 10),
              child: Text(
                  "$ADD_PRODUCTS_AVAILABLE_STOCK_TXT - ${stockQty.round()}",
                  style: getTextStyle(
                      color: DARK_GREY_COLOR, fontWeight: FontWeight.w400)),
            ),
            Visibility(
                visible: !widget.enableAddProductButton,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, top: 2),
                  child: Text(
                      "$ADD_PRODUCTS_STOCK_UPDATE_ON_TXT $productStockUpdateDate",
                      maxLines: 2,
                      style: getItalicStyle(
                        color: LIGHT_GREY_COLOR,
                        fontSize: SMALL_MINUS_FONT_SIZE,
                      )),
                )),
            Visibility(
                visible: widget.enableAddProductButton,
                child: Padding(
                    padding: const EdgeInsets.only(top: 6, bottom: 10),
                    child: SizedBox(
                      child: Container(
                        color: GREY_COLOR,
                        height: 0.2,
                      ),
                    ))),
            Visibility(
              visible: widget.enableAddProductButton,
              child: InkWell(
                child: Center(
                    child: Text(
                  stockQty < 1 ? OUT_OF_STOCK : ADD_PRODUCT_TXT,
                  style: getTextStyle(fontWeight: FontWeight.w500),
                )),
                onTap: () => widget.onAddToCart!(),
              ),
            )
          ],
        ),
      ),
    );
  }

  _getProductImage() {
    if (widget.asset != null && widget.asset!.isNotEmpty) {
      return Image.memory(
        widget.asset!,
        height: widget.enableAddProductButton ? 60 : 70,
      );
    } else {
      return SvgPicture.asset(
        PRODUCT_IMAGE,
        height: widget.enableAddProductButton ? 60 : 70,
      );
    }
  }

  _getDateTimeString() {
    String productUpdateDate =
        DateFormat.yMd().add_jm().format(widget.product!.productUpdatedTime);
    log('Formatted Date : $productUpdateDate');
    return productUpdateDate;
  }
}
