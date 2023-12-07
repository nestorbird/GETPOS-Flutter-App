//import 'dart:html';
import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/core/mobile/theme/theme_setting_screen.dart';
import 'package:nb_posx/core/service/create_order/model/create_sales_order_response.dart';
import 'package:nb_posx/core/tablet/theme_setting/theme_landscape.dart';
import 'package:nb_posx/database/db_utils/db_customer.dart';
import 'package:nb_posx/database/db_utils/db_instance_url.dart';
import 'package:nb_posx/database/db_utils/db_preferences.dart';
import 'package:nb_posx/database/models/customer.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';

import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/db_utils/db_sale_order.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/helpers/sync_helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../utils/ui_utils/text_styles/edit_text_hint_style.dart';
import '../../../../../widgets/custom_appbar.dart';
import '../../change_password/ui/change_password.dart';
import '../../login/ui/login.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({Key? key}) : super(key: key);

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  String? name, email, phone, version;

  late Uint8List profilePic;

  @override
  void initState() {
    super.initState();

    profilePic = Uint8List.fromList([]);

    getManagerName();
  }

  ///Function to fetch the hub manager account details
  getManagerName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    //Fetching the data from database
    HubManager manager = await DbHubManager().getManager() as HubManager;

    name = manager.name;
    email = manager.emailId;
    phone = manager.phone;
    version = "$APP_VERSION - ${packageInfo.version}";
    profilePic = manager.profileImage;
    setState(() {});
  }

  Widget _actionListItem(imageAsset, label) => Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                MY_ACCOUNT_ICON_PADDING_LEFT,
                MY_ACCOUNT_ICON_PADDING_TOP,
                MY_ACCOUNT_ICON_PADDING_RIGHT,
                MY_ACCOUNT_ICON_PADDING_BOTTOM),
            child: SvgPicture.asset(
              imageAsset,
              width: MY_ACCOUNT_ICON_WIDTH,
            ),
          ),
          Text(
            label,
            style: getBoldStyle(),
          )
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // endDrawer: MainDrawer(
      //   menuItem: Helper.getMenuItemList(context),
      // ),
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppbar(title: MY_ACCOUNT_TXT, hideSidemenu: true),
            hightSpacer30,
            _getProfileImage(),
            hightSpacer10,
            Text(name ?? "",
                style: getTextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: MEDIUM_PLUS_FONT_SIZE,
                )),
            Padding(
              padding: smallPaddingAll(),
              child: Text(email ?? "",
                  style: getTextStyle(
                      color: AppColors.getPrimary(),
                      fontSize: MEDIUM_MINUS_FONT_SIZE,
                      fontWeight: FontWeight.normal)),
            ),
            Text(phone ?? "",
                style: getTextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: MEDIUM_PLUS_FONT_SIZE,
                )),
            hightSpacer25,
            Container(
              margin: horizontalSpace(x: 32),
              height: 100,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChangePassword()));
                    },
                    child:
                        _actionListItem(CHANGE_PASSWORD_IMAGE, CHANGE_PASSWORD),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () => handleLogout(),
                    child: _actionListItem(LOGOUT_IMAGE, LOGOUT_TITLE),
                  ),
                ],
              ),
              // decoration: BoxDecoration(
              //     borderRadius:
              //         BorderRadius.circular(BORDER_CIRCULAR_RADIUS_20),
              //     boxShadow: [boxShadow]),
            ),
            const Spacer(),
            Center(
                child: Text(
              version ?? APP_VERSION_FALLBACK,
              style: getHintStyle(),
            )),
            hightSpacer10
          ],
        ),
      ),
    );
  }

  Future<void> handleLogout() async {
    var offlineOrders = await DbSaleOrder().getOfflineOrders();
    if (offlineOrders.isEmpty) {
      if (!mounted) return;
      var res = await Helper.showConfirmationPopup(
          context, LOGOUT_QUESTION, OPTION_YES,
          hasCancelAction: true);
      if (res != OPTION_CANCEL.toLowerCase()) {
        //check this later
        await SyncHelper().logoutFlow();

        await fetchMasterAndDeleteTransaction();
      }
    } else {
      if (!mounted) return;
      await Helper.showConfirmationPopup(context, OFFLINE_ORDER_MSG, OPTION_OK);
      // print("You clicked $res");
    }
  }

  Future<void> fetchDataAndNavigate() async {
    // log('Entering fetchDataAndNavigate');
    try {
      // Fetch the URL
      String url = await DbInstanceUrl().getUrl();
      // Clear the database
      await DBPreferences().delete();
      log("Cleared the DB");
      //to save the url
      await DbInstanceUrl().saveUrl(url);
      log("Saved Url:$url");
      // Navigate to a different screen
      // ignore: use_build_context_synchronously
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const ThemeChange(),
        ),
      );

      // Save the URL again
      //await DBPreferences().savePreference('url', url);
    } catch (e) {
      // Handle any errors that may occur during this process
      log('Error: $e');
    }
  }

  Widget _getProfileImage() {
    return profilePic.isEmpty
        ? SvgPicture.asset(
            MY_ACCOUNT_IMAGE,
            width: 200,
          )
        : CircleAvatar(
            radius: 64,
            backgroundColor: AppColors.getPrimary(),
            foregroundImage: MemoryImage(profilePic),
          );
  }

  Future<void> fetchMasterAndDeleteTransaction() async {
    // log('Entering fetchDataAndNavigate');
    try {
      // Fetch the URL
      String url = await DbInstanceUrl().getUrl();
      // Clear the transactional data
      await DBPreferences().deleteTranscationData();
      // await DbCustomer().deleteCustomer(DeleteCustomers);
      // await DbSaleOrder().delete();
      log("Cleared the transactional data");
      //to save the url
      await DbInstanceUrl().saveUrl(url);
      log("Saved Url:$url");
      // Navigate to a different screen
      // ignore: use_build_context_synchronously
      await Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Login(),
        ),
      );

      // Save the URL again
      //await DBPreferences().savePreference('url', url);
    } catch (e) {
      // Handle any errors that may occur during this process
      log('Error: $e');
    }
  }
}
