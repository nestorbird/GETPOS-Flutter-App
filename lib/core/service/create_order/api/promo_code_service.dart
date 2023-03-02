import 'package:nb_posx/core/service/create_order/model/promo_codes_response.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/service/api_utils.dart';

import '../../../../constants/app_constants.dart';
import '../../../../network/api_helper/api_status.dart';
import '../../../../network/api_helper/comman_response.dart';
import '../../../../utils/helper.dart';

class PromoCodeservice {
  Future<CommanResponse> getPromoCodes() async {
    if (await Helper.isNetworkAvailable()) {
      String apiUrl = GET_ALL_PROMO_CODES_PATH;

      var apiResponse = await APIUtils.getRequest(apiUrl);
      Helper.printJSONData(apiResponse);
      PromoCodesResponse promoCodesResponse =
          PromoCodesResponse.fromJson(apiResponse);

      if (promoCodesResponse.message!.successKey == 1) {
        return CommanResponse(
          status: true,
          message: promoCodesResponse,
          apiStatus: ApiStatus.REQUEST_SUCCESS
        );
      } else {
        return CommanResponse(
          status: false,
          message: NO_DATA_FOUND,
          apiStatus: ApiStatus.NO_DATA_AVAILABLE,
        );
      }
    } else {
      return CommanResponse(
          status: false,
          message: NO_INTERNET_CREATE_ORDER_SYNC_QUEUED,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }
}
