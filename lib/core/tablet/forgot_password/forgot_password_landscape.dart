import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../constants/asset_paths.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../utils/ui_utils/textfield_border_decoration.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/text_field_widget.dart';

import '../../mobile/forgot_password/ui/verify_otp.dart';
import '../../service/forgot_password/api/forgot_password_api.dart';

class ForgotPasswordLandscape extends StatefulWidget {
  const ForgotPasswordLandscape({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordLandscape> createState() =>
      _ForgotPasswordLandscapeState();
}

class _ForgotPasswordLandscapeState extends State<ForgotPasswordLandscape> {
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();

    // _getAppVersion();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();

    super.dispose();
  }

  /// TITLE TXT(HEADING) IN CENTER
  ///
  Widget get headingLblWidget => Center(
        child: Text(
          "Forgot Password",
          style: getTextStyle(
            // color: MAIN_COLOR,
            fontWeight: FontWeight.w500,
            fontSize: 26.0,
          ),
        ),
      );

  Widget get subHeadingLblWidget => Center(
        child: Text(
          FORGOT_SUB_MSG,
          textAlign: TextAlign.center,
          style: getTextStyle(
            // color: MAIN_COLOR,
            fontWeight: FontWeight.w400,
            fontSize: LARGE_MINUS_FONT_SIZE,
          ),
        ),
      );

  /// EMAIL SECTION
  Widget get emailTxtboxSection => Padding(
        // margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: SizedBox(
          height: 55,
          child: TextFieldWidget(
            boxDecoration: txtFieldBoxShadowDecoration,
            txtCtrl: _emailCtrl,
            verticalContentPadding: 16,
            hintText: "Enter registered email id",
          ),
        ),
      );

  /// LOGIN BUTTON
  Widget get cancelBtnWidget => SizedBox(
        // width: double.infinity,
        child: ButtonWidget(
          onPressed: () => Get.back(),
          title: "Cancel",
          colorBG: DARK_GREY_COLOR,
          // width: MediaQuery.of(context).size.width - 150,
          height: 60,
          fontSize: LARGE_PLUS_FONT_SIZE,
        ),
      );

  Widget get continueBtnWidget => SizedBox(
        // width: double.infinity,
        child: ButtonWidget(
          onPressed: () async {
            await _handleForgotPassBtnClick();
          },
          title: "Continue",
          colorBG: MAIN_COLOR,
          // width: MediaQuery.of(context).size.width - 150,
          height: 60,
          fontSize: LARGE_PLUS_FONT_SIZE,
        ),
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: WHITE_COLOR,
        body: Stack(
          children: [
            SvgPicture.asset(
              LOGIN_IMAGE,
            ),
            Center(
              child: Container(
                width: 550,
                padding: paddingXY(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    headingLblWidget,
                    hightSpacer50,
                    SizedBox(
                      width: 450,
                      child: subHeadingLblWidget,
                    ),
                    hightSpacer50,
                    emailTxtboxSection,
                    hightSpacer20,
                    hightSpacer20,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [cancelBtnWidget, continueBtnWidget],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// HANDLE BACK BTN PRESS ON LOGIN SCREEN
  Future<bool> _onBackPressed() async {
    var res = await Helper.showConfirmationPopup(
        context, CLOSE_APP_QUESTION, OPTION_YES,
        hasCancelAction: true);
    if (res != OPTION_CANCEL) {
      exit(0);
    }
    return false;
  }

  /// HANDLE FORGOT PASS BTN CLICK
  Future<void> _handleForgotPassBtnClick() async {
    if (_emailCtrl.text.trim().isNotEmpty) {
      Helper.showLoaderDialog(context);
      CommanResponse response = await ForgotPasswordApi()
          .sendResetPasswordMail(_emailCtrl.text.trim());
      if (response.status!) {
        if (!mounted) return;
        Helper.hideLoader(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const VerifyOtp()));
      } else {
        if (!mounted) return;
        Helper.hideLoader(context);
        Helper.showSnackBar(context, response.message);
      }
    } else {
      Helper.showSnackBar(context, FORGOT_TXT_FIELD_EMPTY);
    }
  }
}
