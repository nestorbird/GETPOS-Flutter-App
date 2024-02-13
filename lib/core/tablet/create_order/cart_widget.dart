import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/core/mobile/create_order_new/ui/widget/calculate_taxes.dart';
import 'package:nb_posx/core/service/product/model/products_response.dart';
import 'package:nb_posx/core/tablet/create_order/sale_successful_popup_widget.dart';
import 'package:nb_posx/database/db_utils/db_hub_manager.dart';
import 'package:nb_posx/database/db_utils/db_order_tax_template.dart';
import 'package:nb_posx/database/db_utils/db_sales_order_req_items.dart';
import 'package:nb_posx/database/db_utils/db_taxes.dart';
import 'package:nb_posx/database/models/order_item.dart';
import 'package:nb_posx/database/models/order_tax_template.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';
import 'package:nb_posx/database/models/taxes.dart';
import 'package:nb_posx/utils/helper.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/customer_tile.dart';
import '../../../database/db_utils/db_order_tax.dart';
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
  final ValueNotifier<List<OrderItem>> itemsNotifier;
  ParkOrder? order;
  Customer? customer;
  List<OrderItem> orderList;
  List<OrderTax> taxes;
  Function onNewOrder, onHome, onPrintReceipt;
  CartWidget(
      {Key? key,
      this.order,
      this.customer,
      required this.itemsNotifier,
      required this.orderList,
      required this.onNewOrder,
      required this.onHome,
      required this.onPrintReceipt,
      required this.taxes})
      : super(key: key);

  @override
  State<CartWidget> createState() => _CartWidgetState();
}

class _CartWidgetState extends State<CartWidget> {
  final bool _isCODSelected = false;
  Customer? selectedCustomer;
  ParkOrder? currentCart;
  String? orderId;
  late bool selectedCardMode;
  late bool isOrderProcessed;
  double totalAmount = 0.0;
  double subTotalAmount = 0.0;
  double taxAmount = 0.0;
  double totalTaxAmount = 0.0;
  double grandTotal = 0.0;
  double quantity = 0.0;
  int totalItems = 0;
  double taxPercentage = 0;
  String? taxTypeApplied;
  double? orderAmount;
  int qty = 0;
  SaleOrder? saleOrder;
  List<Map<String, dynamic>> taxDetailsList = [];
  List<OrderTaxTemplate> data = [];
        List<OrderTax> taxesData = [];
  @override
  void initState() {
    isOrderProcessed = false;
    selectedCardMode = false;
    selectedCustomer = widget.customer;
    //totalItems = widget.order!.items.length;
    super.initState();
    widget.itemsNotifier.addListener(_callCalculations);
  }

