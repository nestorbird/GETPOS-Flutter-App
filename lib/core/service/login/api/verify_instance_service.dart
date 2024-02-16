import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import 'package:nb_posx/network/service/api_utils.dart';
import 'package:nb_posx/utils%20copy/helper.dart';
import 'package:http/http.dart' as http;

class VerificationUrl {
  static Future<CommanResponse> checkAppStatus() async {
    try {
      var isInternetAvailable = await Helper.isNetworkAvailable();

      if (isInternetAvailable) {
        String apiPath = Verify_URL;
        var apiResponse = await APIUtils.getRequestVerify(apiPath);
        //var apiResponse = await ApiFunctions().getRequest(apiPath);
        var uri = Uri.parse(apiPath);
        var response =
            await http.get((uri)).timeout(const Duration(seconds: 30));
        if (response.statusCode == 200) {
          //bool status = apiResponse[“message”];
          return CommanResponse(
              status: true,
              message: true,
              apiStatus: ApiStatus.REQUEST_SUCCESS);
        } else {
          return CommanResponse(
              status: false,
              message: false,
              apiStatus: ApiStatus.REQUEST_FAILURE);
        }
      } else {
        return CommanResponse(
            status: false,
            message: "No internet connection",
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
