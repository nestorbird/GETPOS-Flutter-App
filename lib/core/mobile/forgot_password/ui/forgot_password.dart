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
import '../../../../../widgets/header_curve.dart';
import '../../../../../widgets/text_field_widget.dart';
import '../../../../constants/asset_paths.dart';
import '../../../service/forgot_password/api/forgot_password_api.dart';

import 'verify_otp.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  late TextEditingController _emailCtrl;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController();
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
      body: Stack(
        children: [
          HeaderCurveWidget(),
          SafeArea(
            child: Padding(
              padding: smallPaddingAll(),
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
                            color: Colors.white,
                            width: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                  hightSpacer50,
                  hightSpacer50,
                  hightSpacer50,
                  // hightSpacer50,
                  // appLogo,
                  hightSpacer50,
                  headingLblWidget(),
                  hightSpacer15,
                  forgotPassTxtSection(),
                  hightSpacer32,
                  otpBtnWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
            hightSpacer5,
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
          title: FORGOT_BTN_TXT.toUpperCase(),
          colorBG: MAIN_COLOR,
          width: MediaQuery.of(context).size.width - 100,
        ),
      );

  /// HEADER HEADING SECTION
  Widget headingLblWidget() => Center(
        child: Text(
          FORGOT_PASSWORD_TITLE.toUpperCase(),
          style: getTextStyle(
              fontWeight: FontWeight.w600,
              fontSize: LARGE_FONT_SIZE,
              color: MAIN_COLOR),
        ),
      );
}
