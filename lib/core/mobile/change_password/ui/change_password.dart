import 'package:flutter/material.dart';

import '../../../../configs/theme_config.dart';
import '../../../../constants/app_constants.dart';
import '../../../../constants/asset_paths.dart';
import '../../../../network/api_helper/comman_response.dart';
import '../../../../utils/helper.dart';
import '../../../../utils/ui_utils/padding_margin.dart';
import '../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../utils/ui_utils/text_styles/custom_text_style.dart';
import '../../../../utils/ui_utils/textfield_border_decoration.dart';
import '../../../../widgets/button.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../../../widgets/text_field_widget.dart';

import '../../../service/change_password/api/change_hubmanager_password.dart';
import 'password_updated.dart';

class ChangePassword extends StatefulWidget {
  final bool verifiedOtp;
  const ChangePassword({Key? key, this.verifiedOtp = false}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
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
    /// change pass btn widget
    Widget changePasswordBtnWidget = Center(
      child: ButtonWidget(
        onPressed: () async {
          await _handleChangePassBtnAction();
        },
        title: CHANGE_PASSWORD_BTN_TXT,
        colorBG: MAIN_COLOR,
        width: MediaQuery.of(context).size.width,
      ),
    );

    /// main area
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            hightSpacer40,
            const CustomAppbar(
              title: "",
              backBtnColor: BLACK_COLOR,
              hideSidemenu: true,
            ),
            hightSpacer20,
            Image.asset(APP_ICON, width: 100, height: 100),
            hightSpacer20,

            hightSpacer50,
            // appLogo,
            hightSpacer50,
            Center(
              child: Text(
                CHANGE_PASSWORD_TITLE.toUpperCase(),
                style: getTextStyle(
                    fontWeight: FontWeight.bold,
                    color: MAIN_COLOR,
                    fontSize: LARGE_FONT_SIZE),
              ),
            ),
            hightSpacer5,
            widget.verifiedOtp
                ? Center(
                    child: Text(
                      CHANGE_PASSWORD_OTP_VERIFY_MSG,
                      style: getTextStyle(
                          color: WHITE_COLOR,
                          fontSize: SMALL_PLUS_FONT_SIZE,
                          fontWeight: FontWeight.w500),
                    ),
                  )
                : Container(),
            Center(
              child: Text(
                CHANGE_PASSWORD_SET_MSG,
                style: getTextStyle(
                    color: WHITE_COLOR,
                    fontSize: SMALL_PLUS_FONT_SIZE,
                    fontWeight: FontWeight.w500),
              ),
            ),
            hightSpacer45,
            Container(
              margin: horizontalSpace(),
              padding: smallPaddingAll(),
              child: TextFieldWidget(
                boxDecoration: txtFieldBorderDecoration,
                txtCtrl: _newPassCtrl,
                hintText: CHANGE_NEW_PASSWORD_HINT,
                password: true,
              ),
            ),
            hightSpacer20,
            Container(
              margin: horizontalSpace(),
              padding: smallPaddingAll(),
              child: TextFieldWidget(
                boxDecoration: txtFieldBorderDecoration,
                txtCtrl: _confirmPassCtrl,
                hintText: CHANGE_CONFIRM_PASSWORD_HINT,
                password: true,
              ),
            ),
            hightSpacer32,
            changePasswordBtnWidget,
          ],
        ),
      ),
    );
  }

  /// change password btn click
  Future<void> _handleChangePassBtnAction() async {
    String newPass = _newPassCtrl.text.trim();
    String confirmPass = _confirmPassCtrl.text.trim();
    if (newPass.isEmpty || confirmPass.isEmpty) {
      Helper.showPopup(context, "Please enter password");
    } else {
      if (newPass.isNotEmpty &&
          confirmPass.isNotEmpty &&
          newPass == confirmPass) {
        CommanResponse response =
            await ChangeHubManagerPassword().changePassword(newPass);

        if (response.status!) {
          if (!mounted) return;
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const PasswordUpdated()));
        } else {
          if (!mounted) return;
          Helper.showPopup(context, response.message);
        }
      } else if (newPass != confirmPass) {
        Helper.showPopup(context, passwordMismatch);
      } else {
        Helper.showPopup(context, invalidPasswordMsg);
      }
    }
  }
}
