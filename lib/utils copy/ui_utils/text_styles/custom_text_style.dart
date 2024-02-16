import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../configs/theme_config.dart';
import '../../../constants/app_constants.dart';

// Pass in the height and it return a vertical spacer
//
TextStyle getTextStyle(
        {fontWeight = FontWeight.bold,
        fontSize = SMALL_FONT_SIZE,
        color = BLACK_COLOR}) =>
    GoogleFonts.montserrat(
        fontWeight: fontWeight, fontSize: fontSize, color: color);

TextStyle getBoldStyle() => GoogleFonts.montserrat(
      fontWeight: FontWeight.bold,
    );

TextStyle getItalicStyle(
        {fontSize, fontWeight = FontWeight.normal, color = DARK_GREY_COLOR}) =>
    GoogleFonts.montserrat(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: FontStyle.italic,
        color: color);

TextStyle getNormalStyle() => GoogleFonts.montserrat();
