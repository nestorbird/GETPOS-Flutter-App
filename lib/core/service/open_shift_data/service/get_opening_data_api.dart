import 'dart:convert';
import 'dart:developer';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/database/db_utils/db_payment_types.dart';
import 'package:nb_posx/database/db_utils/db_pos_profile_cashier.dart';
import 'package:nb_posx/database/models/payment_type.dart';
import 'package:nb_posx/database/models/pos_profile_cashier.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import 'package:nb_posx/network/service/api_utils.dart';
import 'package:nb_posx/utils/helper.dart';
import '../model/get_open_data_response.dart';

class GetOpeningShiftService {
  Future<CommanResponse> getOpeningShiftDetails() async {
    if (await Helper.isNetworkAvailable()) {
      try {
        String apiUrl = GET_OPENING_DATA_PATH;
        var apiResponse = await APIUtils.getRequestWithHeaders(apiUrl);
        log(apiResponse.toString());

        GetOpenDataResponse resp = GetOpenDataResponse.fromJson(apiResponse);

        if (resp.message != null) {
          // Process POS profile cashiers
          if (resp.message!.posProfiles != null) {
            List<PosProfileCashier> cashiers = resp.message!.posProfiles!
                .map((data) => PosProfileCashier(
                      name: data.name,
                      company: data.company,
                    ))
                .toList();

            // Add POS profile cashiers to the database
            DbPosProfileCashier().addPosProfileCashiers(cashiers);
          }

          // Process payment types
          if (resp.message!.paymentTypes != null) {
            List<PaymentType> paymentTypes = resp.message!.paymentTypes!
                .map((data) => PaymentType(
                      parent: data.parent,
                      isDefault: data.isDefault,
                      allowInReturns: data.allowInReturns,
                      modeOfPayment: data.modeOfPayment,
                    ))
                .toList();

            // Add payment types to the database
            DbPaymentTypes().addPaymentMethod(paymentTypes);
          }

          return CommanResponse(
              status: true,
              message: SUCCESS,
              apiStatus: ApiStatus.REQUEST_SUCCESS);
        } else {
          return CommanResponse(
              status: false,
              message: "No message data in the response",
              apiStatus: ApiStatus.FAILED);
        }
      } catch (e) {
        print("Error occurred: $e");
        return CommanResponse(
            status: false,
            message: "An error occurred: $e",
            apiStatus: ApiStatus.FAILED);
      }
    } else {
      return CommanResponse(
          status: false,
          message: NO_INTERNET,
          apiStatus: ApiStatus.NO_INTERNET);
    }
  }
}
