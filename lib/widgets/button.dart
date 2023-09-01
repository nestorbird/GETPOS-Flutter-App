import 'package:flutter/material.dart';
import 'package:nb_posx/utils/ui_utils/padding_margin.dart';

import '../configs/theme_config.dart';
import '../constants/app_constants.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';

class ButtonWidget extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String title;
  final Color colorBG;
  final double width;
  final double height;
  final double fontSize;
  final Color colorTxt;
  final double borderRadius;

  const ButtonWidget(
      {Key? key,
      required this.onPressed,
      this.colorBG = MAIN_COLOR,
      this.colorTxt = WHITE_COLOR,
      this.fontSize = 16,
      this.height = 50,
      required this.title,
      this.borderRadius = BORDER_CIRCULAR_RADIUS_07,
      this.width = 250})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: EdgeInsets.all(20),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: colorBG,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Text(
            title,
            // textAlign: TextAlign.center,
            style: getTextStyle(
                color: colorTxt,
                fontSize: fontSize,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
