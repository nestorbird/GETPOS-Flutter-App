import 'dart:developer';

import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_constants.dart';
import '../../../../../database/db_utils/db_preferences.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/helpers/sync_helper.dart';
import '../../../../database/db_utils/db_instance_url.dart';
import '../model/login_response.dart';

class LoginService {
  static Future<CommanResponse> login(
      String email, String password, String url) async {
    if (!_isValidUrl(url)) {
      return CommanResponse(status: false, message: INVALID_URL);
    }

    if (!isValidEmail(email)) {
      //Return the email validation failed Response
      return CommanResponse(status: false, message: INVALID_EMAIL);
    }

    if (!isValidPassword(password)) {
      //Return the password validation failed Response
      return CommanResponse(status: false, message: invalidPasswordMsg);
    }

    //Check for the internet connection
    var isInternetAvailable = await Helper.isNetworkAvailable();

    await DbInstanceUrl().saveUrl(url);
    String savedUrl = await DbInstanceUrl().getUrl();
    log('Saved URL :: $savedUrl');
    instanceUrl = url;

    if (isInternetAvailable) {
      //Login api url from api_constants
      String apiUrl = LOGIN_PATH;
      apiUrl += '?usr=$email&pwd=$password';
      //Call to login api
      var apiResponse = await APIUtils.getRequest(apiUrl);

      //Parsing the login response
      LoginResponse loginResponse = LoginResponse.fromJson(apiResponse);

      //API success
      if (loginResponse.message!.successKey == 1) {
        DBPreferences dbPreferences = DBPreferences();

        //Saving API Key and API secret in database.
        await dbPreferences.savePreference(
            ApiKey, loginResponse.message!.apiKey);
        await dbPreferences.savePreference(
            ApiSecret, loginResponse.message!.apiSecret);
        await dbPreferences.savePreference(
            HubManagerId, loginResponse.message!.email);

        await SyncHelper().loginFlow();

        //Return the Success Login Response
        return CommanResponse(
            status: true,
            message: SUCCESS,
            apiStatus: ApiStatus.REQUEST_SUCCESS);
      }

      //API Failure
      else {
        //Return the Failure Login Response
        return CommanResponse(
            status: loginResponse.message!.successKey == 1 ? true : false,
            message: loginResponse.message!.message,
            apiStatus: ApiStatus.REQUEST_FAILURE);
      }
    }

    //If internet is not available
    else {
      return CommanResponse(
          status: false,
          message: NO_INTERNET,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }

  ///Function to check whether email is in correct format or not.
  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }

  ///Function to check whether password is in correct format or not.
  static bool isValidPassword(String password) {
    String regex =
        (r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$");
    return RegExp(regex).hasMatch(regex);
  }

  ///Function to check whether the input URL is valid or not
  static bool _isValidUrl(String url) {
    // Regex to check valid URL
    String regex =
        "((http|https)://)(www.)?[a-zA-Z0-9@:%._\\+~#?&//=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%._\\+~#?&//=]*)";

    return RegExp(regex).hasMatch(url);
  }
}
