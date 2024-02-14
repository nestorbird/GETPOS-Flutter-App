import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/constants/asset_paths.dart';
import 'package:nb_posx/core/mobile/create_order_new/ui/cart_screen.dart';
import 'package:nb_posx/core/mobile/finance/ui/finance.dart';
import 'package:nb_posx/core/mobile/my_account/ui/my_account.dart';
import 'package:nb_posx/widgets/search_widget.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../../../constants/app_constants.dart';
import '../../../../database/db_utils/db_categories.dart';
import '../../../../database/db_utils/db_hub_manager.dart';
import '../../../../database/models/category.dart';
import '../../../../database/models/customer.dart';
import '../../../../database/models/hub_manager.dart';
import '../../../../database/models/order_item.dart';
import '../../../../database/models/park_order.dart';
import '../../../../database/models/product.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/item_options.dart';
import '../../../service/product/api/products_api_service.dart';
import '../../customers/ui/customers.dart';
import '../../select_customer/ui/new_select_customer.dart';
import '../../transaction_history/view/transaction_screen.dart';

class ProductListHome extends StatefulWidget {
  final bool isForNewOrder;
  final bool isAppLoggedIn;
  // final bool isAppLoggedIn;

  final ParkOrder? parkedOrder;
  const ProductListHome({
    super.key,
    this.isForNewOrder = false,
    this.parkedOrder,
    this.isAppLoggedIn = false,
  });

  @override
  State<ProductListHome> createState() => _ProductListHomeState();
}

class _ProductListHomeState extends State<ProductListHome> {
  final _key = GlobalKey<ExpandableFabState>();
  // dynamic hubManagerData;
  final GlobalKey _focusKey = GlobalKey();
  late TextEditingController _searchTxtController;
  List<Product> products = [];
  List<Category> categories = [];
  HubManager? manager;
  late String managerName = '';
  //bool _isFABOpened = false;
  bool isInternetAvailable = false;
  ParkOrder? parkOrder;
  Customer? _selectedCust;
 // PosProfileCashier? _selectedPosProfile;   TO BE ADDED
  final _scrollController = ScrollController();
  //HubManager? hubManagerData;
  double _scrollToOffset(int index) {
    // Calculate the scroll offset for the given index
    // You'll need to adjust this based on your actual item heights
    double itemHeight = 250;
    return itemHeight * index;
  }

  void _scrollToIndex(int index) {
    double offset = _scrollToOffset(index);
    _scrollController.animateTo(offset,
        duration: const Duration(seconds: 1), curve: Curves.easeInOutSine);
  }

  // Define the fixed height for an item
  // double _height = 0.0;

  // void _scrollToIndex(index) {
  //   _scrollController.animateTo(_height * index,
  //       duration: const Duration(seconds: 1), curve: Curves.easeInOutSine);
  // }

