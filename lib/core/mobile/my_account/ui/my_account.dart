import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
import '../../../../../widgets/main_drawer.dart';
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
      endDrawer: MainDrawer(
        menuItem: Helper.getMenuItemList(),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppbar(title: MY_ACCOUNT_TXT),
            hightSpacer30,
            _getProfileImage(),
            hightSpacer10,
            Text(name ?? "",
                style: getTextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: MEDIUM_PLUS_FONT_SIZE,
                )),
            Padding(
              padding: smallPaddingAll(),
              child: Text(email ?? "",
                  style: getTextStyle(
                      color: MAIN_COLOR,
                      fontSize: MEDIUM_MINUS_FONT_SIZE,
                      fontWeight: FontWeight.normal)),
            ),
            Text(phone ?? "",
                style: getTextStyle(
                  fontWeight: FontWeight.w500,
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
        await SyncHelper().logoutFlow();
        if (!mounted) return;
        Navigator.pop(context);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      }
    } else {
      if (!mounted) return;
      await Helper.showConfirmationPopup(context, OFFLINE_ORDER_MSG, OPTION_OK);
      // print("You clicked $res");
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
            backgroundColor: MAIN_COLOR,
            foregroundImage: MemoryImage(profilePic),
          );
  }
}
