import 'package:flutter/material.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';

import '../constants/app_constants.dart';
import '../utils/ui_utils/text_styles/custom_text_style.dart';

// ignore: must_be_immutable
class ButtonWidget extends StatelessWidget {
  final GestureTapCallback onPressed;
  final String title;
  // final Color colorBG;
  final Color primaryColor;
  final double width;
  final double height;
  final double fontSize;
  bool isMarginRequired;
  late Color? colorTxt= AppColors.fontWhiteColor!;
  final double borderRadius;

     ButtonWidget  (
    {Key? key,
      required this.onPressed,
      this.isMarginRequired=true,
      //this.colorBG = MAIN_COLOR,
    required this.primaryColor,
     this.colorTxt,
      
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
        margin:isMarginRequired?const EdgeInsets.all(20): const EdgeInsets.all(0),
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: primaryColor,
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
