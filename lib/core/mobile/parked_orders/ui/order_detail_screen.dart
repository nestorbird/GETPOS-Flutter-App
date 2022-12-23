import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';

import '../../../../../database/db_utils/db_parked_order.dart';
import '../../../../../database/models/order_item.dart';
import '../../../../../database/models/park_order.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/custom_appbar.dart';
import '../../../../../widgets/product_shimmer_widget.dart';
import '../../add_products/ui/added_product_item.dart';
import '../../checkout/ui/checkout_screen.dart';
import '../../create_order_new/ui/new_create_order.dart';
import 'widget/header_data.dart';

class OrderDetailScreen extends StatefulWidget {
  final ParkOrder order;
  const OrderDetailScreen({Key? key, required this.order}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomAppbar(
                  title: "Parked order details",
                ),
                hightSpacer20,
                Padding(
                    padding: horizontalSpace(x: 13),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: ParkedOrderHeaderData(
                              heading: "Customer Name",
                              headingColor: DARK_GREY_COLOR,
                              content: widget.order.customer.name,
                            )),
                        Expanded(
                            flex: 2,
                            child: ParkedOrderHeaderData(
                              heading: "Mobile",
                              content: widget.order.customer.phone,
                              headingColor: DARK_GREY_COLOR,
                              // crossAlign: CrossAxisAlignment.center,
                            )),
                        InkWell(
                          onTap: () => _handleOrderDelete(context,
                              "Do you want to delete this parked order"),
                          child: Container(
                            decoration: BoxDecoration(
                                color: MAIN_COLOR,
                                borderRadius: BorderRadius.circular(20)),
                            padding: miniPaddingAll(),
                            child: SvgPicture.asset(
                              DELETE_IMAGE,
                              color: WHITE_COLOR,
                              width: 15,
                            ),
                          ),
                        ),
                      ],
                    )),
                Padding(
                    padding: paddingXY(x: 13),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: ParkedOrderHeaderData(
                              heading: "Date & Time",
                              headingColor: DARK_GREY_COLOR,
                              content: Helper.getFormattedDateTime(
                                  widget.order.transactionDateTime),
                            )),
                      ],
                    )),
                Padding(
                    padding: paddingXY(x: 13, y: 0),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 2,
                            child: ParkedOrderHeaderData(
                              heading: "Order Amount",
                              headingColor: DARK_GREY_COLOR,
                              content:
                                  "$APP_CURRENCY ${widget.order.orderAmount}",
                              contentColor: MAIN_COLOR,
                            )),
                      ],
                    )),
                Padding(
                  padding: paddingXY(x: 16, y: 16),
                  child: Text(
                    "Items",
                    style: getTextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: MEDIUM_PLUS_FONT_SIZE,
                        color: DARK_GREY_COLOR),
                  ),
                ),
                productList(widget.order.items)
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Row(
              children: [
                _getAddMoreBtn(),
                _getCheckoutBtn(),
              ],
            ),
          )
        ],
      )),
    );
  }

  Widget productList(List<OrderItem> prodList) {
    return Padding(
      padding: horizontalSpace(),
      child: ListView.separated(
          separatorBuilder: (context, index) {
            return const Divider();
          },
          shrinkWrap: true,
          itemCount: prodList.isEmpty ? 10 : prodList.length,
          primary: false,
          itemBuilder: (context, position) {
            if (prodList.isEmpty) {
              return const ProductShimmer();
            } else {
              return InkWell(
                onTap: () {
                  // _openItemDetailDialog(context, prodList[position]);
                },
                child: AddedProductItem(
                  product: prodList[position],
                  onDelete: () => _handleItemDelete(
                      context,
                      "Are you sure you want to delete this item?",
                      prodList[position]),
                  onItemAdd: () {
                    setState(() {
                      if (prodList[position].orderedQuantity <
                          prodList[position].stock) {
                        prodList[position].orderedQuantity =
                            prodList[position].orderedQuantity + 1;
                        _updateOrderPriceAndSave();
                      }
                    });
                  },
                  onItemRemove: () {
                    setState(() {
                      if (prodList[position].orderedQuantity > 0) {
                        prodList[position].orderedQuantity =
                            prodList[position].orderedQuantity - 1;
                        if (prodList[position].orderedQuantity == 0) {
                          widget.order.items.remove(prodList[position]);
                          if (prodList.isEmpty) {
                            DbParkedOrder().deleteOrder(widget.order);
                            Navigator.pop(context, "reload");
                          } else {
                            _updateOrderPriceAndSave();
                          }
                        } else {
                          _updateOrderPriceAndSave();
                        }
                      }
                    });
                  },
                ),
              );
            }
          }),
    );
  }

  Widget _getCheckoutBtn() {
    return Expanded(
      child: Container(
        margin: paddingXY(x: 5, y: 5),
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: MAIN_COLOR,
        ),
        child: Row(
          children: [
            widthSpacer(15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${widget.order.items.length} Items",
                  style: getTextStyle(
                      fontSize: SMALL_FONT_SIZE,
                      color: WHITE_COLOR,
                      fontWeight: FontWeight.normal),
                ),
                Text("₹ ${widget.order.orderAmount}",
                    style: getTextStyle(
                        fontSize: LARGE_MINUS_FONT_SIZE,
                        fontWeight: FontWeight.w600,
                        color: WHITE_COLOR))
              ],
            ),
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              CheckoutScreen(order: widget.order)));
                },
                child: Text("Checkout",
                    textAlign: TextAlign.right,
                    style: getTextStyle(
                        fontSize: LARGE_MINUS_FONT_SIZE,
                        fontWeight: FontWeight.w400,
                        color: WHITE_COLOR)),
              ),
            ),
            widthSpacer(15)
          ],
        ),
      ),
    );
  }

  Widget _getAddMoreBtn() {
    return InkWell(
      onTap: () {
        Get.to(NewCreateOrder(order: widget.order));
      },
      child: Container(
        margin: paddingXY(x: 5, y: 0),
        padding: paddingXY(),
        height: 60,
        width: MediaQuery.of(context).size.width / 4,
        decoration: BoxDecoration(
            color: GREEN_COLOR, borderRadius: BorderRadius.circular(5)),
        child: Text(
          "Add more products",
          textAlign: TextAlign.center,
          style: getTextStyle(
              color: WHITE_COLOR,
              fontSize: MEDIUM_FONT_SIZE,
              fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  Future<void> _handleOrderDelete(BuildContext context, String msg) async {
    var res = await Helper.showConfirmationPopup(context, msg, OPTION_YES,
        hasCancelAction: true);
    if (res != OPTION_CANCEL.toLowerCase()) {
      bool result = await DbParkedOrder().deleteOrder(widget.order);
      if (result) {
        if (!mounted) return;
        await Helper.showConfirmationPopup(
            context, "Parked Order Deleted Successfully", OPTION_OK);
        if (!mounted) return;
        Navigator.pop(context, "reload");
      } else {
        if (!mounted) return;
        await Helper.showConfirmationPopup(context,
            "Something went wrong, Please try again later!!!", OPTION_OK);
      }
    }
  }

  Future<void> _handleItemDelete(
      BuildContext context, String msg, OrderItem itemToRemove) async {
    var res = await Helper.showConfirmationPopup(context, msg, OPTION_YES,
        hasCancelAction: true);
    if (res != OPTION_CANCEL.toLowerCase()) {
      bool result =
          await DbParkedOrder().removeOrderItem(widget.order, itemToRemove);
      if (result) {
        if (!mounted) return;
        await Helper.showConfirmationPopup(
            context, "Parked Order Item Deleted Successfully", OPTION_OK);
        if (widget.order.items.isEmpty) {
          if (!mounted) return;
          _handleOrderDelete(
              context, "Removing order as no Item in order remaining!!!");
        } else {
          setState(() {});
        }
      } else {
        if (!mounted) return;
        await Helper.showConfirmationPopup(context,
            "Something went wrong, Please try again later!!!", OPTION_OK);
      }
    }
  }

  void _updateOrderPriceAndSave() {
    double orderAmount = 0;
    for (OrderItem item in widget.order.items) {
      orderAmount += item.orderedPrice * item.orderedQuantity;
    }
    widget.order.orderAmount = orderAmount;

    DbParkedOrder().saveOrder(widget.order);
  }
}
