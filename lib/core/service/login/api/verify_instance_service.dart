import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import 'package:nb_posx/network/service/api_utils.dart';
import 'package:nb_posx/utils%20copy/helper.dart';

class VerificationUrl {
  static Future<CommanResponse> checkAppStatus() async {
    try {
      var isInternetAvailable = await Helper.isNetworkAvailable();
      if (isInternetAvailable) {
        String apiPath = Verify_URL;
        var apiResponse = await APIUtils.getRequestVerify(apiPath);
        if (apiResponse != null) {
          bool status = apiResponse["message"];
          return CommanResponse(
              status: true,
              message: status,
              apiStatus: ApiStatus.REQUEST_SUCCESS);
        } else {
          return CommanResponse(
              status: false, message: '', apiStatus: ApiStatus.REQUEST_FAILURE);
        }
      } else {
        return CommanResponse(
            status: false,
            message: 'No internet connection',
            apiStatus: ApiStatus.NO_INTERNET);
      }
    } catch (e) {
      return CommanResponse(
          status: false,
          message: e.toString(),
          apiStatus: ApiStatus.REQUEST_FAILURE);
    }
  }
}
