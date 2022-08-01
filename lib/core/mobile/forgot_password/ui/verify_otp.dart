import 'package:flutter/material.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';
import '../../../../../utils/ui_utils/padding_margin.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/header_curve.dart';

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
        title: VERIFY_OTP_BTN_TXT.toUpperCase(),
        colorBG: MAIN_COLOR,
        width: MediaQuery.of(context).size.width - 100,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            HeaderCurveWidget(),
            Padding(
              padding: smallPaddingAll(),
              child: Column(
                children: [
                  hightSpacer50,
                  hightSpacer50,
                  hightSpacer50,
                  // appLogo,
                  const Spacer(flex: 2),
                  Center(
                    child: Text(
                      VERIFY_OTP_TITLE.toUpperCase(),
                      style: getTextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: LARGE_FONT_SIZE,
                          color: MAIN_COLOR),
                    ),
                  ),
                  hightSpacer10,
                  Center(
                    child: Padding(
                      padding: horizontalSpace(x: 32),
                      child: Text(
                        VERIFY_OTP_MSG,
                        style: getTextStyle(
                          fontSize: SMALL_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  const Spacer(flex: 3),
                  verifyOtpBtnWidget,
                  hightSpacer32,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
