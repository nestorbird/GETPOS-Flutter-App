import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';

import '../../../../../database/db_utils/db_categories.dart';
import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/db_utils/db_sale_order.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/helpers/sync_helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../create_order_new/ui/new_create_order.dart';
import '../../customers/ui/customers.dart';
import '../../finance/ui/finance.dart';
import '../../my_account/ui/my_account.dart';
import '../../parked_orders/ui/orderlist_screen.dart';
import '../../products/ui/products.dart';
import '../../transaction_history/view/transaction_screen.dart';
import 'home_tile.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool syncNowActive = true;
  late String managerName;
  late Uint8List profilePic;

  @override
  void initState() {
    super.initState();
    managerName = "John";
    profilePic = Uint8List.fromList([]);
    _getManagerName();
    _checkForSyncNow();
    _checkForRedirects();
  }

  _checkForSyncNow() async {
    var offlineOrders = await DbSaleOrder().getOfflineOrders();
    // debugPrint("OFFLINE ORDERS: ${offlineOrders.length}");
    syncNowActive = offlineOrders.isEmpty;
    var categories = await DbCategory().getCategories();
    debugPrint("Category: ${categories.length}");
    setState(() {});
  }

  _getManagerName() async {
    HubManager manager = await DbHubManager().getManager() as HubManager;
    managerName = manager.name;
    profilePic = manager.profileImage;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: MainDrawer(
      //   menuItem: Helper.getMenuItemList(context),
      // ),
      body: Builder(
        builder: (ctx) => SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: mediumPaddingAll(),
                    child: SvgPicture.asset(
                      MENU_ICON,
                      color: WHITE_COLOR,
                      width: 20,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        hightSpacer30,
                        Text(
                          WELCOME_BACK,
                          style: getTextStyle(
                            fontSize: SMALL_FONT_SIZE,
                            color: MAIN_COLOR,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        hightSpacer5,
                        Text(
                          managerName,
                          style: getTextStyle(
                              fontSize: LARGE_FONT_SIZE,
                              color: DARK_GREY_COLOR),
                          overflow: TextOverflow.ellipsis,
                        ),
                        hightSpacer30,
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => _openSideMenu(ctx),
                    child: Padding(
                      padding: mediumPaddingAll(),
                      child: SvgPicture.asset(
                        MENU_ICON,
                        color: BLACK_COLOR,
                        width: 20,
                      ),
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    HOME_TILE_PADDING_LEFT,
                    HOME_TILE_PADDING_TOP,
                    HOME_TILE_PADDING_RIGHT,
                    HOME_TILE_PADDING_BOTTOM),
                child: GridView.count(
                  crossAxisCount: HOME_TILE_GRID_COUNT,
                  mainAxisSpacing: HOME_TILE_VERTICAL_SPACING,
                  crossAxisSpacing: HOME_TILE_HORIZONTAL_SPACING,
                  shrinkWrap: true,
                  childAspectRatio: .9,
                  physics: const ScrollPhysics(),
                  children: [
                    HomeTile(
                      title: CREATE_ORDER_TXT,
                      asset: CREATE_ORDER_IMAGE,
                      nextScreen: NewCreateOrder(),
                      onReturn: () {},
                    ),
                    // HomeTile(
                    //   title: CREATE_ORDER_TXT,
                    //   asset: CREATE_ORDER_IMAGE,
                    //   nextScreen: const CreateOrderScreen(),
                    //   onReturn: () => _checkForSyncNow(),
                    // ),
                    HomeTile(
                      title: PRODUCTS_TXT,
                      asset: PRODUCT_IMAGE,
                      nextScreen: const Products(),
                      onReturn: () {},
                    ),
                    HomeTile(
                      title: CUSTOMERS_TXT,
                      asset: CUSTOMER_IMAGE,
                      nextScreen: const Customers(),
                      onReturn: () {},
                    ),
                    HomeTile(
                      title: MY_ACCOUNT_TXT,
                      asset: HOME_USER_IMAGE,
                      nextScreen: const MyAccount(),
                      onReturn: () {},
                    ),
                    HomeTile(
                      title: SALES_HISTORY_TXT,
                      asset: SALES_IMAGE,
                      nextScreen: const TransactionScreen(),
                      // nextScreen: const SalesHistory(),
                      onReturn: () {},
                    ),
                    HomeTile(
                      title: FINANCE_TXT,
                      asset: FINANCE_IMAGE,
                      nextScreen: const Finance(),
                      onReturn: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  ///
  ///  Show the Active status of the Sync now Btn
  ///
  void manageSync(bool value) async {
    if (syncNowActive == false) {
      if (await Helper.isNetworkAvailable()) {
        Helper.showLoaderDialog(context);
        await SyncHelper().syncNowFlow();
        _checkForSyncNow();
        _getManagerName();
        if (!mounted) return;
        Helper.hideLoader(context);
      } else {
        Helper.showSnackBar(context, NO_INTERNET);
      }
    }
  }

  void _openSideMenu(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void _checkForRedirects() {
    if (Get.arguments != null && Get.arguments == "parked_order") {
      Future.delayed(
          Duration.zero,
          () => Get.to(() => const OrderListScreen(),
              duration: const Duration(milliseconds: 1)));
    } else if (Get.arguments != null && Get.arguments == "create_new_order") {
      Future.delayed(Duration.zero, () => Get.to(() => NewCreateOrder()));
    }
  }
}
