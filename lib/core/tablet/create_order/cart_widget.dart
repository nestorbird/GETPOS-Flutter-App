import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:nb_posx/core/tablet/create_order/sale_successful_popup_widget.dart';
import 'package:nb_posx/database/models/order_item.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';

import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/customer_tile.dart';
import '../../../database/db_utils/db_parked_order.dart';
import '../../../database/db_utils/db_sale_order.dart';
import '../../../database/models/attribute.dart';
import '../../../database/models/park_order.dart';
import '../../../database/models/sale_order.dart';
import '../../service/create_order/api/create_sales_order.dart';
import '../widget/create_customer_popup.dart';
import '../widget/select_customer_popup.dart';

// ignore: must_be_immutable
class CartWidget extends StatefulWidget {
  Customer? customer;
  List<OrderItem> orderList;
  Function onNewOrder, onHome, onPrintReceipt;
  CartWidget({
    Key? key,
    this.customer,
    required this.orderList,
    required this.onNewOrder,
    required this.onHome,
    required this.onPrintReceipt,
  }) : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  Customer? selectedCustomer;
  ParkOrder? currentCart;
  late bool selectedCashMode;
  late bool isOrderProcessed;
  double totalAmount = 0.0;
  double subTotalAmount = 0.0;
  double taxAmount = 0.0;
  int totalItems = 0;
  double taxPercentage = 0;

  @override
  void initState() {
    isOrderProcessed = false;
    selectedCashMode = true;
    selectedCustomer = widget.customer;

    super.initState();
  }

