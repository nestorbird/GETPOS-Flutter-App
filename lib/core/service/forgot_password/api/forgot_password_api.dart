import '../../../../../constants/app_constants.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';

class ForgotPasswordApi {
  Future<CommanResponse> sendResetPasswordMail(
      String email, String instanceUrl) async {
 /* if (!_isvalidUrl(instanceUrl)) {
      return CommanResponse(status: false, message: INVALID_URL);
    }*/

    if (!isValidEmail(email)) {
      //Return the email validation failed Response
      return CommanResponse(status: false, message: INVALID_EMAIL);
    }

    if (await Helper.isNetworkAvailable()) {
      String apiUrl = instanceUrl + FORGET_PASSWORD;
      apiUrl += '?user=$email';

      var apiResponse = await APIUtils.getRequestWithCompleteUrl(apiUrl);
      if (apiResponse["message"]["success_key"] == 1) {
        return CommanResponse(
            status: true,
            message: SUCCESS,
            apiStatus: ApiStatus.REQUEST_SUCCESS);
      } else if (apiResponse["message"]["success_key"] == 0) {
        return CommanResponse(
            status: false,
            message: apiResponse["message"]["message"],
            apiStatus: ApiStatus.REQUEST_FAILURE);
      } else {
        return CommanResponse(
            status: false,
            message: SOMETHING_WENT_WRONG,
            apiStatus: ApiStatus.REQUEST_FAILURE);
      }
    } else {
      return CommanResponse(
          status: false,
          message: NO_INTERNET,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }

  ///Function to check whether the input URL is valid or not
  static bool _isvalidUrl(String url) {
    // Regex to check valid URL
    String regex =
        "((http|https)://)(www.)?[a-zA-Z0-9@:%._\\+~#?&//=]{2,256}\\.[a-z]{2,6}\\b([-a-zA-Z0-9@:%._\\+~#?&//=]*)";

    return RegExp(regex).hasMatch(url);
  }

  ///Function to check whether email is in correct format or not.
  static bool isValidEmail(String email) {
    return RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
  }
}
