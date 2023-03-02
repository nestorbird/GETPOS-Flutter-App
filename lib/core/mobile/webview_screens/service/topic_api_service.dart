import '../../../../constants/app_constants.dart';
import '../../../../network/api_constants/api_paths.dart';
import '../../../../network/api_helper/api_status.dart';
import '../../../../network/api_helper/comman_response.dart';
import '../../../../network/service/api_utils.dart';
import '../../../../utils/helper.dart';
import '../enums/topic_types.dart';
import '../model/topic_response.dart';

///Class to handle the api calls for terms and conditions and privacy policy
class TopicDataService {
  ///Function to get privacy policy or terms & conditions data
  static Future<CommanResponse> getTopicData(
      TopicTypes topicTypes, String instanceUrl) async {
    //api url
    String apiUrl = "$instanceUrl$TOPICS_PATH";

    //Check for internet connectivity
    bool isInternetAvailable = await Helper.isNetworkAvailable();

    if (isInternetAvailable) {
      //Call to api
      var response = await APIUtils.getRequestWithCompleteUrl(apiUrl);

      //Parsing the api JSON response
      TopicResponse topicResponse = TopicResponse.fromJson(response);

      //Checking if message is success, or not empty from api
      if (topicResponse.message.successKey == 1 ||
          topicResponse.message.message == 'success') {
        //If requested type is privacy policy
        if (topicTypes == TopicTypes.PRIVACY_POLICY) {
          //Returning the CommanResponse as true with privacy policy data
          return CommanResponse(
              status: true,
              message: topicResponse.message.privacyPolicy,
              apiStatus: ApiStatus.REQUEST_SUCCESS);
        }

        //If requested type is terms and conditions
        else {
          //Returning the CommanResponse as true with terms & conditions data
          return CommanResponse(
              status: true,
              message: topicResponse.message.termsAndConditions,
              apiStatus: ApiStatus.REQUEST_SUCCESS);
        }
      } else {
        //Returning the CommanResponse as false, if no data found.
        return CommanResponse(
            status: true,
            message: NO_DATA_FOUND,
            apiStatus: ApiStatus.REQUEST_FAILURE);
      }
    } else {
      //Returning CommanResponse as false with message that no internet
      return CommanResponse(
          status: false,
          message: NO_INTERNET,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }
}
