import 'package:flutter/material.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/button.dart';
import '../../../../constants/asset_paths.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({Key? key}) : super(key: key);

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  double txtBorderWidth = 0.3;
  late TextEditingController _otpCtrl;

  @override
  void initState() {
    super.initState();
    _otpCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _otpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget verifyOtpBtnWidget = Center(
      child: ButtonWidget(
        onPressed: () {
          Navigator.popUntil(context, (route) => route.isFirst);
        },
        title: FORGOT_BTN_TXT,
        colorBG: MAIN_COLOR,
        width: MediaQuery.of(context).size.width,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            hightSpacer50,
            hightSpacer50,
            hightSpacer50,
            // appLogo,
            Image.asset(APP_ICON, width: 100, height: 100),
            hightSpacer50,
            hightSpacer50,
            Center(
              child: Text(
                VERIFY_OTP_TITLE.toUpperCase(),
                style: getTextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: LARGE_FONT_SIZE,
                    color: MAIN_COLOR),
              ),
            ),
            hightSpacer45,
            Center(
              child: Padding(
                padding: horizontalSpace(x: 32),
                child: Text(
                  VERIFY_OTP_MSG,
                  textAlign: TextAlign.center,
                  style: getTextStyle(
                    fontSize: MEDIUM_FONT_SIZE,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            hightSpacer40,
            verifyOtpBtnWidget,
            hightSpacer32,
          ],
        ),
      ),
    );
  }
}
