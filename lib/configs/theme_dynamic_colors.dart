import 'dart:ui';

import 'package:nb_posx/core/service/theme/api/model/theme_response.dart';

class AppColors {
 static Color? primary;
 static Color? secondary;
 static Color? asset;
//to get the colors
 static Color getPrimary() => primary!;
 static Color getSecondary() => secondary!;
 static Color getAsset() => asset!;
// to set the colors 
  setPrimary(Color setter) {
    primary = setter;
  }

  setSecondary(Color setter) {
    secondary = setter;
  }

  setAsset(Color setter) {
    asset = setter;
  }
   // Method to update colors from ThemeResponse
  void updateColorsFromThemeResponse(ThemeResponse themeResponse) {
    primary = Color(int.parse(themeResponse.message.data.primary.replaceAll('#', '0xFF')));
    secondary = Color(int.parse(themeResponse.message.data.secondary.replaceAll('#', '0xFF')));
    asset = Color(int.parse(themeResponse.message.data.asset.replaceAll('#', '0xFF')));
  }
}
