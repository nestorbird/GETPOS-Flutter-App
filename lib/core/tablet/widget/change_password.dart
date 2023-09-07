import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import '../../../../../configs/theme_config.dart';
import '../../../../../constants/app_constants.dart';

import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/ui_utils/spacer_widget.dart';
import '../../../../../utils/ui_utils/textfield_border_decoration.dart';
import '../../../../../widgets/button.dart';
import '../../../../../widgets/text_field_widget.dart';
import '../../service/change_password/api/change_hubmanager_password.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
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
    return SizedBox(
        height: Get.height - 400,
        width: 400,
        child: Column(
          children: [
            hightSpacer50,
            hightSpacer50,
            SizedBox(
              height: 60,
              child: TextFieldWidget(
                boxDecoration: txtFieldBorderDecoration,
                txtCtrl: _newPassCtrl,
                hintText: CHANGE_NEW_PASSWORD_HINT,
                password: true,
              ),
            ),
            hightSpacer20,
            SizedBox(
              height: 60,
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
        ));
  }

  /// change pass btn widget
  Widget get changePasswordBtnWidget => Center(
        child: ButtonWidget(
          onPressed: () async {
            await _handleChangePassBtnAction();
          },
          title: CHANGE_PASSWORD_BTN_TXT,
          fontSize: LARGE_FONT_SIZE,
          colorBG: MAIN_COLOR,
          width: double.infinity,
          height: 60,
        ),
      );

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
          _confirmPassCtrl.clear();
          _newPassCtrl.clear();
          if (!mounted) return;
          Helper.showPopup(context, PASSWORD_UPDATED_MSG);
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
