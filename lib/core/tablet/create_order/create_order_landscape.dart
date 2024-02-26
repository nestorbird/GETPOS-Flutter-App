import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:get/get.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/core/tablet/home_tablet.dart';
import 'package:nb_posx/core/tablet/open_shift/open_shift_management_landscape.dart';
import 'package:nb_posx/database/models/park_order.dart';
import 'package:nb_posx/database/models/shift_management.dart';
import 'package:nb_posx/utils/helper.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/db_utils/db_categories.dart';
import '../../../../../database/models/category.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../database/models/product.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../database/models/order_item.dart';
import '../../../network/api_helper/comman_response.dart';
import '../../../widgets/item_options.dart';
import '../../service/login/api/verify_instance_service.dart';
import '../widget/create_customer_popup.dart';
import '../widget/select_customer_popup.dart';
import '../widget/title_search_bar.dart';
import 'cart_widget.dart';

// ignore: must_be_immutable
class CreateOrderLandscape extends StatefulWidget {
  ParkOrder? order;
bool isShiftCreated;
  final RxString? selectedView;
  CreateOrderLandscape(
      {Key? key, this.order, this.selectedView, required this.isShiftCreated})
      : super(key: key);

  @override
  State<CreateOrderLandscape> createState() => _CreateOrderLandscapeState();
}

class _CreateOrderLandscapeState extends State<CreateOrderLandscape> {
   final _key = GlobalKey<ExpandableFabState>();
  bool isInternetAvailable = true;
  final ValueNotifier<List<OrderItem>> itemsNotifier =
      ValueNotifier<List<OrderItem>>([]);
  ParkOrder? parkOrder;
  late TextEditingController searchCtrl;
  late Size size;
  Customer? customer;
  ShiftManagement? shiftManagement;
  List<Product> products = [];
  List<Category> categories = [];
  // ParkOrder? parkOrder;
  late List<OrderItem> items;
  late ScrollController _scrollController;
 

