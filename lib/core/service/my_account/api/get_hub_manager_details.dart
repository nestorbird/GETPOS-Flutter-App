import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:nb_posx/database/db_utils/db_instance_url.dart';

import '../../../../../constants/app_constants.dart';

import '../../../../../database/db_utils/db_constants.dart';
import '../../../../../database/db_utils/db_hub_manager.dart';
import '../../../../../database/db_utils/db_preferences.dart';
import '../../../../../database/models/hub_manager.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';
import '../../../../../utils/helpers/sync_helper.dart';
import '../model/hub_manager_details_response.dart';

class HubManagerDetails {
  Future<CommanResponse> getAccountDetails() async {
    //check if Internet is available or else
    if (await Helper.isNetworkAvailable()) {
      //Fetching hub manager id/email from DbPreferences
      String hubManagerId = await DBPreferences().getPreference(HubManagerId);

      //Creating map for request
      Map<String, String> data = {'hub_manager': hubManagerId};

      //Call to my account api
      var apiResponse = await APIUtils.postRequest(MY_ACCOUNT_PATH, data);
      log(jsonEncode(apiResponse));

      SyncHelper().checkCustomer(apiResponse["message"]["wards"]);

      //Parsing the api response
      HubManagerDetailsResponse hubManagerDetails =
          HubManagerDetailsResponse.fromJson(apiResponse);

      //If success response from api
      if (hubManagerDetails.message.message == "success") {
        var hubManagerData = hubManagerDetails.message;

        //Creating instance of DbHubManager
        DbHubManager dbHubManager = DbHubManager();

        //Deleting the hub manager details
        //  await dbHubManager.delete();
        var image = Uint8List.fromList([]);

        if (hubManagerData.image != null) {
          //Fetching image bytes (Uint8List) from image url
          image = await Helper.getImageBytesFromUrl(hubManagerData.image!);
        }
        //Creating hub manager object from api response
        HubManager hubManager = HubManager(
          id: hubManagerData.email,
          name: hubManagerData.fullName,
          phone: hubManagerData.mobileNo,
          emailId: hubManagerData.email,
          profileImage: image,
          cashBalance: hubManagerData.balance.toDouble(),
        );

        appCurrency = hubManagerData.appCurrency;

        //Saving the HubManager data into the database
        await dbHubManager.addManager(hubManager);
        await dbHubManager.getManager();

        //Saving the Sales Series
        await DBPreferences()
            .savePreference(SalesSeries, hubManagerData.series);

        //returning the CommanResponse as true
        return CommanResponse(
            status: true,
            message: SUCCESS,
            apiStatus: ApiStatus.REQUEST_SUCCESS);
      } else {
        //If failure response from api
        //returning the CommanResponse as false with failure message.
        return CommanResponse(
            status: false,
            message: SOMETHING_WRONG,
            apiStatus: ApiStatus.REQUEST_FAILURE);
      }
    } else {
      //If internet is not available
      //returning CommanResponse as false with message that no internet,
      //so loading data from local database (if available).
      return CommanResponse(
          status: false,
          message: NO_INTERNET_LOADING_DATA_FROM_LOCAL,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }
}
