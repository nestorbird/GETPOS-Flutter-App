// ignore_for_file: unnecessary_string_interpolations

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/core/mobile/home/ui/product_list_home.dart';
import 'package:nb_posx/core/mobile/parked_orders/ui/orderlist_screen.dart';
import 'package:nb_posx/core/service/create_order/api/promo_code_service.dart';
import 'package:nb_posx/core/service/create_order/model/promo_codes_response.dart';
//import 'package:nb_posx/core/service/orderwise_taxation/model/orderwise_tax_response.dart';
import 'package:nb_posx/database/db_utils/db_order_tax.dart';
import 'package:nb_posx/database/db_utils/db_order_tax_template.dart';
import 'package:nb_posx/database/db_utils/db_taxes.dart';
import 'package:nb_posx/database/models/order_tax_template.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';
import 'package:nb_posx/database/models/taxes.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import 'package:nb_posx/utils/ui_utils/spacer_widget.dart';
import 'package:nb_posx/widgets/long_button_widget.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_parked_order.dart';
import '../../../../../database/models/park_order.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/custom_appbar.dart';
import '../../../../../widgets/product_shimmer_widget.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../../database/models/order_item.dart';
import '../../../../database/models/sale_order.dart';
import '../../../../utils/helper.dart';
import '../../add_products/ui/added_product_item.dart';
import '../../sale_success/ui/sale_success_screen.dart';

// ignore: must_be_immutable
class CartScreen extends StatefulWidget {
  ParkOrder order;
  bool? isUsedinVariantsPopup;

  CartScreen(
      {required this.order, this.isUsedinVariantsPopup = false, Key? key})
      : super(key: key) {
    // Initialize in the constructor
  }

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  String? orderId;
  bool _isCODSelected = false;
  bool isPromoCodeAvailableForUse = false;
  double? totalAmount;
  double subTotalAmount = 0.0;
  double totalTaxAmount = 0.0;
  int totalItems = 0;
  double? taxPercentage;
  double totalTaxPercentage = 0.0;
  double grandTotal = 0.0;
  double? orderAmount;
  double quantity = 0.0;
  double? stateGovTax = 0.0;
  double? centralGovTax = 0.0;
  double stateGovTaxAmount = 0.0;
  double? centralGovTaxAmount = 0.0;
  double? taxAmount;
  String? taxTypeApplied;
  late String paymentMethod;
  late HubManager? hubManager;
  SaleOrder? saleOrder;
  List<Map<String, dynamic>> taxDetailsList = [];
  late List<OrderTax>? getTaxesOrderwise;
  late List<OrderTaxTemplate>? getOrderTemplate;
  List<CouponCode> couponCodes = [];
  List<OrderTaxTemplate> data = [];
  List<Taxes>? taxesData;

  @override
  void initState() {
    super.initState();
    //_getAllPromoCodes();

    // paymentMethod = "Cash";
    _configureTaxAndTotal(widget.order.items);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppbar(
            title: "Cart",
            hideSidemenu: true,
          ),

          Padding(
              padding: paddingXY(x: 16, y: 16),
              child: Text(
                widget.order.customer.name,
                style: getTextStyle(
                    fontSize: MEDIUM_PLUS_FONT_SIZE,
                    color: AppColors.getPrimary(),
                    fontWeight: FontWeight.bold),
              )),

          Padding(
            padding: paddingXY(x: 16, y: 8),
            child: Text(
              "Items",
              style: getTextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: MEDIUM_PLUS_FONT_SIZE,
                  color: AppColors.getTextandCancelIcon()),
            ),
          ),

          productList(widget.order.items),
          // selectedCustomerSection,
          // searchBarSection,
          // productCategoryList()
          hightSpacer5,
          Padding(
              padding: paddingXY(x: 16, y: 4),
              child: _subtotalSection('Item Total',
                  '$appCurrency ${totalAmount!.toStringAsFixed(2)}')),

