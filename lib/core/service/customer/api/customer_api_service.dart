import 'dart:convert';
import 'dart:developer';

import 'package:intl/intl.dart';

import '../../../../../constants/app_constants.dart';

import '../../../../../database/db_utils/db_constants.dart';
import '../../../../../database/db_utils/db_customer.dart';
import '../../../../../database/db_utils/db_preferences.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';
import '../model/customer_response.dart';

///[CustomerService] class for providing api calls functionality related to customer data.
class CustomerService {
  ///Function to fetch the customer data from api & handle the responses.
  Future<CommanResponse> getCustomers({String searchTxt = ""}) async {
    // Check If internet available or not
    if (await Helper.isNetworkAvailable()) {
      //Fetching hub manager id/email from DbPreferences
      String hubManagerId = await DBPreferences().getPreference(HubManagerId);

      //Creating map for request
      Map<String, String> requestBody = {'hub_manager': hubManagerId};

      String lastSyncDateTime =
          await DBPreferences().getPreference(CUSTOMER_LAST_SYNC_DATETIME);
      if (lastSyncDateTime.isNotEmpty) {
        requestBody.putIfAbsent('last_sync', () => lastSyncDateTime);
      }

      String formattedDate = lastSyncDateTime.isNotEmpty
          ? DateFormat("yyyy-MM-dd").format(DateTime.parse(lastSyncDateTime))
          : '';

      String customerUrl =
          '$NEW_GET_ALL_CUSTOMERS_PATH?search=$searchTxt&from_date=$lastSyncDateTime';

      //Call to customer api
      var apiResponse = await APIUtils.getRequestWithHeaders(customerUrl);
      log(jsonEncode(apiResponse));

      //If success response from api
      if (apiResponse["message"]["message"] == "success") {
        //Parsing the JSON response
        CustomersResponse customersResponse =
            CustomersResponse.fromJson(apiResponse);

        //If customers list is not empty from api
        if (customersResponse.message.message == "success") {
          //Creating customer list
          List<Customer> customers = [];

          //Populating the customer database with new data from api
          await Future.forEach(customersResponse.message.customerList,
              (customerData) async {
            var customer = customerData as CustomerList;
            // var image = Uint8List.fromList([]);

            // if (customer.image != null) {
            //   //Fetching image bytes (Uint8List) from image url
            //   image = await Helper.getImageBytesFromUrl(customer.image!);
            // }

            //Creating customer object
            Customer tempCustomer = Customer(
                id: customer.name,
                name: customer.customerName,
                email: customer.emailId,
                phone: customer.mobileNo,
                isSynced: true,
                modifiedDateTime: DateTime.now());
            if (customer.disabled == 1) {
              await DbCustomer().deleteCustomer(tempCustomer.id);
            } else {
              var existingCustomer =
                  await DbCustomer().getCustomer(tempCustomer.phone);
              if (existingCustomer.isEmpty) {
                customers.add(tempCustomer);
              } else {
                Customer modifiedCustomer = existingCustomer.first;
                modifiedCustomer.id = tempCustomer.id;
                modifiedCustomer.email = tempCustomer.email;
                modifiedCustomer.name = tempCustomer.name;
                modifiedCustomer.modifiedDateTime =
                    tempCustomer.modifiedDateTime;
                modifiedCustomer.isSynced = true;
                modifiedCustomer.save();
                //await DbCustomer().updateCustomer(modifiedCustomer);
              }
            }
            //Adding customer into customer list
          });

          //Adding new customers into the database
          await DbCustomer().addCustomers(customers);

          await DBPreferences().savePreference(
              CUSTOMER_LAST_SYNC_DATETIME, Helper.getCurrentDateTime());

          //returning the CommanResponse as true
          return CommanResponse(
              status: true,
              message: SUCCESS,
              apiStatus: ApiStatus.REQUEST_SUCCESS);
        } else {
          //If failure response from api
          //returning the CommanResponse as false with message from api.
          return CommanResponse(
              status: false,
              message: SOMTHING_WRONG_LOADING_LOCAL,
              apiStatus: ApiStatus.REQUEST_FAILURE);
        }
      } else {
        await DBPreferences().savePreference(
            CUSTOMER_LAST_SYNC_DATETIME, Helper.getCurrentDateTime());
        //If customer list is empty in api
        //Returning the CommanResponse as true with message No data available.
        return CommanResponse(
            status: true,
            message: NO_DATA_FOUND,
            apiStatus: ApiStatus.NO_DATA_AVAILABLE);
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
