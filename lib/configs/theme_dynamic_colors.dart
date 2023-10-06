import 'package:flutter/material.dart';
import 'package:nb_posx/configs/theme_config.dart';

import 'package:nb_posx/core/service/theme/api/model/theme_response.dart';

class AppColors {
  static Color? primary;
  static Color? secondary;
  static Color? asset;
  static Color? textandCancelIcon;
  static Color? shadowBorder;
  static Color? hintText;
  static Color? fontWhiteColor;
  static Color? parkOrderButton;
  static Color? active;
//to get the colors
  static Color getPrimary() => primary ?? const Color(0xFFDC1E44);
  static Color getSecondary() => secondary ?? const Color(0xFF62B146);
  static Color getAsset() => asset ?? const Color(0xFF707070);
  static Color getTextandCancelIcon() =>
      textandCancelIcon ?? const Color(0xFF000000);
  static Color getshadowBorder() => shadowBorder ?? const Color(0xFFC7C5C5);
  static Color gethintText() => hintText ?? const Color(0xFFF3F2F5);
  static Color getfontWhiteColor() => fontWhiteColor ?? const Color(0xFFFFFFFF);
  static Color getparkOrderButton() =>
      parkOrderButton ?? const Color(0xFF4A4A4A);
      static Color getactive() =>
      active ?? const Color(0xFFFEF9FA);

// to set the colors
  setPrimary(int setter) {
    primary = Color(setter);
  }

  setSecondary(int setter) {
    secondary = Color(setter);
  }

  setAsset(int setter) {
    asset = Color(setter);
  }

  setTextandCancelIcon(int setter) {
    textandCancelIcon = Color(setter);
  }

  setshadowBorder(int setter) {
    shadowBorder = Color(setter);
  }

  sethintText(int setter) {
    hintText = Color(setter);
  }

  setfontWhiteColor(int setter) {
    fontWhiteColor = Color(setter);
  }

  setparkOrderButton(int setter) {
    parkOrderButton = Color(setter);
  }
setactive(int setter) {
    active = Color(setter);
  }
  // Method to update colors from ThemeResponse
  void updateColorsFromThemeResponse(ThemeResponse themeResponse) {
    primary = Color(
        int.parse(themeResponse.message.data.primary.replaceAll('#', '0xFF')));
    secondary = Color(int.parse(
        themeResponse.message.data.secondary.replaceAll('#', '0xFF')));
    asset = Color(
        int.parse(themeResponse.message.data.asset.replaceAll('#', '0xFF')));
    textandCancelIcon = Color(int.parse(
        themeResponse.message.data.textandCancelIcon.replaceAll('#', '0xFF')));
    shadowBorder = Color(int.parse(
        themeResponse.message.data.shadowBorder.replaceAll('#', '0xFF')));
    hintText = Color(
        int.parse(themeResponse.message.data.hintText.replaceAll('#', '0xFF')));
    fontWhiteColor = Color(int.parse(
        themeResponse.message.data.fontWhiteColor.replaceAll('#', '0xFF')));
    parkOrderButton = Color(int.parse(
        themeResponse.message.data.parkOrderButton.replaceAll('#', '0xFF')));
        active = Color(int.parse(
        themeResponse.message.data.active.replaceAll('#', '0xFF')));
  }
}
