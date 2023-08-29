import 'dart:convert';
import 'dart:developer';

import '../../../../../constants/app_constants.dart';
import '../../../../../database/db_utils/db_constants.dart';
import '../../../../../database/db_utils/db_preferences.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';

class ChangeHubManagerPassword {
  Future<CommanResponse> changePassword(String newPass) async {
    // ignore: valid_regexps
    var passWordRegex =
        RegExp(r"^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$");

    if (!passWordRegex.hasMatch(newPass)) {
      return CommanResponse(
          status: false,
          message: invalidPasswordMsg,
          apiStatus: ApiStatus.NONE);
    }

    if (await Helper.isNetworkAvailable()) {
      //Fetching hub manager id/email from DbPreferences
      String hubManagerId = await DBPreferences().getPreference(HubManagerId);

      //Creating map for request
      Map<String, String> data = {'usr': hubManagerId, "pwd": newPass};
      //Call to my account api
      var apiResponse = await APIUtils.postRequest(CHANGE_PASSWORD_PATH, data);
      log(jsonEncode(apiResponse));

      return CommanResponse(
          status: true, message: SUCCESS, apiStatus: ApiStatus.REQUEST_SUCCESS);
    } else {
      return CommanResponse(
          status: false,
          message: NO_INTERNET,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }
}
