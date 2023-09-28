import 'package:flutter/material.dart';
import 'package:nb_posx/configs/theme_config.dart';

import 'package:nb_posx/core/service/theme/api/model/theme_response.dart';

class AppColors {
  static Color? primary;
  //static Color  defaultPrimaryColor = Color(0xFFDC1E44);
  static Color? secondary;
  static Color? asset;
//to get the colors
  static Color getPrimary() => primary ?? const Color(0xFFDC1E44);
  //static Color getPrimary() => primary!;
  static Color getSecondary() => secondary ?? const Color(0xFF62B146);
  static Color getAsset() => asset ?? const Color(0xFF707070);
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

  // Method to update colors from ThemeResponse
  void updateColorsFromThemeResponse(ThemeResponse themeResponse) {
    primary = Color(
        int.parse(themeResponse.message.data.primary.replaceAll('#', '0xFF')));
    secondary = Color(int.parse(
        themeResponse.message.data.secondary.replaceAll('#', '0xFF')));
    asset = Color(
        int.parse(themeResponse.message.data.asset.replaceAll('#', '0xFF')));
  }
}
