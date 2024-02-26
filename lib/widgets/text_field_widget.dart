import 'package:flutter/material.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';

import '../constants/app_constants.dart';
import '../utils/ui_utils/padding_margin.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';
import '../utils/ui_utils/text_styles/edit_text_hint_style.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget({
    Key? key,
    required TextEditingController txtCtrl,
    required String hintText,
    this.txtColor = const Color(0xFF707070),
    required this.boxDecoration,
    this.verticalContentPadding = 10,
    this.password = false,
  
  }) : _txtCtrl = txtCtrl,
       _hintText = hintText,
       super(key: key);

  final TextEditingController _txtCtrl;
  final String _hintText;
  final bool password;
  final Color txtColor;
  final BoxDecoration boxDecoration;
  final double verticalContentPadding;

  @override
  _TextFieldWidgetState createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.boxDecoration,
      child: TextFormField(
        style: getTextStyle(
          color: widget.txtColor,
          fontSize: LARGE_MINUS_FONT_SIZE,
          fontWeight: FontWeight.w600,
        ),
        
        controller: widget._txtCtrl,
        cursorColor: AppColors.getAsset(),
        autocorrect: false,
        textInputAction: TextInputAction.next,
        obscureText: widget.password
        ? _obscureText
        : widget.password,
        decoration: widget.password
            ? InputDecoration(
                hintText: widget._hintText,
                hintStyle: const TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ?  Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                contentPadding: paddingXY(
                  x: 16,
                  y: widget.verticalContentPadding,
                ),
                border: InputBorder.none,
              )
            : InputDecoration(
                hintText: widget._hintText,
                hintStyle: getHintStyle(),
                focusColor: AppColors.getAsset(),
                contentPadding: paddingXY(
                  x: 16,
                  y: widget.verticalContentPadding,
                ),
                border: InputBorder.none,
              ),
      ),
    );
  }
}