  @override
  void didUpdateWidget(covariant CartWidget oldWidget) {
    // TODO: implement didUpdateWidget
    _callCalculations();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _prepareCart();
    widget.itemsNotifier.removeListener(_callCalculations);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var customHeight = Get.height;
    return Container(
      margin: customHeight == Get.height
          ? const EdgeInsets.only(bottom: 0.0)
          : const EdgeInsets.only(bottom: 35.0),
      padding: paddingXY(x: 10, y: 10),
      color: AppColors.fontWhiteColor,
      width: 400,
      height: customHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _selectedCustomerSection(),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  "${_orderedQty()} Items",
                  style: getTextStyle(
                    //AppColors.getPrimary() ??
                    color: const Color(0xFF62B146),
                    fontSize: MEDIUM_PLUS_FONT_SIZE,
                  ),
                )
              ],
            ),
          ),
          const Divider(color: Colors.black38),
          _cartItemListSection(),
          //  hightSpacer10,
          //  widget.orderList.isEmpty ? const SizedBox() : _promoCodeSection(),
          _grandTotalSection(),
          widget.orderList.isEmpty ? const SizedBox() : _paymentModeSection(),
          hightSpacer10,
          _showActionButton()
        ],
      ),
    );
    // bottomNavigationBar: _grandTotalSection(),
  }

  Widget _grandTotalSection() {
    return Container(
      padding: paddingXY(x: 2, y: 0),
      height: 35,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.orderList.isEmpty
                ? const SizedBox()
                : _totalSection("Grand Total",
                    "$appCurrency ${grandTotal.toStringAsFixed(2)}"),
          ]),
    );
  }

  Widget _totalTaxSection(
    title,
    amount,
  ) =>
      Padding(
        padding: const EdgeInsets.only(top: 6, left: 0, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: getTextStyle(
                  fontWeight: FontWeight.w500,
                  color: CUSTOM_TEXT_COLOR,
                  fontSize: MEDIUM_PLUS_FONT_SIZE),
            ),
            const SizedBox(width: 150),
            Text(
              amount,
              style: getTextStyle(
                  fontWeight: FontWeight.w600,
                  color: CUSTOM_TEXT_COLOR,
                  fontSize: MEDIUM_PLUS_FONT_SIZE),
            ),
          ],
        ),
      );

  int _orderedQty() {
    double totalQty = 0.0;
    for (var product in widget.orderList) {
      totalQty += product.orderedQuantity;
    }

    return totalQty.toInt();
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
    log("Type :: ${result.runtimeType}");
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
      // setState(() {
      //   widget.customer = selectedCustomer;
      // });
    }
    if (result != null) {
      selectedCustomer = result;
      debugPrint("Customer selected");
      setState(() {
        widget.customer = selectedCustomer;
      });
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
    //               color: AppColors.getPrimary(), borderRadius: BorderRadius.circular(10)),
    //           child: Text(
    //             "Select Customer",
    //             textAlign: TextAlign.center,
    //             style:
    //                 getTextStyle(color: AppColors.fontWhiteColor, fontSize: LARGE_FONT_SIZE),
    //           ),
    //         ),
    //       )
    return InkWell(
      onTap: () async {
       
        if (selectedCardMode == true) {
          Helper.showPopupForTablet(context, "Coming Soon..");
        } else {
          _prepareCart();
          if (currentCart != null) {
            isOrderProcessed = await _placeOrderHandler();
            _showOrderPlacedSuccessPopup();
          }
        } 
        // else {
        //   Helper.showPopupForTablet(context, "Please add items in cart");
        // }
      },
      child: Container(
        width: double.infinity,
        padding: paddingXY(y: 10),
        margin: paddingXY(y: 10, x: 0),
        decoration: BoxDecoration(
            color: widget.orderList.isNotEmpty
                ? AppColors.getPrimary()
                : AppColors.getPrimary().withOpacity(0.2),
            borderRadius: BorderRadius.circular(10)),
        child: Text(
          "Place Order",
          textAlign: TextAlign.center,
          style: getTextStyle(
              color: AppColors.fontWhiteColor, fontSize: LARGE_MINUS_FONT_SIZE),
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
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (OrderItem item in widget.orderList) itemListWidget(item),

                  billSection(),
                  //  const Divider(color: Colors.black38),
                ],
              ),
            ),
          );
  }

  Widget billSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: paddingXY(x: 10, y: 6),
          child: Text(
            "Bill",
            style: getTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: MEDIUM_PLUS_FONT_SIZE,
              color: const Color(0xFF3F3E4A),
            ),
          ),
        ),
        //to fetch list of items added in cart
        //_prodListSection(),
        //Item total
        widget.orderList.isEmpty
            ? const SizedBox()
            : _subtotalSection(
                "Item Total", "$appCurrency ${totalAmount.toStringAsFixed(2)}"),
        // Subtotal is the amount after deducting discount from the item total
        widget.orderList.isEmpty
            ? const SizedBox()
            : _subtotalSection(
                "Subtotal", "$appCurrency ${totalAmount.toStringAsFixed(2)}"),
        // widget.orderList.isEmpty
        //     ? const SizedBox()
        //     : _subtotalSection("Discount", "- $appCurrency 0.00",
        //         isDiscount: true),

        widget.orderList.isEmpty
            ? const SizedBox()
            : Padding(
                padding: paddingXY(x: 0, y: 0),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.only(
                      left: 10, right: 10, top: 0, bottom: 0),
                  title: _totalTaxSection(
                    'Total Tax',
                    '$appCurrency ${totalTaxAmount.toStringAsFixed(2)}',
                  ),
                  childrenPadding: const EdgeInsets.only(left: 4),
                  children: taxDetailsList.isEmpty
                      ? [] // Returns an empty list if taxDetailsList is empty
                      : taxDetailsList.map((taxDetails) {
                          return ListTile(
                            title: Text(
                              ' ${taxDetails['tax_type']}',
                              style: getTextStyle(
                                  fontSize: MEDIUM_MINUS_FONT_SIZE,
                                  color: CUSTOM_TEXT_COLOR,
                                  fontWeight: FontWeight.w400),
                            ),
                            
                            //    subtitle: Text('Rate: ${taxDetails['rate']}%'),
                            trailing: Text(
                              ' ${taxDetails['tax_amount']}',
                              style: getTextStyle(
                                  fontSize: MEDIUM_MINUS_FONT_SIZE,
                                  color: CUSTOM_TEXT_COLOR,
                                  fontWeight: FontWeight.w400),
                            ),
                          );
                        
                        }).toList(),
                  onExpansionChanged: (bool expanded) {
                    setState(() {});
                  },
                ),
              ),
      ],
    );
  }

  Widget itemListWidget(OrderItem item) {
    // final Widget greySizedBox =
    //     SizedBox(width: 1.0, child: Container(color: AppColors.getPrimary()));

    return Container(
      width: double.infinity,
      // height: 100,
      margin: const EdgeInsets.only(bottom: 8, top: 15, left: 10, right: 10),
      child: Padding(
        padding: paddingXY(x: 0, y: 0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            SizedBox(
              height: 20,
              width: 120,
              child: Text(
                item.name,
                style: getTextStyle(
                  fontSize: SMALL_PLUS_FONT_SIZE,
                  color: const Color(0xFF3F3E4A),
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const SizedBox(
              width: 36,
            ),
            Container(
                width: 95,
                height: 28,
                decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.getPrimary(),
                    ),
                    borderRadius:
                        BorderRadius.circular(BORDER_CIRCULAR_RADIUS_06)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                        onTap: () {
                          setState(() {
                            if (item.orderedQuantity > 1) {
                              item.orderedQuantity = item.orderedQuantity - 1;
                              //  _updateOrderPriceAndSave();

                              _callCalculations();
                              // _configureTaxAndTotal(widget.orderList);
                            } else {
                              log("after removing: ");
                              widget.orderList.remove(item);
                              _callCalculations();
                            }
                          });
                          //   setState(() {});
                        },
                        child: const Icon(
                          Icons.remove,
                          size: 18,
                        )),
                    // greySizedBox,
                    Container(
                        color: AppColors.getPrimary().withOpacity(0.1),
                        child: Text(
                          item.orderedQuantity.toInt().toString(),
                          style: getTextStyle(
                            fontSize: MEDIUM_FONT_SIZE,
                            fontWeight: FontWeight.w600,
                            color: AppColors.getPrimary(),
                          ),
                        )),
                    //   greySizedBox,
                    InkWell(
                        onTap: () {
                          setState(() {
                            item.orderedQuantity = item.orderedQuantity + 1;
                            // _updateOrderPriceAndSave();
                            _callCalculations();
                            //  _configureTaxAndTotal(widget.orderList);
                            // setState(() {});
                          });
                        },
                        child: const Icon(
                          Icons.add,
                          size: 18,
                        )),
                  ],
                )),
            // widthSpacer40,
            const SizedBox(
              width: 36,
            ),

            Text(
              '$appCurrency ${item.price.toStringAsFixed(2)}',
              style: getTextStyle(
                fontWeight: FontWeight.w500,
                fontSize: MEDIUM_FONT_SIZE,
                color: CUSTOM_TEXT_COLOR,
              ),
            ),
          ]),
        ]),
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

  Widget _prodListSection() {
    return Padding(
      padding: paddingXY(x: 10, y: 10),
      child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: widget.orderList.isEmpty ? 10 : widget.orderList.length,
          itemBuilder: (context, position) {
            if (widget.orderList.isEmpty) {
              return Container();
            } else {
              return InkWell(
                onTap: () {
                  //]_openItemDetailDialog(context, prodList[position]);
                },
                child: Padding(
                  padding: paddingXY(x: 0, y: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            height: 20,
                            width: 120,
                            child: Text(
                              widget.orderList[position].name,
                              style: getTextStyle(
                                fontSize: SMALL_PLUS_FONT_SIZE,
                                color: const Color(0xFF3F3E4A),
                                fontWeight: FontWeight.w500,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          const Text("x"),
                          const SizedBox(width: 20),
                          Container(
                            decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 212, 228, 241),
                                border:
                                    Border.all(color: Colors.green, width: 2.0),
                                borderRadius: BorderRadius.circular(2.0)),
                            width: Checkbox.width,
                            height: 21.0,
                            child: Text(
                                "${widget.orderList[position].orderedQuantity.toInt()}",
                                style: const TextStyle(
                                  color: Colors.green,
                                ),
                                textAlign: TextAlign.center),
                          ),
                        ],
                      ),
                      Text(
                        '$appCurrency ${widget.orderList[position].price.toStringAsFixed(2)}',
                        style: getTextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: MEDIUM_FONT_SIZE,
                          color: CUSTOM_TEXT_COLOR,
                        ),
                      ),
                    ],
                  ),
                ),
              );

              // return ListTile(title: Text(prodList[position].name));
            }
          }),
    );
  }

  Widget _promoCodeSection() {
    return Container(
      // height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.getPrimary().withOpacity(0.1),
          border: Border.all(
              width: 1, color: AppColors.getPrimary().withOpacity(0.5)),
          borderRadius: BorderRadius.circular(12)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Promo Code",
            style: getTextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.getPrimary(),
                fontSize: MEDIUM_PLUS_FONT_SIZE),
          ),
          Column(
            children: [
              Text(
                "",
                style: getTextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.getPrimary(),
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
                          color: AppColors.getPrimary(),
                        )),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _subtotalSection(title, amount, {bool isDiscount = false}) => Padding(
        padding: const EdgeInsets.only(top: 3, left: 10, right: 10, bottom: 3),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getTextStyle(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3F3E4A),
                  // isDiscount
                  //     ? AppColors.getSecondary()
                  //     : AppColors.getTextandCancelIcon(),
                  fontSize: MEDIUM_PLUS_FONT_SIZE),
            ),
            Text(
              amount,
              style: getTextStyle(
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF3F3E4A),
                  // isDiscount
                  //     ? AppColors.getSecondary()
                  //     : AppColors.getTextandCancelIcon(),
                  fontSize: MEDIUM_PLUS_FONT_SIZE),
            ),
          ],
        ),
      );

  Widget _totalSection(title, amount) => Padding(
        padding: const EdgeInsets.only(top: 6, left: 6, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getTextStyle(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF3F3E4A),
                  // AppColors.getTextandCancelIcon(),
                  fontSize: LARGE_MINUS_FONT_SIZE),
            ),
            const SizedBox(
              width: 8,
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
          _paymentOption(PAYMENT_CASH_ICON, "Cash", selectedCardMode),
          const SizedBox(width: 15),
          _paymentOption(PAYMENT_CARD_ICON, "Card", !selectedCardMode),
        ],
      ),
    );
  }

  _paymentOption(String paymentIcon, String title, bool isSelected) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedCardMode = !selectedCardMode;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: isSelected ? Colors.black : AppColors.getPrimary(),
                width: 0.5),
            color: isSelected
                ? Colors.white
                : AppColors.getPrimary().withOpacity(0.1),
            borderRadius: BorderRadius.circular(8)),
        width: 165,
        padding: paddingXY(x: 16, y: 6),
        child: Row(
          children: [
            SvgPicture.asset(
              paymentIcon,
              height: 35,
            ),
            widthSpacer(10),
            Text(
              title,
              style: getTextStyle(
                fontSize: LARGE_MINUS_FONT_SIZE,
                fontWeight: FontWeight.w700,
              ),
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
              isNumVisible: false,
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
      widget.onNewOrder();
    } else if (response == "print_receipt") {
      widget.onPrintReceipt();
    } else if (response == "new_order") {
      selectedCustomer = null;
      widget.onNewOrder();
    }
  }

//code before taxation module implemented
  Future<bool> _placeOrderHandler() async {
    DateTime currentDateTime = DateTime.now();
    String date =
        DateFormat('EEEE d, LLLL y').format(currentDateTime).toString();
    log('Date : $date');
    String time = DateFormat().add_jm().format(currentDateTime).toString();
    log('Time : $time');
    String orderId = await Helper.getOrderId();
    log('Order No : $orderId');

    double grandTotal = Helper().getTotal(currentCart!.items);
//If itemwise tax is applicable
      var taxes = await DbTaxes().getItemWiseTax(orderId!);
      log("Taxes :: $taxes");
//if OrderWise taxation is applicable
//await DbOrderTax().saveOrderWiseTax(orderId!, taxesData);
      var tax = await DbOrderTax().getOrderWiseTax(orderId!);
      log("OrderWise Taxes :: $tax");
      

   // double grandTotal = Helper().getTotal(currentCart!.items);

    SaleOrder saleOrder = SaleOrder(
        id: orderId,
        orderAmount: grandTotal,
        date: date,
        time: time,
        customer: currentCart!.customer,
        manager: Helper.hubManager!,
        items: currentCart!.items,
        transactionId: '',
        paymentMethod: selectedCardMode
            ? "Card"
            : "Cash", //TODO:: Need to check when payment gateway is implemented
        paymentStatus: "Paid",
        transactionSynced: false,
        parkOrderId:
            "${currentCart!.transactionDateTime.millisecondsSinceEpoch}",
        tracsactionDateTime: currentDateTime,
        taxes: tax ?? []);

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

   Future<void> _configureTaxAndTotal(List<OrderItem> items) async {
  // Initialize variables
  bool isTaxAvailable = false;
  totalAmount = 0.0;
  subTotalAmount = 0.0;
  taxAmount = 0.0;
  totalTaxAmount = 0.0;
  orderAmount = 0.0;
  grandTotal = 0.0;
  // Map to store tax amounts for each tax type
  Map<String, double> taxAmountMap = {};

  for (OrderItem item in items) {
    // Reset taxAmountMap for each item
    taxAmountMap.clear();

    quantity = item.orderedQuantity;
    log("Quantity Ordered : $quantity");
    subTotalAmount = item.orderedQuantity * item.orderedPrice;
    log('SubTotal after adding ${item.name} :: $subTotalAmount');
    totalAmount += subTotalAmount;
    log('total after adding an item:$totalAmount');

    // Itemwise taxation is applicable
    if (item.tax!.isNotEmpty) {
      isTaxAvailable = true;

      // Calculating subtotal amount to calculate taxes for attributes in items
      if (item.attributes.isNotEmpty) {
        for (var attribute in item.attributes) {
          if (attribute.options.isNotEmpty) {
            for (var option in attribute.options) {
              if (option.selected) {
                subTotalAmount += (option.price * item.orderedQuantity);
                log('SubTotal after adding ${attribute.name} :: $subTotalAmount');
              }
            }
          }
        }
      }

      // Calculating tax amount
      List<Taxes> taxation = [];
      for (var tax in item.tax!) {
        taxAmount = subTotalAmount * tax.taxRate / 100;

        log('Tax Amount itemwise : $taxAmount');
        totalTaxAmount += taxAmount;

        taxation.add(Taxes(
          taxId: '',
          itemTaxTemplate: tax.itemTaxTemplate,
          taxType: tax.taxType,
          taxRate: tax.taxRate,
          taxAmount: taxAmount,
        ));
        // Update the taxAmountMap for the current tax type
        taxAmountMap.update(
          tax.taxType,
          (value) => value + taxAmount,
          ifAbsent: () => taxAmount,
        );
      }

      item.tax!.clear();
      item.tax!.addAll(taxation);
    //  await DbTaxes().saveItemWiseTax(orderId!, taxation);
     
     
    } else if (!isTaxAvailable){
      // Order wise tax applicable
      taxAmount = 0.0;
      totalTaxAmount = 0.0;
      data = await DbOrderTaxTemplate().getOrderTaxesTemplate();
      log('data: $data');

      await Future.forEach<OrderTaxTemplate>(data,
          (OrderTaxTemplate message) async {
        List<OrderTax> taxesData = [];

        for (var tax in message.tax) {
          taxAmount = totalAmount * tax.taxRate / 100;
          log('Tax Amount : $taxAmount');
          totalTaxAmount += taxAmount;
          taxTypeApplied = tax.taxType;

          taxesData.add(OrderTax(
            taxId: '',
            itemTaxTemplate: tax.itemTaxTemplate,
            taxType: tax.taxType,
            taxRate: tax.taxRate,
            taxAmount: taxAmount,
          ));

          // Update the taxAmountMap for the current tax type
          taxAmountMap.update(
            tax.taxType,
            (value) => value + taxAmount,
            ifAbsent: () => taxAmount,
          );

        }

        orderId = await Helper.getOrderId();
        log('Order No : $orderId');
        await DbOrderTax().saveOrderWiseTax(orderId!, taxesData);
        
      });
    }

    // Update taxDetailsList for display in ExpansionTile
    if (!mounted) return;
  //setState(() { });
   setState(() { 
     log('taxAmountMap: $taxAmountMap');
      taxDetailsList = taxAmountMap.entries
          .map((entry) => {
                'tax_type': entry.key,
                'tax_amount': entry.value,
              })
          .toList();
      //   setState(() {});
      grandTotal = totalAmount + totalTaxAmount;
   });
    
  }
}



        //commented
  //     }
  //     setState(() {});
  //     log("Total Amount:: $totalAmount");
  //   }

  //   // Order wise tax applicable
  //   if (!isTaxAvailable) {
  //     taxAmount = 0.0;
  //     totalTaxAmount = 0.0;
  //     data = await DbOrderTaxTemplate().getOrderTaxesTemplate();
  //     log('data: $data');

  //     await Future.forEach<OrderTaxTemplate>(data,
  //         (OrderTaxTemplate message) async {
  //       List<OrderTax> taxesData = [];

  //       for (var tax in message.tax) {
  //         taxAmount = totalAmount * tax.taxRate / 100;
  //         log('Tax Amount : $taxAmount');
  //         totalTaxAmount += taxAmount;
  //         taxTypeApplied = tax.taxType;

  //         log("Total Tax Amount orderwise : $totalTaxAmount");
  //         log('Total Amount Orderwise:: $totalAmount');
  //         taxesData.add(OrderTax(
  //           taxId: '',
  //           itemTaxTemplate: tax.itemTaxTemplate,
  //           taxType: tax.taxType,
  //           taxRate: tax.taxRate,
  //           taxAmount: taxAmount,
  //         ));

  //         // Update the taxAmountMap for the current tax type
  //         taxAmountMap.update(
  //           tax.taxType,
  //           (value) => value + taxAmount,
  //           ifAbsent: () => taxAmount,
  //         );
  //       }

  //       orderId = await Helper.getOrderId();
  //       log('Order No : $orderId');
  //       //await DbSaleOrder().saveOrderWiseTax(orderId, taxesData);
  //       await DbOrderTax().saveOrderWiseTax(orderId!, taxesData);
  //     });
  //     setState(() {});
  //     log("Total Amount:: $totalAmount");
  //   }

  //   //taxAmountMap contains the accumulated tax amounts for each tax type shown in expansion tile
  //   taxDetailsList = taxAmountMap.entries
  //       .map((entry) => {
  //             'tax_type': entry.key,
  //             //'rate': entry.value / subTotalAmount * 100, // Calculate rate based on accumulated tax amount
  //             'tax_amount': entry.value,
  //           })
  //       .toList();
  //   setState(() {});
  //   grandTotal = totalAmount! + totalTaxAmount;
  //   log('Grand Total:: $grandTotal');
  // }



  void _updateOrderPriceAndSave() {
    for (OrderItem item in widget.order!.items) {
      orderAmount = orderAmount! + item.orderedPrice * item.orderedQuantity;
    }
    widget.order!.orderAmount = orderAmount!;
    log('orderAmount after deleting:: $orderAmount');

    _configureTaxAndTotal(widget.order!.items);

    // lculateItemWiseTax(taxDetailsList,subTotalAmount);
  }

  Future<void> _callCalculations() async {
    await _configureTaxAndTotal(widget.orderList);
  }
}

