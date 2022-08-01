import 'package:flutter/material.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';
import '../utils/ui_utils/text_styles/edit_text_hint_style.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget(
      {Key? key,
      required TextEditingController txtCtrl,
      required String hintText,
      this.txtColor = DARK_GREY_COLOR,
      required this.boxDecoration,
      this.verticalContentPadding = 10,
      this.password = false})
      : _txtCtrl = txtCtrl,
        _hintText = hintText,
        super(key: key);

  final TextEditingController _txtCtrl;
  final String _hintText;
  final bool password;
  final Color txtColor;
  final BoxDecoration boxDecoration;
  final double verticalContentPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: boxDecoration,
      child: TextFormField(
        style: getTextStyle(
            color: txtColor,
            fontSize: LARGE_MINUS_FONT_SIZE,
            fontWeight: FontWeight.w600),
        controller: _txtCtrl,
        cursorColor: DARK_GREY_COLOR,
        autocorrect: false,
        textInputAction: TextInputAction.next,
        // textAlignVertical: TextAlignVertical.bottom,
        obscureText: password,
        decoration: InputDecoration(
          hintText: _hintText,
          hintStyle: getHintStyle(),
          focusColor: DARK_GREY_COLOR,
          contentPadding: paddingXY(x: 16, y: verticalContentPadding),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
