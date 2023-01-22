import '../../../../../constants/app_constants.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';

class ForgotPasswordApi {
  Future<CommanResponse> sendResetPasswordMail(String email, String instanceUrl) async {
    if (await Helper.isNetworkAvailable()) {
      String apiUrl = FORGET_PASSWORD;
      apiUrl += '?user=$email';

      var apiResponse = await APIUtils.getRequest(apiUrl);
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
}
