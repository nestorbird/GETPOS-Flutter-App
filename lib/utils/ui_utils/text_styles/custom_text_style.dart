import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';

import '../../../constants/app_constants.dart';

// Pass in the height and it return a vertical spacer
//
TextStyle getTextStyle({
  fontWeight = FontWeight.bold,
  fontSize = SMALL_FONT_SIZE,
  Color? color,
  // color = AppColors.getTextandCancelIcon
}) 
{

  final textColor = color ?? AppColors.textandCancelIcon ?? Colors.black;

 return GoogleFonts.montserrat(
      fontWeight: fontWeight, fontSize: fontSize, color: textColor);
}

TextStyle getBoldStyle() => GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
    );

TextStyle getItalicStyle(
        {fontSize,
        fontWeight = FontWeight.normal,
        color = const Color(0xFF707070)}) =>
    GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.italic,
        color: color);

TextStyle getNormalStyle() => GoogleFonts.montserrat();