  @override
  void dispose() {
    _prepareCart();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _configureTaxAndTotal(widget.orderList);

    return Container(
      padding: paddingXY(x: 10, y: 10),
      color: WHITE_COLOR,
      width: 300,
      height: Get.height,
      child: Column(
        children: [
          _selectedCustomerSection(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cart",
                  style: getTextStyle(
                    fontSize: LARGE_FONT_SIZE,
                  ),
                ),
                Text(
                  "${widget.orderList.length} Items",
                  style: getTextStyle(
                    color: MAIN_COLOR,
                    fontSize: MEDIUM_PLUS_FONT_SIZE,
                  ),
                )
              ],
            ),
          ),
          const Divider(color: Colors.black38),
          _cartItemListSection(),
          widget.orderList.isEmpty ? const SizedBox() : _promoCodeSection(),
          widget.orderList.isEmpty
              ? const SizedBox()
              : const SizedBox(height: 16),
          widget.orderList.isEmpty
              ? const SizedBox()
              : _subtotalSection("Subtotal",
                  "$appCurrency ${subTotalAmount.toStringAsFixed(2)}"),
          widget.orderList.isEmpty
              ? const SizedBox()
              : _subtotalSection("Discount", "- $appCurrency 0.00",
                  isDiscount: true),
          // widget.orderList.isEmpty
          //     ? const SizedBox()
          //     : _subtotalSection("Tax ($taxPercentage%)",
          //         "$appCurrency ${taxAmount.toStringAsFixed(2)}"),
          widget.orderList.isEmpty
              ? const SizedBox()
              : _totalSection(
                  "Total", "$appCurrency ${totalAmount.toStringAsFixed(2)}"),
          widget.orderList.isEmpty ? const SizedBox() : _paymentModeSection(),
          hightSpacer10,
          _showActionButton()
        ],
      ),
    );
  }

  _handleCustomerPopup() async {
    final result = await Get.defaultDialog(
      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 0, y: 0),
      // custom: Container(),
      content: SelectCustomerPopup(
        customer: selectedCustomer,
      ),
    );
    if (result.runtimeType == String) {
      selectedCustomer = await Get.defaultDialog(
        // contentPadding: paddingXY(x: 0, y: 0),
        title: "",
        titlePadding: paddingXY(x: 0, y: 0),
        // custom: Container(),
        content: CreateCustomerPopup(
          phoneNo: result,
        ),
      );
    }
    if (result != null) {
      selectedCustomer = result;
      debugPrint("Customer selected");
    }
  }

  _showActionButton() {
    // return selectedCustomer == null
    //     ? InkWell(
    //         onTap: () {
    //           _handleCustomerPopup();
    //         },
    //         child: Container(
    //           width: double.infinity,
    //           padding: paddingXY(y: 20),
    //           margin: paddingXY(y: 20, x: 5),
    //           decoration: BoxDecoration(
    //               color: MAIN_COLOR, borderRadius: BorderRadius.circular(10)),
    //           child: Text(
    //             "Select Customer",
    //             textAlign: TextAlign.center,
    //             style:
    //                 getTextStyle(color: WHITE_COLOR, fontSize: LARGE_FONT_SIZE),
    //           ),
    //         ),
    //       )
    return InkWell(
      onTap: () async {
        _prepareCart();
        if (currentCart != null) {
          isOrderProcessed = await _placeOrderHandler();

          // to be showed on successfull order placed
          _showOrderPlacedSuccessPopup();
        } else {
          Helper.showPopupForTablet(context, "Please add items in cart");
        }
      },
      child: Container(
        width: double.infinity,
        padding: paddingXY(y: 10),
        margin: paddingXY(y: 10, x: 5),
        decoration: BoxDecoration(
            color: widget.orderList.isNotEmpty
                ? MAIN_COLOR
                : MAIN_COLOR.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          "Place Order",
          textAlign: TextAlign.center,
          style:
              getTextStyle(color: WHITE_COLOR, fontSize: LARGE_MINUS_FONT_SIZE),
        ),
      ),
    );
  }

  Widget _cartItemListSection() {
    return widget.orderList.isEmpty
        ? Expanded(
            child: Center(
              child: Image.asset(EMPTY_CART_TAB_IMAGE),
            ),
          )
        : Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  for (OrderItem item in widget.orderList) itemListWidget(item),
                ],
              ),
            ),
          );
  }

  Widget itemListWidget(OrderItem item) {
    final Widget greySizedBox =
        SizedBox(width: 1.0, child: Container(color: MAIN_COLOR));

    return Container(
      width: double.infinity,
      height: 100,
      margin: const EdgeInsets.only(bottom: 8, top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              width: 55,
              height: 55,
              child: Image.memory(
                item.productImage,
                fit: BoxFit.fill,
              ),
            ),
          ),
          // Image.asset(BURGAR_IMAGE),
          widthSpacer(10),
          Expanded(
            child: SizedBox(
                height: 85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(children: [
                      Expanded(
                          child: Text(
                        item.name,
                        style: getTextStyle(
                            fontWeight: FontWeight.w500,
                            color: BLACK_COLOR,
                            fontSize: SMALL_PLUS_FONT_SIZE),
                      )),
                      InkWell(
                        onTap: () {
                          setState(() {
                            widget.orderList.remove(item);
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                          child: SvgPicture.asset(
                            DELETE_IMAGE,
                            width: 16,
                            height: 16,
                          ),
                        ),
                      )
                    ]),
                    hightSpacer10,
                    Expanded(
                        child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              "${_getItemVariants(item.attributes)} x ${item.orderedQuantity}",
                              style: getTextStyle(
                                  fontSize: SMALL_FONT_SIZE,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.start,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ))),
                    hightSpacer10,
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$appCurrency ${item.price.toStringAsFixed(2)}",
                            style: getTextStyle(
                                fontWeight: FontWeight.w600,
                                color: GREEN_COLOR,
                                fontSize: SMALL_PLUS_FONT_SIZE),
                          ),
                          // const Spacer(),
                          // const Icon(Icons.delete)
                          Container(
                              width: 100,
                              height: 20,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: MAIN_COLOR,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                      BORDER_CIRCULAR_RADIUS_06)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                      onTap: () {
                                        if (item.orderedQuantity > 1) {
                                          item.orderedQuantity =
                                              item.orderedQuantity - 1;
                                        } else {
                                          widget.orderList.remove(item);
                                        }
                                        setState(() {});
                                      },
                                      child: const Icon(
                                        Icons.remove,
                                        size: 18,
                                      )),
                                  greySizedBox,
                                  Container(
                                      color: MAIN_COLOR.withOpacity(0.1),
                                      child: Text(
                                        item.orderedQuantity.toInt().toString(),
                                        style: getTextStyle(
                                          fontSize: MEDIUM_FONT_SIZE,
                                          fontWeight: FontWeight.w600,
                                          color: MAIN_COLOR,
                                        ),
                                      )),
                                  greySizedBox,
                                  InkWell(
                                      onTap: () {
                                        item.orderedQuantity =
                                            item.orderedQuantity + 1;
                                        setState(() {});
                                      },
                                      child: const Icon(
                                        Icons.add,
                                        size: 18,
                                      )),
                                ],
                              ))
                        ]),
                  ],
                )),
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
          Column(
            children: [
              Text(
                "",
                style: getTextStyle(
                    fontWeight: FontWeight.w600,
                    color: MAIN_COLOR,
                    fontSize: MEDIUM_PLUS_FONT_SIZE),
              ),
              const SizedBox(height: 2),
              Row(
                children: List.generate(
                    15,
                    (index) => Container(
                          width: 2,
                          height: 1,
                          margin: const EdgeInsets.symmetric(horizontal: 1),
                          color: MAIN_COLOR,
                        )),
              )
            ],
          ),
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
                  fontSize: LARGE_MINUS_FONT_SIZE),
            ),
            Text(
              amount,
              style: getTextStyle(
                  fontWeight: FontWeight.w700, fontSize: LARGE_MINUS_FONT_SIZE),
            ),
          ],
        ),
      );

  Widget _paymentModeSection() {
    return Container(
      // color: Colors.black12,
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _paymentOption(PAYMENT_CASH_ICON, "Cash", selectedCashMode),
          _paymentOption(PAYMENT_CARD_ICON, "Card", !selectedCashMode),
        ],
      ),
    );
  }

  _paymentOption(String paymentIcon, String title, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCashMode = !selectedCashMode;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? Colors.black : MAIN_COLOR, width: 0.5),
            color: isSelected ? Colors.white : MAIN_COLOR.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)),
        padding: paddingXY(x: 16, y: 6),
        child: Row(
          children: [
            SvgPicture.asset(paymentIcon, height: 35),
            widthSpacer(10),
            Text(
              title,
              style: getTextStyle(fontSize: MEDIUM_FONT_SIZE),
            )
          ],
        ),
      ),
    );
  }

  Widget _selectedCustomerSection() {
    //log('Selected customer from parent widget :: ${widget.customer}');
    selectedCustomer = widget.customer;
    return selectedCustomer != null
        ? InkWell(
            onTap: () => _handleCustomerPopup(),
            child: CustomerTile(
              isCheckBoxEnabled: false,
              isDeleteButtonEnabled: false,
              customer: selectedCustomer,
              isHighlighted: true,
              isSubtitle: true,
            ),
          )
        : Container();
  }

  void _calculateOrderAmount() {
    double amount = 0;
    for (var item in currentCart!.items) {
      amount += item.orderedPrice * item.orderedQuantity;
    }
    currentCart!.orderAmount = amount;
  }

  void _showOrderPlacedSuccessPopup() async {
    var response = await Get.defaultDialog(
      barrierDismissible: false,
      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 0, y: 0),
      // custom: Container(),
      content: const SaleSuccessfulPopup(),
    );
    if (response == "home") {
      widget.onHome();
    } else if (response == "print_receipt") {
      widget.onPrintReceipt();
    } else if (response == "new_order") {
      selectedCustomer = null;
      widget.onNewOrder();
    }
  }

  Future<bool> _placeOrderHandler() async {
    DateTime currentDateTime = DateTime.now();
    String date =
        DateFormat('EEEE d, LLLL y').format(currentDateTime).toString();
    log('Date : $date');
    String time = DateFormat().add_jm().format(currentDateTime).toString();
    log('Time : $time');
    String orderId = await Helper.getOrderId();
    log('Order No : $orderId');

    double totalAmount = Helper().getTotal(currentCart!.items);

    SaleOrder saleOrder = SaleOrder(
        id: orderId,
        orderAmount: totalAmount,
        date: date,
        time: time,
        customer: currentCart!.customer,
        manager: Helper.hubManager!,
        items: currentCart!.items,
        transactionId: '',
        paymentMethod: selectedCashMode
            ? "Cash"
            : "Cash", //TODO:: Need to check when payment gateway is implemented
        paymentStatus: "Paid",
        transactionSynced: false,
        parkOrderId:
            "${currentCart!.transactionDateTime.millisecondsSinceEpoch}",
        tracsactionDateTime: currentDateTime);

    CreateOrderService().createOrder(saleOrder).then((value) {
      if (value.status!) {
        // print("create order response::::YYYYY");
        SaleOrder order = saleOrder;
        order.transactionSynced = true;
        order.id = value.message;

        DbSaleOrder()
            .createOrder(order)
            .then((value) => debugPrint('order sync and saved to db'));
      } else {
        DbSaleOrder()
            .createOrder(saleOrder)
            .then((value) => debugPrint('order saved to db'));
      }
    }).whenComplete(() {
      DbParkedOrder().deleteOrder(currentCart!);
    });

    return true;
  }

  void _prepareCart() {
    if (isOrderProcessed) {
      return;
    }
    if (selectedCustomer != null && widget.orderList.isNotEmpty) {
      currentCart = ParkOrder(
        id: selectedCustomer!.id,
        date: Helper.getCurrentDate(),
        time: Helper.getCurrentTime(),
        customer: selectedCustomer!,
        manager: Helper.hubManager!,
        items: widget.orderList,
        orderAmount: 0,
        transactionDateTime: DateTime.now(),
      );
      _calculateOrderAmount();
      DbParkedOrder().saveOrder(currentCart!);
      Helper.activeParkedOrder = null;
    }
  }

  //TODO:: Siddhant - Need to correct the tax calculation logic here.
  _configureTaxAndTotal(List<OrderItem> items) {
    totalAmount = 0.0;
    subTotalAmount = 0.0;
    taxAmount = 0.0;
    totalItems = 0;
    taxPercentage = 0;
    for (OrderItem item in items) {
      //taxPercentage = taxPercentage + (item.tax * item.orderedQuantity);
      log('Tax Percentage after adding ${item.name} :: $taxPercentage');
      subTotalAmount =
          subTotalAmount + (item.orderedPrice * item.orderedQuantity);
      log('SubTotal after adding ${item.name} :: $subTotalAmount');
      if (item.attributes.isNotEmpty) {
        for (var attribute in item.attributes) {
          //taxPercentage = taxPercentage + attribute.tax;
          log('Tax Percentage after adding ${attribute.name} :: $taxPercentage');
          if (attribute.options.isNotEmpty) {
            for (var options in attribute.options) {
              if (options.selected) {
                //taxPercentage = taxPercentage + options.tax;
                subTotalAmount = subTotalAmount + options.price;
                log('SubTotal after adding ${attribute.name} :: $subTotalAmount');
              }
            }
          }
        }
      }
    }
    //taxAmount = (subTotalAmount / 100) * taxPercentage;
    totalAmount = subTotalAmount + taxAmount;
    log('Subtotal :: $subTotalAmount');
    log('Tax percentage :: $taxAmount');
    log('Tax Amount :: $taxAmount');
    log('Total :: $totalAmount');
    //return taxPercentage;
    setState(() {});
  }
}
