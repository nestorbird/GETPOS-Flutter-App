import 'dart:convert';
import 'dart:developer';

import '../../../../../constants/app_constants.dart';
import '../model/create_customer_response.dart';
import '../../../../../database/db_utils/db_customer.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';

class CreateCustomer {
  Future<CommanResponse> createNew(
      String phone, String? name, String email) async {
    if (await Helper.isNetworkAvailable()) {
//Creating map for request
      Map<String, String> requestBody = {
        'customer_name': name??"Guest",
        'mobile_no': phone,
        'email_id': email
      };

      var apiResponse =
          await APIUtils.postRequest(CREATE_CUSTOMER_PATH, requestBody);
      log(jsonEncode(apiResponse));

      CreateCustomerResponse resp =
          CreateCustomerResponse.fromJson(apiResponse);

      if (apiResponse["message"]["message"] == "success") {
        if (resp.message!.message == "success") {
          // var image = Uint8List.fromList([]);
          Customer tempCustomer = Customer(
              // profileImage: image,
              // ward: Ward(id: "1", name: "1"),
              email: resp.message!.customer!.emailId!,
              id: resp.message!.customer!.name!,
              name: resp.message!.customer!.customerName!,
              phone: resp.message!.customer!.mobileNo!,
              isSynced: true,
              modifiedDateTime: DateTime.now());
          List<Customer> customers = [];
          customers.add(tempCustomer);
          await DbCustomer().addCustomers(customers);

          return CommanResponse(
              status: true,
              message: tempCustomer,
              apiStatus: ApiStatus.REQUEST_SUCCESS);
        }
      } else if (resp.message!.successKey == 0) {
        Customer existingCustomer = Customer(
            id: resp.message!.customer!.name!,
            name: resp.message!.customer!.customerName!,
            email: resp.message!.customer!.emailId!,
            phone: resp.message!.customer!.mobileNo!,
            isSynced: true,
            modifiedDateTime: DateTime.now());

        return CommanResponse(
            status: true,
            message: existingCustomer,
            apiStatus: ApiStatus.REQUEST_SUCCESS);
      }
    }

    return CommanResponse(
        status: false, message: NO_INTERNET, apiStatus: ApiStatus.NO_INTERNET);
  }
}
