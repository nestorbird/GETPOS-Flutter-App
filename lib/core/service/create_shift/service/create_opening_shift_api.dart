import 'dart:convert';
import 'dart:developer';
import 'package:nb_posx/constants/app_constants.dart';
import 'package:nb_posx/core/service/create_shift/model/create_opening_voucher.dart';
import 'package:nb_posx/database/db_utils/db_balance_details.dart';
import 'package:nb_posx/database/db_utils/db_create_opening_shift.dart';
import 'package:nb_posx/database/db_utils/db_payment_types.dart';
import 'package:nb_posx/database/db_utils/db_pos_profile_cashier.dart';
import 'package:nb_posx/database/models/balance_details.dart';
import 'package:nb_posx/database/models/create_opening_shift.dart';
import 'package:nb_posx/database/models/payment_type.dart';
import 'package:nb_posx/database/models/pos_profile_cashier.dart';
import 'package:nb_posx/network/api_constants/api_paths.dart';
import 'package:nb_posx/network/api_helper/api_status.dart';
import 'package:nb_posx/network/api_helper/comman_response.dart';
import 'package:nb_posx/network/service/api_utils.dart';
import 'package:nb_posx/utils/helper.dart';


class CreateOpeningShiftService {
  Future<CommanResponse> createOpeningShiftDetails() async {
    if (await Helper.isNetworkAvailable()) {
      try {
        String apiUrl = CREATE_OPENING_SHIFT;
        var apiResponse = await APIUtils.getRequestWithHeaders(apiUrl);
        log(apiResponse.toString());

        CreateOpeningShiftResponse resp = CreateOpeningShiftResponse.fromJson(apiResponse);

        if (resp.message != null) {
          // Process POS profile cashiers
          if (resp.message!.createOpeningShift!= null) {
          CreateOpeningShiftDb cashiers =CreateOpeningShiftDb(
                      name: resp.message!.createOpeningShift!.name,
                      company: resp.message!.createOpeningShift!.company, 
                      owner: resp.message!.createOpeningShift!.owner,
                      creation: resp.message!.createOpeningShift!.creation,
                      modified: resp.message!.createOpeningShift!.modified,
                      idx: resp.message!.createOpeningShift!.idx,
                      modifiedBy: resp.message!.createOpeningShift!.modifiedBy,
                      docstatus: resp.message!.createOpeningShift!.docstatus,
                      //check for the current date
                      periodStartDate: resp.message!.createOpeningShift!.periodStartDate, 
                      postingDate: resp.message!.createOpeningShift!.postingDate,
                      status: resp.message!.createOpeningShift!.status,
                      setPostingDate: resp.message!.createOpeningShift!.setPostingDate,
                      doctype:  resp.message!.createOpeningShift!.doctype,
                      user:  resp.message!.createOpeningShift!.user,
                      //check for selected pos profile
                      posProfile:  resp.message!.createOpeningShift!.posProfile,
                      //check for balance details
                      balanceDetails:  resp.message!.createOpeningShift!.balanceDetails, 
                    );
               
              

            // Add POS profile cashiers to the database
            DbCreateShift().createShift(cashiers);
          }

          // Process payment types
          if (resp.message!.openingShiftbalance != null) {
            List<BalanceDetail> balanceDetails = resp.message!.createOpeningShift!.balanceDetails
                .map((data) => BalanceDetail(
                  name: data.name,
                  owner:  data.owner,
                  creation: data.creation,
                  modified: data.modified,
                  modifiedBy: data.modifiedBy,
                  parentField: data.parentField,
                  parent: data.parent,
                  parentType: data.parentType,
                  idx: data.idx,
                  docstatus: data.docstatus,
                  modeOfPayment: data.modeOfPayment,
                  amount: data.amount,
                  doctype: data.doctype 
                    ))
                .toList();

            // Add payment types to the database
            DbBalanceDetails().addBalanceDetails(balanceDetails);
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
