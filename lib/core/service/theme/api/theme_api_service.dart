import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:nb_posx/configs/theme_dynamic_colors.dart';
import 'package:nb_posx/core/service/theme/api/model/theme_response.dart';

import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_constants.dart';
import '../../../../../database/db_utils/db_preferences.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';
import '../../../../database/db_utils/db_instance_url.dart';
// Import your ThemeResponse class here

class ThemeService {
  static Future<CommanResponse> fetchTheme(String url) async {
    // if (!_isValidUrl(url)) {
    //   return CommanResponse(status: false, message: INVALID_URL);
    // }

    // Check for the internet connection
    var isInternetAvailable = await Helper.isNetworkAvailable();

    //await DbInstanceUrl().saveUrl(url);
    String savedUrl = await DbInstanceUrl().getUrl();
    log('Saved URL :: $savedUrl');
    // instanceUrl = "$savedUrl";

    if (isInternetAvailable) {
      String apiUrl = url;
      // Call  theme settings API
      var apiResponse = await APIUtils.getRequest(apiUrl);

      // Parsing the theme settings response
      ThemeResponse themeResponse = ThemeResponse.fromJson(apiResponse);

      // API success
      // ignore: unnecessary_null_comparison
      if (themeResponse.message.data.primary.isNotEmpty) { // This condition is always true 
        var dbPreferences = DBPreferences();

        dbPreferences.savePreference(BASE_URL, instanceUrl);

        dbPreferences.savePreference(PRIMARY_COLOR,
            themeResponse.message.data.primary.replaceAll('#', '0xFF'));
        dbPreferences.savePreference(SECONDARY_COLOR,
            themeResponse.message.data.secondary.replaceAll('#', '0xFF'));
        dbPreferences.savePreference(ACCENT_COLOR,
            themeResponse.message.data.asset.replaceAll('#', '0xFF'));
        dbPreferences.savePreference(
            TEXT_AND_CANCELICON,
            themeResponse.message.data.textandCancelIcon
                .replaceAll('#', '0xFF'));
        dbPreferences.savePreference(SHADOW_BORDER,
            themeResponse.message.data.shadowBorder.replaceAll('#', '0xFF'));
        dbPreferences.savePreference(HINT_TEXT,
            themeResponse.message.data.hintText.replaceAll('#', '0xFF'));
        dbPreferences.savePreference(FONT_WHITE_COLOR,
            themeResponse.message.data.fontWhiteColor.replaceAll('#', '0xFF'));
        dbPreferences.savePreference(PARK_ORDER_BUTTON,
            themeResponse.message.data.parkOrderButton.replaceAll('#', '0xFF'));
        dbPreferences.savePreference(
            ACTIVE, themeResponse.message.data.active.replaceAll('#', '0xFF'));
        int primaryColor =
            int.parse(await dbPreferences.getPreference(PRIMARY_COLOR));

        int secondaryColor =
            int.parse(await dbPreferences.getPreference(SECONDARY_COLOR));

        int accentColor =
            int.parse(await dbPreferences.getPreference(ACCENT_COLOR));
        int textandCancelIcon =
            int.parse(await dbPreferences.getPreference(TEXT_AND_CANCELICON));
        int shadowBorder =
            int.parse(await dbPreferences.getPreference(SHADOW_BORDER));
        int hintText = int.parse(await dbPreferences.getPreference(HINT_TEXT));
        int fontWhiteColor =
            int.parse(await dbPreferences.getPreference(FONT_WHITE_COLOR));
        int parkOrderButton =
            int.parse(await dbPreferences.getPreference(PARK_ORDER_BUTTON));
        int active = int.parse(await dbPreferences.getPreference(ACTIVE));

        AppColors.primary = Color(primaryColor);
        AppColors.secondary = Color(secondaryColor);
        AppColors.asset = Color(accentColor);
        AppColors.textandCancelIcon = Color(textandCancelIcon);
        AppColors.shadowBorder = Color(shadowBorder);
        AppColors.hintText = Color(hintText);
        AppColors.fontWhiteColor = Color(fontWhiteColor);
        AppColors.parkOrderButton = Color(parkOrderButton);
        AppColors.active = Color(active);

        // Return the Success Theme Response
        return CommanResponse(
            status: true,
            message: SUCCESS,
            apiStatus: ApiStatus.REQUEST_SUCCESS,
            data: themeResponse.message.data);
      }

      // API Failure
      else {
        // Return the Failure Theme Response 0xFF000000
        return CommanResponse(
            status: false,
            message: themeResponse.message.data,
            apiStatus: ApiStatus.REQUEST_FAILURE);
      }
    }

    // If internet is not available
    else {
      return CommanResponse(
          status: false,
          message: NO_INTERNET,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }
}