  @override
  void initState() {
    super.initState();

    checkInternetAvailability();
    // WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    _getManagerName();
    getProducts();
    // _height = MediaQuery.of(context).size.height;
    _searchTxtController = TextEditingController();
    if (widget.parkedOrder != null) {
      parkOrder = widget.parkedOrder;
      _selectedCust = widget.parkedOrder!.customer;
    }
    if (widget.isForNewOrder && _selectedCust == null) {
      Future.delayed(Duration.zero, () => goToSelectCustomer());
    }
    //  if (widget.isNewShift && _selectedPosProfile == null && _sele) {
    //   Future.delayed(Duration.zero, () => _selectPosProfile());
    // }
   

    // _getManagerName();

    // getProducts();
    // // _height = MediaQuery.of(context).size.height;
    // _searchTxtController = TextEditingController();
    // if (widget.parkedOrder != null) {
    //   parkOrder = widget.parkedOrder;
    //   _selectedCust = widget.parkedOrder!.customer;
    // }
    // if (widget.isForNewOrder && _selectedCust == null) {
    //   Future.delayed(Duration.zero, () => goToSelectCustomer());
    // }
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: GestureDetector(
      onTap: () {
        final state = _key.currentState;
        if (state != null) {
          debugPrint('isOpen:${state.isOpen}');
          if (state.isOpen) {
            state.toggle();
          }
        }
      },
      child: Scaffold(
        body: ShowCaseWidget(
            builder: Builder(
                builder: ((context) => SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height,
                        //   width: MediaQuery.of(context).size.width,
                        //   child: ModalBarrier(
                        //   dismissible: true,
                        //   color: _isModalVisible ? Colors.black.withOpacity(0.5) : Colors.transparent,
                        // )
                        // ),
                        hightSpacer30,
                        Visibility(
                            visible: !widget.isForNewOrder,
                            child: Stack(
                              //mainAxisSize: MainAxisSize.min,
                              children: [
                                Align(
                                    alignment: Alignment.center,
                                    child: Column(
                                      children: [
                                        Text(WELCOME_BACK,
                                            style: getTextStyle(
                                              fontSize: SMALL_FONT_SIZE,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.w500,
                                            )),
                                        hightSpacer5,
                                        Text(
                                          manager != null ? manager!.name : "",
                                          style: getTextStyle(
                                              fontSize: LARGE_FONT_SIZE,
                                              color: AppColors.secondary),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    )),
                                /*  Align(
                                    alignment: Alignment.topRight,
                                    child: Stack(
                                      children: [
                                        Showcase(
                                            key: _focusKey,
                                            description:
                                                'Tap here to create the new order',
                                            child: IconButton(
                                                onPressed: (() async {
                                                  await Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              const ProductListHome(
                                                                  isForNewOrder:
                                                                      true)));
                                                  setState(() {});
                                                }),
                                                icon: SvgPicture.asset(
                                                  NEW_ORDER_ICON,
                                                  height: 25,
                                                  width: 25,
                                                ))),
                                      ],
                                    )),*/
                              ],
                            )),
                        Visibility(
                            visible: widget.isForNewOrder,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () => Navigator.pop(context),
                                  child: Padding(
                                    padding: smallPaddingAll(),
                                    child: SvgPicture.asset(
                                      BACK_IMAGE,
                                      color: AppColors.getTextandCancelIcon(),
                                      width: 25,
                                    ),
                                  ),
                                ),
                                Text(
                                  _selectedCust != null
                                      ? _selectedCust!.name
                                      : '',
                                  style: getTextStyle(
                                      fontSize: LARGE_FONT_SIZE,
                                      color: AppColors.primary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Stack(
                                    alignment: Alignment.topCenter,
                                    children: [
                                      IconButton(
                                        onPressed: (() async {
                                          if (parkOrder != null &&
                                              parkOrder!.items.isNotEmpty) {
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        CartScreen(
                                                            order:
                                                                parkOrder!)));
                                            setState(() {});
                                          } else {
                                            Helper.showPopup(
                                                context, "Your cart is empty");
                                          }
                                        }),
                                        icon: SvgPicture.asset(
                                          CART_ICON,
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                      Visibility(
                                          visible: parkOrder != null &&
                                              parkOrder!.items.isNotEmpty,
                                          child: Container(
                                              padding: const EdgeInsets.all(6),
                                              margin: const EdgeInsets.only(
                                                  left: 20),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color:
                                                      AppColors.shadowBorder),
                                              child: Text(
                                                parkOrder != null
                                                    ? parkOrder!.items.length
                                                        .toInt()
                                                        .toString()
                                                    : "0",
                                                style: getTextStyle(
                                                    fontSize: SMALL_FONT_SIZE,
                                                    color: AppColors
                                                        .fontWhiteColor),
                                              )))
                                    ])
                              ],
                            )),
                        hightSpacer15,
                        SearchWidget(
                          searchHint: 'Search product / category',
                          searchTextController: _searchTxtController,
                          onTap: () {
                            final state = _key.currentState;
                            if (state != null) {
                              debugPrint('isOpen:${state.isOpen}');
                              if (state.isOpen) {
                                state.toggle();
                              }
                            }
                          },
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
                          submit: () {
                            if (_searchTxtController.text.length >= 3) {
                              _filterProductsCategories(
                                  _searchTxtController.text);
                            } else {
                              getProducts();
                            }
                          },
                        ),
                        hightSpacer20,
                        SizedBox(
                            height: 100,
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                itemBuilder: (context, position) {
                                  return GestureDetector(
                                      onTap: (() {
                                        final state = _key.currentState;
                                        if (state != null) {
                                          debugPrint('isOpen:${state.isOpen}');
                                          if (state.isOpen) {
                                            state.toggle();
                                          }
                                        }
                                        _scrollToIndex(position);
                                      }),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            margin:
                                                const EdgeInsets.only(left: 5),
                                            height: 60,
                                            clipBehavior:
                                                Clip.antiAliasWithSaveLayer,
                                            decoration: const BoxDecoration(
                                                shape: BoxShape.circle),
                                            child: (isInternetAvailable &&
                                                    categories[position]
                                                        .items
                                                        .first
                                                        .productImageUrl!
                                                        .isNotEmpty)
                                                ? Image.network(
                                                    categories[position]
                                                        .items
                                                        .first
                                                        .productImageUrl!,
                                                    fit: BoxFit.fill,
                                                  )
                                                : (isInternetAvailable &&
                                                        categories[position]
                                                            .items
                                                            .first
                                                            .productImageUrl!
                                                            .isEmpty)
                                                    ? Image.asset(
                                                        NO_IMAGE,
                                                        fit: BoxFit.fill,
                                                      )
                                                    : Image.asset(
                                                        NO_IMAGE,
                                                        fit: BoxFit.fill,
                                                      ),
                                          ),
                                          hightSpacer10,
                                          Text(
                                            categories[position].name,
                                            style: getTextStyle(
                                                fontWeight: FontWeight.normal,
                                                fontSize: SMALL_PLUS_FONT_SIZE),
                                          )
                                        ],
                                      ));
                                })),

                        // FutureBuilder(
                        //   future: init(),
                        //   builder: (context, snapshot) {
                        //     if (snapshot.connectionState ==
                        //         ConnectionState.done) {
                        //       return categories.isEmpty
                        //           ? const Center(
                        //               child: Text(
                        //                 "No items found",
                        //                 style: TextStyle(
                        //                     fontWeight: FontWeight.bold),
                        //               ),
                        //             )
                        //           : _getCategoryItems(); // Replace with your actual widget
                        //     } else {
                        //       return const Center(
                        //         child:
                        //             CircularProgressIndicator(), // Or any loading indicator
                        //       );
                        //     }
                        //   },
                        // ),
                        categories.isEmpty
                            ? const Center(
                                child: Text(
                                "No items found",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ))
                            : _getCategoryItems(),
                        hightSpacer45
                      ],
                    ))))),
        floatingActionButtonLocation: ExpandableFab.location,
        floatingActionButton: Visibility(
            visible: !widget.isForNewOrder,
            child: ExpandableFab(
              key: _key,
              onOpen: (() {
                // setState(() {
                //   _isFABOpened = true;
                // });
              }),
              onClose: (() {
                // setState(() {
                //   _isFABOpened = false;
                // });
              }),
              type: ExpandableFabType.up,
              distance: 80,
              backgroundColor: AppColors.parkOrderButton,
              child: SvgPicture.asset(
                FAB_MAIN_ICON,
                height: 55,
                width: 55,
              ),
              closeButtonStyle: ExpandableFabCloseButtonStyle(
                  child: SvgPicture.asset(
                FAB_MAIN_ICON,
                height: 55,
                width: 55,
              )),
              children: [
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                      heroTag: 'finance',
                      onPressed: (() async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Finance()));
                        _key.currentState!.toggle();
                        setState(() {});
                      }),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      backgroundColor: AppColors.fontWhiteColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            FAB_FINANCE_ICON,
                            color: AppColors.getTextandCancelIcon(),
                            height: 25,
                            width: 25,
                          ),
                          hightSpacer5,
                          Text('Finance',
                              style: getTextStyle(
                                  fontSize: SMALL_FONT_SIZE,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                ),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                      heroTag: 'account',
                      onPressed: (() async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyAccount()));
                        _key.currentState!.toggle();
                        setState(() {});
                      }),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      backgroundColor: AppColors.fontWhiteColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            FAB_ACCOUNT_ICON,
                            color: AppColors.getTextandCancelIcon(),
                            height: 25,
                            width: 25,
                          ),
                          hightSpacer5,
                          Text('My Profile',
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                  fontSize: SMALL_FONT_SIZE,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                ),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                      heroTag: 'transactions',
                      onPressed: (() async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const TransactionScreen()));
                        _key.currentState!.toggle();
                        setState(() {});
                      }),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      backgroundColor: AppColors.fontWhiteColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            FAB_HISTORY_ICON,
                            color: AppColors.getTextandCancelIcon(),
                            height: 25,
                            width: 25,
                          ),
                          hightSpacer5,
                          Text('History',
                              textAlign: TextAlign.center,
                              style: getTextStyle(
                                  fontSize: SMALL_FONT_SIZE,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                ),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                      heroTag: 'customers',
                      onPressed: (() async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Customers()));
                        _key.currentState!.toggle();
                        setState(() {});
                      }),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      backgroundColor: AppColors.fontWhiteColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            FAB_CUSTOMERS_ICON,
                            color: AppColors.getTextandCancelIcon(),
                            height: 25,
                            width: 25,
                          ),
                          hightSpacer5,
                          Text('Customer',
                              style: getTextStyle(
                                  fontSize: SMALL_FONT_SIZE,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                ),
                // SizedBox(
                //   height: 70,
                //   width: 70,
                //   child: FloatingActionButton(
                //       heroTag: 'products',
                //       onPressed: (() {
                //         Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const Products()));
                //       }),
                //       shape: const RoundedRectangleBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(8))),
                //       backgroundColor: AppColors.fontWhiteColor,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           SvgPicture.asset(
                //             FAB_PRODUCTS_ICON,
                //             color: AppColors.getTextandCancelIcon(),
                //             height: 25,
                //             width: 25,
                //           ),
                //           hightSpacer5,
                //           Text('Product',
                //               style: getTextStyle(
                //                   fontSize: SMALL_FONT_SIZE,
                //                   fontWeight: FontWeight.normal))
                //         ],
                //       )),
                // ),
                SizedBox(
                  height: 70,
                  width: 70,
                  child: FloatingActionButton(
                      heroTag: 'create order',
                      onPressed: (() async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ProductListHome(
                                    isForNewOrder: true)));
                        _key.currentState!.toggle();
                        setState(() {});
                      }),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8))),
                      backgroundColor: AppColors.fontWhiteColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            FAB_ORDERS_ICON,
                            color: AppColors.getTextandCancelIcon(),
                            height: 25,
                            width: 25,
                          ),
                          hightSpacer5,
                          Text('Order',
                              style: getTextStyle(
                                  fontSize: SMALL_FONT_SIZE,
                                  fontWeight: FontWeight.w600))
                        ],
                      )),
                ),
                // SizedBox(
                //   height: 70,
                //   width: 70,
                //   child: FloatingActionButton(
                //       heroTag: 'home',
                //       onPressed: (() {
                //         _key.currentState!.toggle();
                //       }),
                //       shape: const RoundedRectangleBorder(
                //           borderRadius: BorderRadius.all(Radius.circular(8))),
                //       backgroundColor: AppColors.fontWhiteColor,
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           SvgPicture.asset(
                //             FAB_HOME_ICON,
                //             color: AppColors.getTextandCancelIcon(),
                //             height: 25,
                //             width: 25,
                //           ),
                //           hightSpacer5,
                //           Text('Home',
                //               style: getTextStyle(
                //                   fontSize: SMALL_FONT_SIZE,
                //                   fontWeight: FontWeight.w600))
                //         ],
                //       )),
                // ),
              ],
            )),
      ),
    ));
  }

  _getCategoryItems() {
    return ListView.builder(
        shrinkWrap: true,
        primary: false,
        itemCount: categories.length,
        itemBuilder: ((context, catPosition) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              hightSpacer20,
              Text(categories[catPosition].name,
                  style: getTextStyle(fontSize: LARGE_MINUS_FONT_SIZE)),
              hightSpacer10,
              GridView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: categories[catPosition].items.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 4.0,
                      mainAxisSpacing: 4.0),
                  itemBuilder: ((context, itemPosition) {
                    return GestureDetector(
                        onTap: () {
                          final state = _key.currentState;
                          if (state != null) {
                            debugPrint('isOpen:${state.isOpen}');
                            if (state.isOpen) {
                              state.toggle();
                            }
                          }
                          if (widget.isForNewOrder) {
                            if (categories[catPosition]
                                    .items[itemPosition]
                                    .stock >
                                0) {
                              var item = OrderItem.fromJson(
                                  categories[catPosition]
                                      .items[itemPosition]
                                      .toJson());
                              log('Selected Item :: $item');
                              _openItemDetailDialog(context, item);
                            } else {
                              Helper.showPopup(
                                  context, 'Sorry, item is not in stock.');
                            }
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ProductListHome(
                                        isForNewOrder: true)));
                            // Helper.showPopup(
                            //     context, "Please select customer first");
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              ShowCaseWidget.of(context)
                                  .startShowCase([_focusKey]);
                            });
                            setState(() {
                              _scrollController.jumpTo(0);
                            });
                          }
                        },
                        child: ColorFiltered(
                            colorFilter: ColorFilter.mode(
                                categories[catPosition]
                                            .items[itemPosition]
                                            .stock >
                                        0
                                    ? Colors.transparent
                                    : Colors.white.withOpacity(0.6),
                                BlendMode.screen),
                            child: Stack(
                              alignment: Alignment.topCenter,
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    margin: paddingXY(x: 5, y: 5),
                                    padding: paddingXY(y: 0, x: 10),
                                    width: 145,
                                    height: 90,
                                    decoration: BoxDecoration(
                                        color: AppColors.shadowBorder,
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
                                          //height: 30,
                                          child: Text(
                                            categories[catPosition]
                                                .items[itemPosition]
                                                .name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: getTextStyle(
                                                // color: DARK_GREY_COLOR,
                                                fontWeight: FontWeight.w500,
                                                fontSize: SMALL_PLUS_FONT_SIZE),
                                          ),
                                        ),
                                        hightSpacer4,
                                        Text(
                                          "$appCurrency ${categories[catPosition].items[itemPosition].price.toStringAsFixed(2)}",
                                          textAlign: TextAlign.center,
                                          style: getTextStyle(
                                              color:
                                                  AppColors.textandCancelIcon,
                                              fontSize: SMALL_PLUS_FONT_SIZE),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: AppColors.fontWhiteColor ??
                                                Colors.white),
                                        shape: BoxShape.circle),
                                    child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 5, right: 5),
                                      height: 55,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle),
                                      child:
                                          // categories[catPosition]
                                          //         .items[itemPosition]
                                          //         .productImageUrl!
                                          //         .isEmpty&&isInternetAvailable
                                          //     ? Image.asset(NO_IMAGE)
                                          //     : Image.memory(categories[catPosition]
                                          //         .items[itemPosition]
                                          //         .productImage),
                                          isInternetAvailable &&
                                                  (categories[catPosition]
                                                      .items[itemPosition]
                                                      .productImageUrl!
                                                      .isNotEmpty
                                                  // || categories[catPosition]
                                                  // .items[itemPosition]
                                                  // .productImageUrl != ""
                                                  )
                                              ? Image.network(
                                                  categories[catPosition]
                                                      .items[itemPosition]
                                                      .productImageUrl!,
                                                  fit: BoxFit.fill,
                                                )
                                              : isInternetAvailable &&
                                                      (categories[catPosition]
                                                          .items[itemPosition]
                                                          .productImageUrl!
                                                          .isEmpty
                                                      // || categories[catPosition]
                                                      // .items[itemPosition]
                                                      // .productImageUrl=="")
                                                      )
                                                  ? Image.asset(
                                                      NO_IMAGE,
                                                      fit: BoxFit.fill,
                                                    )
                                                  : Image.asset(
                                                      NO_IMAGE,
                                                      fit: BoxFit.fill,
                                                    ),
                                    )),
                                Container(
                                    padding: const EdgeInsets.all(6),
                                    margin: const EdgeInsets.only(left: 45),
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFF62B146)),
                                    child: Text(
                                      categories[catPosition]
                                          .items[itemPosition]
                                          .stock
                                          .toInt()
                                          .toString(),
                                      style: getTextStyle(
                                          fontSize: SMALL_FONT_SIZE,
                                          color: AppColors.fontWhiteColor),
                                    ))
                              ],
                            )));
                  })),
              hightSpacer30
            ],
          );
        }));
  }

  // Future<bool> isInternetAvailable() async {
  //  return await Helper.isNetworkAvailable();
  // }

  Future<void> getProducts() async {
    //Fetching data from DbProduct database
    // products = await DbProduct().getProducts();
    // categories = Category.getCategories(products);
    categories = await DbCategory().getCategories();
    setState(() {});
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

  // _getManagerName() async {
  //   // await DBPreferences().getPreference(Manager);
  //   HubManager? manager = await DbHubManager().getManager();
  //   if (manager != null) {
  //     managerName = manager!.name;
  //     //profilePic = manager.profileImage;
  //     setState(() {});
  //   } else {
  //     // Handle the case where the manager is null
  //     // For example, show an error message or set default values.
  //     log('Manager is null');
  //   }
  // }
  // _getManagerName() async {
  //   HubManager manager = await DbHubManager().getManager() as HubManager;
  //   managerName = manager.name;
  //   //profilePic = manager.profileImage;
  //   setState(() {});
  // }

  _getManagerName() async {
    DbHubManager dbHubManager = DbHubManager();

    var hubManagerData = await dbHubManager.getManager();
    manager = HubManager(
        id: hubManagerData!.id,
        name: hubManagerData.name,
        emailId: hubManagerData.emailId,
        phone: hubManagerData.phone,
        profileImage: hubManagerData.profileImage);
    // await dbHubManager.addManager(manager!);
    // await dbHubManager.getManager();
    //   //profilePic = manager.profileImage;
    setState(() {});

    // await DBPreferences().savePreference(Manager, manager!.name);
    // await DBPreferences().getPreference(Manager);
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
      if (parkOrder == null) {
        HubManager manager = await DbHubManager().getManager() as HubManager;
        parkOrder = ParkOrder(
          id: _selectedCust!.id,
          date: Helper.getCurrentDate(),
          time: Helper.getCurrentTime(),
          customer: _selectedCust!,
          items: [],
          orderAmount: 0,
          manager: manager,
          transactionDateTime: DateTime.now(),
        );
      }

      setState(() {
        if (product.orderedQuantity > 0 &&
            !parkOrder!.items.contains(product)) {
          OrderItem newItem = product;
          parkOrder!.items.add(newItem);
          _calculateOrderAmount();
        } else if (product.orderedQuantity == 0) {
          parkOrder!.items.remove(product);
          _calculateOrderAmount();
        }
      });
      // DbParkedOrder().saveOrder(parkOrder!);
    }
    return res;
  }

  void _calculateOrderAmount() {
    double amount = 0;
    for (var item in parkOrder!.items) {
      amount += item.orderedPrice * item.orderedQuantity;
    }
    parkOrder!.orderAmount = amount;
  }

  _syncDataOnInAppLogin() async {
    if (widget.isAppLoggedIn) {
      await ProductsService().getCategoryProduct();
      setState(() {});
    }
  }

  void goToSelectCustomer() async {
    var data = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => const NewSelectCustomer()));
    if (data != null) {
      getProducts();
      setState(() {
        _selectedCust = data;
      });
    } else {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }
}
