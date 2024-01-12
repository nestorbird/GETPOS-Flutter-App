import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';


import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';

import '../../service/finance/api/get_updated_account_details.dart';
import '../widget/change_password.dart';
import '../widget/finance.dart';
import '../widget/logout_popup.dart';
import '../widget/title_search_bar.dart';

class MyAccountLandscape extends StatefulWidget {
  const MyAccountLandscape({Key? key}) : super(key: key);

  @override
  State<MyAccountLandscape> createState() => _MyAccountLandscapeState();
}

class _MyAccountLandscapeState extends State<MyAccountLandscape> {
  var isChangePasswordVisible = true;
  double iconWidth = 80;

  late String cashCollected = "00.00";

  @override
  void initState() {
    super.initState();
    _initView();
  }

  _getcashCollected() async {
    HubManager manager = await DbHubManager().getManager() as HubManager;
    cashCollected = Helper().formatCurrency(manager.cashBalance);
    setState(() {});
  }

  _initView() async {
    if (await Helper.isNetworkAvailable()) {
      // print("INTERNET AVAILABLE");
      Helper.showLoaderDialog(context);
      await UpdatedHubManagerDetails().getUpdatedAccountDetails();
      if (!mounted) return;
      Helper.hideLoader(context);
      _getcashCollected();
    } else {
      // print("INTERNET NOT AVAILABLE");
      _getcashCollected();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      // color: const Color(0xFFF9F8FB),
      // padding: paddingXY(),
      child: Column(
        children: [
          hightSpacer20,
          TitleAndSearchBar(
            title: "My Profile",
            searchBoxVisible: false,
            onSubmit: (val) {},
            onTextChanged: (val) {},
            searchCtrl: null,
            searchHint: "",
            hideOperatorDetails: true,
          ),
          hightSpacer20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      widthSpacer(5),
                      SvgPicture.asset(
                        MY_PROFILE_TAB_IMAGE,
                        // color: MAIN_COLOR,
                        width: 25,
                      ),
                      widthSpacer(10),
                      Text(
                        Helper.hubManager!.name,
                        style: getTextStyle(
                            fontSize: LARGE_MINUS_FONT_SIZE,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  hightSpacer20,
                  Text(
                    Helper.hubManager!.phone,
                    style: getTextStyle(
                        fontSize: LARGE_MINUS_FONT_SIZE,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                Helper.hubManager!.emailId,
                style: getTextStyle(
                    fontSize: LARGE_MINUS_FONT_SIZE,
                    fontWeight: FontWeight.w500),
              ),
            ],
          ),
          hightSpacer10,
          Divider(thickness: 1, color: AppColors.getAsset().withOpacity(0.3)),
          hightSpacer20,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  debugPrint("Change Password clicked");
                  setState(() {
                    isChangePasswordVisible = true;
                  });
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      isChangePasswordVisible
                          ? CHANGE_PASS_ACTIVE_TAB_IMAGE
                          : CHANGE_PASS_TAB_IMAGE,
                      // color: MAIN_COLOR,
                      width: iconWidth,
                    ),
                    Text(
                      "Change Password",
                      style: getTextStyle(
                          fontSize: LARGE_MINUS_FONT_SIZE,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  debugPrint("Finance clicked");
                  setState(() {
                    isChangePasswordVisible = false;
                  });
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      isChangePasswordVisible
                          ? FINANCE_TAB_IMAGE
                          : FINANCE_ACTIVE_TAB_IMAGE,
                      width: iconWidth,
                    ),
                    Text(
                      "Finance",
                      style: getTextStyle(
                          fontSize: LARGE_MINUS_FONT_SIZE,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  debugPrint("Logout clicked need to show popup");
                  await Get.defaultDialog(
                    // contentPadding: paddingXY(x: 0, y: 0),
                    title: "",
                    titlePadding: paddingXY(x: 0, y: 0),
                    // custom: Container(),
                    content: const LogoutPopupView(),
                  );
                },
                child: Column(
                  children: [
                    SvgPicture.asset(
                      LOGOUT_TAB_IMAGE,
                      // color: MAIN_COLOR,
                      width: iconWidth,
                    ),
                    Text("Logout",
                        style: getTextStyle(
                            fontSize: LARGE_MINUS_FONT_SIZE,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
              )
            ],
          ),
          Visibility(
            visible: isChangePasswordVisible,
            child: const ChangePasswordView(),
          ),
          Visibility(
            visible: !isChangePasswordVisible,
            child: FinanceView(cashCollected: cashCollected),
          ),
        ],
      ),
    );
  }
}