          // Padding(
          //     padding: paddingXY(x: 16, y: 4),
          //     child: _subtotalSection('Discount', '$appCurrency 0.00',
          //         isDiscount: true)),
          Padding(
            padding: paddingXY(x: 16, y: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Discount',
                  style: getTextStyle(
                      fontSize: MEDIUM_PLUS_FONT_SIZE,
                      color: CUSTOM_TEXT_COLOR,
                      fontWeight: FontWeight.normal),
                ),
                Text(
                  '$appCurrency 0.00',
                  style: getTextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: MEDIUM_PLUS_FONT_SIZE,
                      color: const Color(0xFFDC1E44)),
                ),
              ],
            ),
          ),
          Padding(
              padding: paddingXY(x: 16, y: 0),
              child: _subtotalSection('Sub Total',
                  '$appCurrency ${totalAmount!.toStringAsFixed(2)}')),
          hightSpacer10,
          Padding(
            padding: paddingXY(x: 0, y: 0),
            child: ExpansionTile(
              title: _totalTaxSection(
                'Total Tax Applied',
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

          // Padding(
          //     padding: paddingXY(x: 16, y: 16),
          //     child: _subtotalSection('Grand Total',
          //         '$appCurrency ${(totalAmount! + totalTaxAmount).toStringAsFixed(2)}')),
          // hightSpacer10,
          Padding(
            padding: paddingXY(x: 16, y: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Grand Total',
                  style: getTextStyle(
                      fontSize: LARGE_MINUS_FONT_SIZE,
                      color: CUSTOM_TEXT_COLOR,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  '$appCurrency ${(grandTotal).toStringAsFixed(2)}',
                  style: getTextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: LARGE_MINUS_FONT_SIZE,
                      color: CUSTOM_TEXT_COLOR),
                ),
              ],
            ),
          ),
          Padding(
              padding: paddingXY(x: 16, y: 16),
              child: Text(
                'Payment Method',
                style: getTextStyle(
                    fontSize: MEDIUM_PLUS_FONT_SIZE,
                    color: AppColors.getTextandCancelIcon(),
                    fontWeight: FontWeight.bold),
              )),
          Padding(
            padding: paddingXY(x: 16),
            child: Row(
              children: [
                getPaymentOption(
                    PAYMENT_CARD_ICON, CARD_PAYMENT_TXT, !_isCODSelected),
                widthSpacer(15),
                getPaymentOption(
                    PAYMENT_CASH_ICON, CASH_PAYMENT_TXT, _isCODSelected),
              ],
            ),
          ),
          hightSpacer20,
          // Padding(
          //     padding: paddingXY(x: 16, y: 0), child: _promoCodeSection()),
          // hightSpacer15,
        ],
      )),
      bottomNavigationBar: bottomBarWidget(),
    ));
  }

  Widget bottomBarWidget() => Container(
        margin: const EdgeInsets.all(15),
        height: 100,
        child: Row(children: [
          GestureDetector(
              onTap: (() {
                _parkOrder();
              }),
              child: Container(
                height: 70,
                width: 80,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    color: AppColors.parkOrderButton,
                    borderRadius: const BorderRadius.all(Radius.circular(7))),
                child: Text(
                  'Park Order',
                  style: getTextStyle(
                      color: AppColors.fontWhiteColor,
                      fontSize: MEDIUM_FONT_SIZE,
                      fontWeight: FontWeight.w500),
                  textAlign: TextAlign.center,
                ),
              )),
          Expanded(
              child: GestureDetector(
                  onTap: () => createSale(!_isCODSelected ? "Card" : "Cash"),
                  child: Container(
                      height: 70,
                      margin: const EdgeInsets.only(left: 10),
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: AppColors.getPrimary(),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(7))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.order.items.length > 1
                                    ? "${widget.order.items.length} Items"
                                    : "${widget.order.items.length} Item",
                                style: getTextStyle(
                                    fontSize: MEDIUM_MINUS_FONT_SIZE,
                                    color: AppColors.fontWhiteColor,
                                    fontWeight: FontWeight.normal),
                              ),
                              Text(
                                  "$appCurrency ${(totalAmount! + totalTaxAmount).toStringAsFixed(2)}",
                                  style: getTextStyle(
                                      fontSize: LARGE_FONT_SIZE,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.fontWhiteColor)),
                            ],
                          ),
                          Text("Checkout",
                              style: getTextStyle(
                                  fontSize: LARGE_FONT_SIZE,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.fontWhiteColor)),
                        ],
                      ))))
        ]),
      );

  _parkOrder() async {
    await DbParkedOrder().saveOrder(widget.order);
    // ignore: use_build_context_synchronously
    await showGeneralDialog(
        context: context,
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: child,
            ),
          );
        },
        pageBuilder: ((context, animation, secondaryAnimation) {
          return Dialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: SizedBox(
                height: 350,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                            onPressed: (() {
                              Navigator.pop(context);
                            }),
                            icon: SvgPicture.asset(
                              CROSS_ICON,
                              color: AppColors.getTextandCancelIcon(),
                              height: 15,
                              width: 15,
                            ))),
                    hightSpacer10,
                    Text(
                      "Order Parked",
                      style: getTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: LARGE_FONT_SIZE,
                          color: AppColors.getTextandCancelIcon()),
                    ),
                    hightSpacer30,
                    LongButton(
                        isAmountAndItemsVisible: false,
                        buttonTitle: 'Create A New Order',
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ProductListHome()),
                              (route) => route.isFirst);
                        }),
                    LongButton(
                        isAmountAndItemsVisible: false,
                        buttonTitle: ' Home Page',
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ProductListHome()),
                              (route) => route.isFirst);
                        }),
                    LongButton(
                        isAmountAndItemsVisible: false,
                        buttonTitle: 'View Parked Orders',
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OrderListScreen()),
                            // (route) => route.isFirst
                          );
                        }),
                    hightSpacer20
                  ],
                ),
              ));
        }));
  }

  getPaymentOption(String icon, String title, bool selected) {
    return SizedBox(
      child: InkWell(
        onTap: () {
          setState(() {
            if (!selected) {
              _isCODSelected = !_isCODSelected;
            }
          });
        },
        child: Container(
          height: 120,
          width: 100,
          decoration: BoxDecoration(
              color: selected ? AppColors.active : AppColors.fontWhiteColor,
              border: Border.all(
                  color:
                      selected ? AppColors.getPrimary() : AppColors.getAsset(),
                  width: 0.4),
              borderRadius: BorderRadius.circular(BORDER_CIRCULAR_RADIUS_10)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                height: 40,
              ),
              hightSpacer20,
              Text(title,
                  style: getTextStyle(
                    fontSize: MEDIUM_MINUS_FONT_SIZE,
                    color: AppColors.getAsset(),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget productList(List<OrderItem> prodList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: paddingXY(x: 16, y: 0),
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
                      onDelete: () {
                        prodList.remove(prodList[position]);
                        //_updateOrderPriceAndSave();
                        if (prodList.isEmpty) {
                          //DbParkedOrder().deleteOrder(widget.order);
                          Navigator.pop(context, "reload");
                        } else {
                          _updateOrderPriceAndSave();
                        }
                      },
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
                                //DbParkedOrder().deleteOrder(widget.order);
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
        ),
        hightSpacer10,
        Padding(
          padding: paddingXY(x: 16, y: 16),
          child: Text(
            "Bill",
            style: getTextStyle(
                fontWeight: FontWeight.bold,
                fontSize: MEDIUM_PLUS_FONT_SIZE,
                color: AppColors.getTextandCancelIcon()),
          ),
        ),
        hightSpacer15,
        Padding(
          padding: paddingXY(x: 16, y: 0),
          child: ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: prodList.isEmpty ? 10 : prodList.length,
              itemBuilder: (context, position) {
                if (prodList.isEmpty) {
                  return const ProductShimmer();
                } else {
                  return InkWell(
                    onTap: () {
                      // _openItemDetailDialog(context, prodList[position]);
                    },
                    child: Padding(
                      padding: paddingXY(x: 0, y: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            // crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 20,
                                width: 150,
                                child: Text(
                                  "${prodList[position].name}",
                                  style: getTextStyle(
                                    fontSize: MEDIUM_FONT_SIZE,
                                    color: CUSTOM_TEXT_COLOR,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              const Text("x"),
                              const SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 212, 228, 241),
                                    border: Border.all(
                                        color: Colors.green, width: 2.0),
                                    borderRadius: BorderRadius.circular(2.0)),
                                width: Checkbox.width,
                                height: 21.0,
                                child: Text(
                                    "${prodList[position].orderedQuantity.toInt()}",
                                    style: const TextStyle(
                                      color: Colors.green,
                                    ),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          ),
                          Text(
                            '$appCurrency ${prodList[position].price.toStringAsFixed(2)}',
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
        ),
      ],
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
        padding: const EdgeInsets.only(top: 6, left: 0, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getTextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDiscount
                      ? AppColors.getSecondary()
                      : AppColors.getTextandCancelIcon(),
                  fontSize: MEDIUM_PLUS_FONT_SIZE),
            ),
            Text(
              amount,
              style: getTextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDiscount
                      ? AppColors.getSecondary()
                      : AppColors.getTextandCancelIcon(),
                  fontSize: MEDIUM_PLUS_FONT_SIZE),
            ),
          ],
        ),
      );

  Widget _totalTaxSection(
    title,
    amount,
  ) =>
      Padding(
        padding: const EdgeInsets.only(top: 6, left: 0, right: 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: getTextStyle(
                  fontWeight: FontWeight.w500,
                  color: CUSTOM_TEXT_COLOR,
                  fontSize: MEDIUM_PLUS_FONT_SIZE),
            ),
            // Container(
            //   decoration: BoxDecoration(
            //       color: const Color.fromARGB(255, 212, 228, 241),
            //       border: Border.all(color: Colors.green, width: 2.0),
            //       borderRadius: BorderRadius.circular(2.0)),
            //   width: Checkbox.width,
            //   height: 21.0,
            //   child: Icon(
            //     // Icons.arrow_drop_down,
            //     _customTileExpanded
            //         ? Icons.arrow_drop_down_circle
            //         : Icons.arrow_drop_down,
            //   ),
            // ),
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

  createSale(String paymentMethod) async {
   // paymentMethod = paymentMethod;
    if (paymentMethod == "Card") {
      return Helper.showPopup(context, "Coming Soon");
    } else {
      DateTime currentDateTime = DateTime.now();
      String date =
          DateFormat('EEEE d, LLLL y').format(currentDateTime).toString();
      log('Date : $date');
      String time = DateFormat().add_jm().format(currentDateTime).toString();
      log('Time : $time');
      orderId = await Helper.getOrderId();
      log('Order No : $orderId');

      // DbOrderTax dbOrderTax = DbOrderTax();

      // var OrderWisetax = await dbOrderTax.getOrderTaxes();
      // OrderTax orderTax = OrderTax(
      //   itemTaxTemplate: OrderWise
      //   taxRate: Order

      // )

//await DbOrderTax().getOrderTaxes();
//List<OrderTax> savedTaxes = await DbSaleOrder().getOrderWiseTaxes(orderId,taxesData) as List<OrderTax>;

      DbHubManager dbHubManager = DbHubManager();

      var hubManagerData = await dbHubManager.getManager();
      HubManager hubManager = HubManager(
        id: hubManagerData!.emailId,
        name: hubManagerData.name,
        phone: hubManagerData.phone,
        emailId: hubManagerData.emailId,
        profileImage: hubManagerData.profileImage,
        cashBalance: hubManagerData.cashBalance.toDouble(),
      );
      //If itemwise tax is applicable
      var taxes = await DbTaxes().getItemWiseTax(orderId!);
      log("Taxes :: $taxes");
//if OrderWise taxation is applicable
      var tax = await DbOrderTax().getOrderWiseTax(orderId!);
      log("OrderWise Taxes :: $tax");

      saleOrder = SaleOrder(
          id: orderId!,
          orderAmount: grandTotal,
          date: date,
          time: time,
          customer: widget.order.customer,
          manager: hubManager,
          items: widget.order.items,
          transactionId: '',
          paymentMethod: paymentMethod,
          paymentStatus: "Paid",
          transactionSynced: false,
          parkOrderId:
              "${widget.order.transactionDateTime.millisecondsSinceEpoch}",
          tracsactionDateTime: currentDateTime,
          taxes: tax ?? []);
      if (!mounted) return;

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  SaleSuccessScreen(placedOrder: saleOrder!)));
    }
  }

//   //Taxation calculation for Itemwise and Orderwise

//   _configureTaxAndTotal(List<OrderItem> items) async {
//     bool isTaxAvailable = false;

//     for (OrderItem item in items) {
//       quantity = item.orderedQuantity;
//       log("Quantity Ordered : $quantity");
//       subTotalAmount = item.orderedQuantity * item.orderedPrice;
//       log('SubTotal after adding ${item.name} :: $subTotalAmount');
//       totalAmount += subTotalAmount;
//       log('total after adding an item:$totalAmount');
// //stateGovTaxAmount += taxAmount;

//       //Itemwise taxation is applicable
//       if (item.tax.isNotEmpty) {
//         isTaxAvailable = true;
// //calculating subtotal amount to calculate taxes for attributes in items
//         if (item.attributes.isNotEmpty) {
//           for (var attribute in item.attributes) {
//             if (attribute.options.isNotEmpty) {
//               for (var option in attribute.options) {
//                 if (option.selected) {
//                   subTotalAmount =
//                       subTotalAmount + (option.price * item.orderedQuantity);
//                   log('SubTotal after adding ${attribute.name} :: $subTotalAmount');
//                 }
//               }
//             }
//           }
//         }
// //calculating tax amount
//         List<Taxation> taxation = [];
//         item.tax.forEach((tax) async {
//           taxAmount = subTotalAmount * tax.taxRate / 100;
//           for (Taxation taxes in taxation) {
//             taxTypeApplied = taxes.taxType;
//             taxTypeAmountStored += taxAmount;
//           }

//           log('Tax Amount itemwise : $taxAmount');
//           totalTaxAmount += taxAmount;

//           log('totalAmount itemwise : $totalAmount');
//           taxation.add(Taxation(
//               id: orderId,
//               itemTaxTemplate: tax.itemTaxTemplate,
//               taxType: tax.taxType,
//               taxRate: tax.taxRate,
//               taxationAmount: taxAmount));
//         });
//         log("Total Tax Amount itemwise: $totalTaxAmount");
//         DbTaxes().saveItemWiseTax(orderId, taxation);
//         DbSaleOrderRequestItems().saveItemWiseTaxRequest(orderId, taxation);
//       }

//       log("Total Amount:: $totalAmount");
//       setState(() {});

//     }

//     // Order wise tax applicable
//     if (!isTaxAvailable) {
//       List<OrderTaxTemplate> data =
//           await DbOrderTaxTemplate().getOrderTaxesTemplate();
//       log('data: $data');
//       for (OrderTaxTemplate message in data) {
//         List<OrderTaxes> taxesData = [];
//         // message.isDefault==1.forEach(())
//         message.tax.forEach((tax) async {
//           taxAmount = totalAmount * tax.taxRate / 100;
//           log('Tax Amount : $taxAmount');
//           totalTaxAmount += taxAmount;
//           taxTypeApplied = tax.taxType;

//           log("Total Tax Amount orderwise : $totalTaxAmount");
//           log('Total Amount Orderwise:: $totalAmount');
//           taxesData.add(OrderTaxes(
//               id: orderId,
//               itemTaxTemplate: tax.itemTaxTemplate,
//               taxType: tax.taxType,
//               taxRate: tax.taxRate,
//               taxationAmount: taxAmount));
//         });
//         //  log("Total Tax Amount orderwise : $totalTaxAmount");
//         //  DbOrderTax().saveOrderWiseTax(orderId, taxesData);
//         DbSaleOrder().saveOrderWiseTax(orderId, taxesData);
//       }
//     }
//     log("Total Amount:: $totalAmount");
//     setState(() {});
//   }

  Future<void> _configureTaxAndTotal(List<OrderItem> items) async {
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
      quantity = item.orderedQuantity;
      log("Quantity Ordered : $quantity");
      subTotalAmount = item.orderedQuantity * item.orderedPrice;
      log('SubTotal after adding ${item.name} :: $subTotalAmount');
      totalAmount = totalAmount! + subTotalAmount;
      log('total after adding an item:$totalAmount');

      // Itemwise taxation is applicable
      if (item.tax.isNotEmpty) {
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
        for (var tax in item.tax) {
          taxAmount = subTotalAmount * tax.taxRate / 100;

          log('Tax Amount itemwise : $taxAmount');
          totalTaxAmount += taxAmount!;

          log('totalAmount itemwise : $totalAmount');
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
            (value) => value + taxAmount!,
            ifAbsent: () => taxAmount!,
          );
          //       Hive.box('TAX_BOX').putAt(4,taxAmount);
        }

        log("Total Tax Amount itemwise: $totalTaxAmount");
        orderId = await Helper.getOrderId();
        log('Order No : $orderId');

        await DbTaxes().saveItemWiseTax(orderId, taxation);

        //await     DbSaleOrderRequestItems().saveItemWiseTaxRequest(orderId, taxation);
      }
      setState(() {});
      log("Total Amount:: $totalAmount");
    }

    // Order wise tax applicable
    if (!isTaxAvailable) {
      taxAmount = 0.0;
      totalTaxAmount = 0.0;
      data = await DbOrderTaxTemplate().getOrderTaxesTemplate();
      log('data: $data');

      await Future.forEach<OrderTaxTemplate>(data,
          (OrderTaxTemplate message) async {
        List<OrderTax> taxesData = [];

        for (var tax in message.tax) {
          taxAmount = totalAmount! * tax.taxRate / 100;
          log('Tax Amount : $taxAmount');
          totalTaxAmount += taxAmount!;
          taxTypeApplied = tax.taxType;

          log("Total Tax Amount orderwise : $totalTaxAmount");
          log('Total Amount Orderwise:: $totalAmount');
          taxesData.add(OrderTax(
            taxId: '',
            itemTaxTemplate: tax.itemTaxTemplate,
            taxType: tax.taxType,
            taxRate: tax.taxRate,
            taxAmount: taxAmount!,
          ));

          // Update the taxAmountMap for the current tax type
          taxAmountMap.update(
            tax.taxType,
            (value) => value + taxAmount!,
            ifAbsent: () => taxAmount!,
          );
        }

        orderId = await Helper.getOrderId();
        log('Order No : $orderId');
        //await DbSaleOrder().saveOrderWiseTax(orderId, taxesData);
        await DbOrderTax().saveOrderWiseTax(orderId!, taxesData);
      });
      setState(() {});
      log("Total Amount:: $totalAmount");
    }

    //taxAmountMap contains the accumulated tax amounts for each tax type
    taxDetailsList = taxAmountMap.entries
        .map((entry) => {
              'tax_type': entry.key,
              //'rate': entry.value / subTotalAmount * 100, // Calculate rate based on accumulated tax amount
              'tax_amount': entry.value,
            })
        .toList();
    setState(() {});
    grandTotal = totalAmount! + totalTaxAmount;
    log('Grand Total:: $grandTotal');
  }

  void _updateOrderPriceAndSave() {
    for (OrderItem item in widget.order.items) {
      orderAmount = orderAmount! + item.orderedPrice * item.orderedQuantity;
    }
    widget.order.orderAmount = orderAmount!;
    log('orderAmount after deleting:: $orderAmount');

    _configureTaxAndTotal(widget.order.items);
    // calculateItemWiseTax(taxDetailsList,subTotalAmount);
  }

  void _getAllPromoCodes() async {
    CommanResponse commanResponse = await PromoCodeservice().getPromoCodes();

    if (commanResponse.apiStatus == ApiStatus.NO_INTERNET) {
      isPromoCodeAvailableForUse = false;
    } else if (commanResponse.apiStatus == ApiStatus.REQUEST_SUCCESS) {
      PromoCodesResponse promoCodesResponse = commanResponse.message;
      couponCodes = promoCodesResponse.message!.couponCode!;
    } else {
      isPromoCodeAvailableForUse = false;
    }
  }
}
