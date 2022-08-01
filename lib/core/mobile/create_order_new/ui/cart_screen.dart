import 'package:flutter/material.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';

import '../../../../../database/db_utils/db_parked_order.dart';
import '../../../../../database/models/order_item.dart';
import '../../../../../database/models/park_order.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/custom_appbar.dart';
import '../../../../../widgets/customer_tile.dart';
import '../../../../../widgets/product_shimmer_widget.dart';
import '../../add_products/ui/added_product_item.dart';
import '../../checkout/ui/checkout_screen.dart';

// ignore: must_be_immutable
class CartScreen extends StatefulWidget {
  ParkOrder order;
  CartScreen({required this.order, Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
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
                  title: "",
                ),
                CustomerTile(
                  isCheckBoxEnabled: false,
                  isDeleteButtonEnabled: false,
                  customer: widget.order.customer,
                  isSubtitle: true,
                  isHighlighted: true,
                ),

                Padding(
                  padding: paddingXY(x: 16, y: 16),
                  child: Text(
                    "Cart",
                    style: getTextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: MEDIUM_PLUS_FONT_SIZE,
                        color: DARK_GREY_COLOR),
                  ),
                ),
                productList(widget.order.items)
                // selectedCustomerSection,
                // searchBarSection,
                // productCategoryList()
              ],
            )),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: morePaddingAll(),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: MAIN_COLOR,
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                CheckoutScreen(order: widget.order)));
                  },
                  title: Text(
                    "${widget.order.items.length} Item",
                    style: getTextStyle(
                        fontSize: SMALL_FONT_SIZE,
                        color: WHITE_COLOR,
                        fontWeight: FontWeight.normal),
                  ),
                  subtitle: Text("USD ${_getItemTotal(widget.order.items)}",
                      style: getTextStyle(
                          fontSize: LARGE_FONT_SIZE,
                          fontWeight: FontWeight.w600,
                          color: WHITE_COLOR)),
                  trailing: Text("Checkout",
                      style: getTextStyle(
                          fontSize: LARGE_FONT_SIZE,
                          fontWeight: FontWeight.w400,
                          color: WHITE_COLOR)),
                ),
              ),
            )
          ],
        ),
      ),
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
                  onDelete: () {},
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
              // return ListTile(title: Text(prodList[position].name));
            }
          }),
    );
  }

  double _getItemTotal(items) {
    double total = 0;
    for (OrderItem item in items) {
      total = total + (item.orderedPrice * item.orderedQuantity);
    }
    return total;
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
