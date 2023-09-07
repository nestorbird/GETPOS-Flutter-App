import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';

import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../utils/ui_utils/textfield_border_decoration.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/text_field_widget.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../network/api_constants/api_paths.dart';
import '../../../service/forgot_password/api/forgot_password_api.dart';

import 'verify_otp.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController _emailCtrl, _urlCtrl;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
    _urlCtrl = TextEditingController();
    _urlCtrl.text = "getpos.in";
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    /// MAIN BODY
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: smallPaddingAll(),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: Padding(
                          padding: smallPaddingAll(),
                          child: SvgPicture.asset(
                            BACK_IMAGE,
                            color: BLACK_COLOR,
                            width: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  hightSpacer50,
                  hightSpacer50,
                  // hightSpacer50,
                  // appLogo
                  Image.asset(APP_ICON, width: 100, height: 100),
                  hightSpacer50,
                  hightSpacer25,
                  headingLblWidget(),
                  hightSpacer15,
                  instanceUrlTxtboxSection(context),
                  hightSpacer15,
                  forgotPassTxtSection(),
                  hightSpacer32,
                  otpBtnWidget(),
                ],
              ),
            ),
          ),
        ));
  }

  ///Input field for entering the instance URL
  Widget instanceUrlTxtboxSection(context) => Container(
        margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: leftSpace(x: 10),
              child: Text(
                URL_TXT,
                style: getTextStyle(fontSize: MEDIUM_MINUS_FONT_SIZE),
              ),
            ),
            hightSpacer15,
            TextFieldWidget(
              boxDecoration: txtFieldBorderDecoration,
              txtCtrl: _urlCtrl,
              hintText: URL_HINT,
            ),
          ],
        ),
      );

  /// HANDLE FORGOT PASS BTN CLICK
  Future<void> _handleForgotPassBtnClick() async {
    String url = "https://${_urlCtrl.text}/api/";

    try {
      Helper.showLoaderDialog(context);
      CommanResponse response = await ForgotPasswordApi()
          .sendResetPasswordMail(_emailCtrl.text.trim(), url.trim());
      if (response.status!) {
        if (!mounted) return;
        Helper.hideLoader(context);
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const VerifyOtp()));
      } else {
        if (!mounted) return;
        Helper.hideLoader(context);
        Helper.showPopup(context, response.message);
      }
    } catch (e) {
      log('Exception ocurred in Forgot Password :: $e');
    }
  }

  /// FORGOT PASSWORD SECTION
  Widget forgotPassTxtSection() => Container(
        margin: horizontalSpace(),
        padding: smallPaddingAll(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: leftSpace(x: 10),
              child: Text(
                FORGOT_EMAIL_TXT,
                style: getTextStyle(fontSize: MEDIUM_MINUS_FONT_SIZE),
              ),
            ),
            hightSpacer15,
            TextFieldWidget(
              boxDecoration: txtFieldBorderDecoration,
              txtCtrl: _emailCtrl,
              hintText: FORGOT_EMAIL_HINT,
            ),
          ],
        ),
      );

  /// SUBMIT BTN WIDGET
  Widget otpBtnWidget() => Center(
        child: ButtonWidget(
          onPressed: () async {
            await _handleForgotPassBtnClick();
          },
          width: MediaQuery.of(context).size.width,
          title: FORGOT_BTN_TXT,
          colorBG: MAIN_COLOR,
        ),
      );

  /// HEADER HEADING SECTION
  Widget headingLblWidget() => Center(
        child: Text(
          FORGOT_PASSWORD_TITLE.toUpperCase(),
          style: getTextStyle(
              fontWeight: FontWeight.bold,
              fontSize: LARGE_FONT_SIZE,
              color: MAIN_COLOR),
        ),
      );
}
