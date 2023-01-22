import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../widgets/button.dart';

class PasswordUpdated extends StatefulWidget {
  const PasswordUpdated({Key? key}) : super(key: key);

  @override
  State<PasswordUpdated> createState() => _PasswordUpdatedState();
}

class _PasswordUpdatedState extends State<PasswordUpdated> {
  late TextEditingController _newPassCtrl, _confirmPassCtrl;

  @override
  void initState() {
    super.initState();
    _newPassCtrl = TextEditingController();
    _confirmPassCtrl = TextEditingController();
  }

  @override
  void dispose() {
    _newPassCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget passwordUpdatedBtnWidget = SizedBox(
      width: 300,
      child: ButtonWidget(
        onPressed: () {
          Navigator.of(context).popUntil((route) => route.isFirst);
        },
        title: PASSWORD_UPDATED_BTN_TXT,
        colorBG: MAIN_COLOR,
        width: 350,
        //width: MediaQuery.of(context).size.width / 2.5,
      ),
    );
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            hightSpacer50,
            hightSpacer50,
            hightSpacer50,
            Image.asset(APP_ICON, width: 100, height: 100),
            hightSpacer50,
            // appLogo,
            hightSpacer50,
            Center(
              child: Text(
                PASSWORD_UPDATED_TITLE.toUpperCase(),
                style: getTextStyle(
                    color: MAIN_COLOR,
                    fontWeight: FontWeight.bold,
                    fontSize: LARGE_FONT_SIZE),
              ),
            ),
            hightSpacer50,
            Center(
              child: SvgPicture.asset(
                SUCCESS_IMAGE,
                height: 120,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
            hightSpacer40,
            Center(
              child: Text(
                PASSWORD_UPDATED_MSG,
                style: getTextStyle(
                    fontSize: SMALL_PLUS_FONT_SIZE,
                    fontWeight: FontWeight.w400),
              ),
            ),
            hightSpacer40,
            passwordUpdatedBtnWidget,
          ],
        ),
      ),
    );
  }
}