  @override
  void initState() {
    _scrollController = ScrollController();
    checkInternetAvailability();
    items = [];
    searchCtrl = TextEditingController();
    super.initState();
   // verify();
    getProducts();
    if (Helper.activeParkedOrder != null) {
      log("park order is active");
      customer = Helper.activeParkedOrder!.customer;
      items = Helper.activeParkedOrder!.items;
    }
  }

  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    itemsNotifier.dispose();
    searchCtrl.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_focusNode.hasFocus) {
      _focusNode.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Row(
      children: [
        SizedBox(
          width: size.width - 505,
          height: size.height,
          child: Column(
            children: [
              TitleAndSearchBar(
                title: "Choose Category",
                searchCtrl: searchCtrl,
                searchHint: "Search product / category",
                searchBoxWidth: size.width / 4,
                onTap: () {
                  final state = _key.currentState;
                  if (state != null) {
                    debugPrint('isOpen:${state.isOpen}');
                    if (state.isOpen) {
                      state.toggle();
                    }
                  }
                },
                onSubmit: (text) {
                  if (searchCtrl.text.length >= 3) {
                    _filterProductsCategories(searchCtrl.text);
                  } else {
                    getProducts();
                  }
                },
                //  (text) {
                //   if (text.length >= 3) {
                //     categories.isEmpty
                //         ? const Center(
                //             child: Text(
                //             "No items found",
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ))
                //         : _filterProductsCategories(text);
                //   } else {
                //     getProducts();
                //   }
                // },
                onTextChanged: ((changedtext) {
                  final state = _key.currentState;
                  if (state != null) {
                    debugPrint('isOpen:${state.isOpen}');
                    if (state.isOpen) {
                      state.toggle();
                    }
                  }
                  if (changedtext.length < 3) {
                    getProducts();
                    // _filterProductsCategories(changedtext);
                  }
                }),
                //  (changedtext) {
                //   if (changedtext.length >= 3) {
                //     categories.isEmpty
                //         ? const Center(
                //             child: Text(
                //             "No items found",
                //             style: TextStyle(fontWeight: FontWeight.bold),
                //           ))
                //         : _filterProductsCategories(changedtext);
                //   } else {
                //     getProducts();
                //   }
                // },
              ),
              hightSpacer20,
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      categories.isEmpty
                          ? const Center(
                              child: Text(
                              "No items found",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ))
                          : getCategoryListWidg(),
                      hightSpacer20,
                      ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: categories.length,
                        itemBuilder: (context, position) {
                          return Column(
                            children: [
                              categories.isEmpty
                                  ? const Center(
                                      child: Text(
                                      "No items found",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ))
                                  : getCategoryItemsWidget(
                                      categories[position]),
                              hightSpacer10
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: leftSpace(x: 5),
          child: CartWidget(
            // order: parkOrder!,
            itemsNotifier: itemsNotifier,
            customer: customer,
            orderList: items,
            taxes: const [],
            onHome: () {
              widget.selectedView!.value = "Home";
              items.clear();
              customer = null;
              setState(() {});
            },
            onPrintReceipt: () {
              widget.selectedView!.value = "Home";
              items.clear();
              customer = null;
              setState(() {});
            },
            onNewOrder: () {
              customer = null;
              items = [];
              setState(() {});
            },
          ), //_cartWidget()
        ),
      ],
    );
  }

  getCategoryItemsWidget(Category cat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            cat.name,
            style: getTextStyle(
              fontSize: LARGE_FONT_SIZE,
            ),
          ),
        ),
        hightSpacer10,
        SizedBox(
          height: 140,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: cat.items.length,
              itemBuilder: (context, position) {
                // return Container(
                //     margin: const EdgeInsets.only(left: 8, right: 8),
                //     child: InkWell(
                //       onTap: () {
                //         if (customer == null) {
                //           _handleCustomerPopup();
                //         } else {
                //           var item =
                //               OrderItem.fromJson(cat.items[position].toJson());
                //           _openItemDetailDialog(context, item);
                //           debugPrint("Item clicked $position");
                //         }
                //       },
                //       child: Stack(
                //         alignment: Alignment.topCenter,
                //         children: [
                //           Align(
                //             alignment: Alignment.bottomCenter,
                //             child: Container(
                //               margin: paddingXY(x: 5, y: 5),
                //               padding: paddingXY(y: 0, x: 10),
                //               width: 145,
                //               height: 105,
                //               decoration: BoxDecoration(
                //                   color: AppColors.fontWhiteColor,
                //                   borderRadius: BorderRadius.circular(10)),
                //               child: Column(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.stretch,
                //                 children: [
                //                   hightSpacer25,
                //                   SizedBox(
                //                     child: Text(
                //                       cat.items[position].name,
                //                       maxLines: 2,
                //                       overflow: TextOverflow.ellipsis,
                //                       style: getTextStyle(
                //                           color: DARK_GREY_COLOR,
                //                           fontWeight: FontWeight.w500,
                //                           fontSize: SMALL_PLUS_FONT_SIZE),
                //                     ),
                //                   ),
                //                   hightSpacer5,
                //                   Text(
                //                     "$appCurrency ${cat.items[position].price.toStringAsFixed(2)}",
                //                     textAlign: TextAlign.right,
                //                     style: getTextStyle(
                //                         color: MAIN_COLOR,
                //                         fontSize: MEDIUM_FONT_SIZE),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ),
                //           Container(
                //             height: 60,
                //             width: 60,
                //             decoration:
                //                 const BoxDecoration(shape: BoxShape.circle),
                //             clipBehavior: Clip.antiAliasWithSaveLayer,
                //             child: cat.items[position].productImage.isNotEmpty
                //                 ? Image.memory(cat.items[position].productImage,
                //                     fit: BoxFit.fill)
                //                 : SvgPicture.asset(
                //                     PRODUCT_IMAGE,
                //                   ),
                //           ),
                //         ],
                //       ),
                //     ));
                return Padding(
                    padding: const EdgeInsets.only(right: 9.0),
                    child: GestureDetector(
                        onTap: () {
                          _handleTap();

                          if (customer == null) {
                            // Navigator.push(
                            //  context,
                            //  MaterialPageRoute(builder: (context) => 
                            //   HomeTablet(isShiftCreated: true,)));
                           _handleCustomerPopup();
                            //  Navigator.push(
                            //  context,
                            //  MaterialPageRoute(builder: (context) => 
                            //   const OpenShiftManagement()));

                          } else {
                            if (cat.items[position].stock > 0) {
                              var item = OrderItem.fromJson(
                                  cat.items[position].toJson());
                              log('Selected Item :: $item');
                              _openItemDetailDialog(context, item);
                            } else {
                              Helper.showPopup(
                                  context, 'Sorry, item is not in stock.');
                            }
                          }
                        },
                        child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                cat.items[position].stock > 0
                                    ? Colors.transparent
                                    : Colors.white.withOpacity(0.6),
                                BlendMode.screen),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    margin: paddingXY(x: 5, y: 20),
                                    padding: paddingXY(y: 0, x: 10),
                                    width: 175, //to do here
                                    height: 90,
                                    decoration: BoxDecoration(
                                        color: AppColors.fontWhiteColor,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        hightSpacer40,
                                        SizedBox(
                                          height: 20,
                                          child: Text(
                                            cat.items[position].name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: getTextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: SMALL_PLUS_FONT_SIZE),
                                          ),
                                        ),
                                        hightSpacer4,
                                        Text(
                                          "$appCurrency ${cat.items[position].price.toStringAsFixed(2)}",
                                          textAlign: TextAlign.end,
                                          style: getTextStyle(
                                              color: AppColors.getSecondary(),
                                              fontSize: SMALL_PLUS_FONT_SIZE),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.fontWhiteColor!),
                                        shape: BoxShape.circle),
                                    child: Container(
                                        // color: Colors.amber,
                                        margin: const EdgeInsets.only(
                                            left: 5, right: 5),
                                        height: 55,
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: const BoxDecoration(
                                            shape: BoxShape.circle),
                                        child: (isInternetAvailable &&
                                                (cat
                                                    .items[position]
                                                    .productImageUrl!
                                                    .isNotEmpty))
                                            //          !=
                                            //     null ||
                                            // cat
                                            //     .items[position]
                                            //     .productImageUrl!
                                            //     .isNotEmpty))
                                            ? Image.network(
                                                cat.items[position]
                                                    .productImageUrl!,
                                              )
                                            : (isInternetAvailable &&
                                                    (cat
                                                        .items[position]
                                                        .productImageUrl!
                                                        .isEmpty))
                                                //          ==
                                                //     null ||
                                                // cat.items[position]
                                                //         .productImageUrl ==
                                                //     ""))
                                                ? Image.asset(
                                                    NO_IMAGE,
                                                  )
                                                : Image.asset(
                                                    NO_IMAGE,
                                                  )
                                        // cat.items[position].productImage.isEmpty
                                        //     ? Image.asset(NO_IMAGE)
                                        //     : Image.memory(cat
                                        //         .items[position].productImage),
                                        )),
                                Container(
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.only(left: 45),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF62B146)),
                                    child: Text(
                                      cat.items[position].stock
                                          .toInt()
                                          .toString(),
                                      style: getTextStyle(
                                          fontSize: SMALL_MINUS_FONT_SIZE,
                                          color: AppColors.fontWhiteColor),
                                    ))
                              ],
                            ))));
              }),
        ),
      ],
    );
  }

  _openItemDetailDialog(BuildContext context, OrderItem product) async {
    product.orderedPrice = product.price;
    if (product.orderedQuantity == 0) {
      product.orderedQuantity = 1;
    }
    var res = await showDialog(
        context: context,
        builder: (context) {
          return ItemOptions(orderItem: product);
        });
    if (res == true) {
      items.add(product);
    }
    setState(() {});
  }

  getCategoryListWidg() {
    return SizedBox(
      height: 110,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, position) {
            return GestureDetector(
              onTap: (() {
                // log("TAPPED:::::");
                final state = _key.currentState;
                if (state != null && state.isOpen) {
                  state.toggle();
                }
                _scrollToIndex(position);
              }),
              child: categories.isEmpty
                  ? const Center(
                      child: Text(
                      "No items found",
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    ))
                  : Container(
                      margin: paddingXY(y: 5),
                      width: 90,
                      decoration: BoxDecoration(
                        color: AppColors.fontWhiteColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                              margin: const EdgeInsets.only(left: 5),
                              height: 50,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: (isInternetAvailable &&
                                      (categories[position]
                                          .items[0]
                                          .productImageUrl!
                                          .isNotEmpty))
                                  //         !=
                                  //     null ||
                                  // categories[position]
                                  //     .items[0]
                                  //     .productImageUrl!
                                  //     .isNotEmpty))
                                  ? Image.network(
                                      categories[position]
                                          .items[0]
                                          .productImageUrl!,
                                      fit: BoxFit.fill,
                                      // height: 50,
                                      // width: 50,
                                    )
                                  : (isInternetAvailable &&
                                          (categories[position]
                                              .items[0]
                                              .productImageUrl!
                                              .isEmpty))
                                      ? Image.asset(
                                          NO_IMAGE,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.asset(
                                          NO_IMAGE,
                                          fit: BoxFit.fill,
                                        ))
                          // categories[position].image.isNotEmpty
                          //     ? Image.memory(
                          //         categories[position]
                          //             .items
                          //             .first
                          //             .productImage,
                          //         height: 50,
                          //         width: 50,
                          //         fit: BoxFit.fill,
                          //       )
                          //     : Image.asset(
                          //         NO_IMAGE,
                          //         fit: BoxFit.fill,
                          //       ))

                          // Image.asset(
                          //     BURGAR_IMAGE,
                          //     height: 50,
                          //     width: 50,
                          //     fit: BoxFit.fill,
                          //   ),
                          ,
                          Text(
                            categories[position].name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: getTextStyle(
                              fontSize: SMALL_PLUS_FONT_SIZE,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
            );
          }),
    );
  }

  Future<void> checkInternetAvailability() async {
    try {
      bool internetAvailable = await Helper.isNetworkAvailable();
      setState(() {
        isInternetAvailable = internetAvailable;
      });
    } catch (error) {
      // Handle the error if needed
      print('Error: $error');
    }
  }

  Future<void> getProducts() async {
    //Fetching data from DbProduct database
    categories = await DbCategory().getCategories();
    log("CATEGORIES");
    log(categories.toString());
    setState(() {});
  }

  _handleCustomerPopup() async {
    final result = await Get.defaultDialog(
      // contentPadding: paddingXY(x: 0, y: 0),
      title: "",
      titlePadding: paddingXY(x: 0, y: 0),
      // custom: Container(),
      content: SelectCustomerPopup(
        customer: customer,
      ),
    );
    if (result.runtimeType == String) {
      customer = await Get.defaultDialog(
        // contentPadding: paddingXY(x: 0, y: 0),
        title: "",
        titlePadding: paddingXY(x: 0, y: 0),
        //   custom: Container(),
        content: CreateCustomerPopup(
          phoneNo: result,
        ),
      );
    }
    if (result != null && result.runtimeType == Customer) {
      customer = result;
      debugPrint("Customer selected");
    }
    setState(() {});
//     if (result != customer && result.runtimeType == ShiftManagement ){
// shiftManagement =result;
// debugPrint("Pos Cashier selected");
//     }
//     setState(() {}); 
  }

  double _scrollToOffset(int index) {
    // Calculate the scroll offset for the given index
    // You'll need to adjust this based on your actual item heights
    double itemHeight = 200;
    return itemHeight * index;
  }

  void _scrollToIndex(int index) {
    double offset = _scrollToOffset(index);
    _scrollController.animateTo(offset,
        duration: const Duration(seconds: 1), curve: Curves.easeInOutSine);
  }

  void _filterProductsCategories(String searchTxt) {
    categories = categories
        .where((element) =>
            element.items.any((element) =>
                element.name.toLowerCase().contains(searchTxt.toLowerCase())) ||
            element.name.toLowerCase().contains(searchTxt.toLowerCase()))
        .toList();

    setState(() {});
  }

  // verify() async {
  //   CommanResponse res = await VerificationUrl.checkAppStatus();
  //   if (res.message == true) {
  //   } else {
  //     Helper.showPopup(context, "Please update your app to latest version",
  //         barrierDismissible: true);
  //   }
  // }
}
