import '../../../../../constants/app_constants.dart';
import '../model/customer_response.dart';
import '../../../../../database/models/customer.dart';
import '../../../../../network/api_constants/api_paths.dart';
import '../../../../../network/api_helper/api_status.dart';
import '../../../../../network/api_helper/comman_response.dart';
import '../../../../../network/service/api_utils.dart';
import '../../../../../utils/helper.dart';

class GetCustomer {
  //?mobile_no=
  Future<CommanResponse> getByMobileno(String mobileNo) async {
    // Check If internet available or not
    if (await Helper.isNetworkAvailable()) {
      //Creating GET api url
      String apiUrl = CUSTOMER_PATH;
      apiUrl += '?mobile_no=$mobileNo';
      //Call to Sales History api
      var apiResponse = await APIUtils.getRequestWithHeaders(apiUrl);
      if (apiResponse["message"]["message"] == "Mobile Number Does Not Exist") {
        return CommanResponse(
            status: false,
            message: NO_DATA_FOUND,
            apiStatus: ApiStatus.NO_DATA_AVAILABLE);
      }

      NewCustomerResponse resp = NewCustomerResponse.fromJson(apiResponse);
      // var image = Uint8List.fromList([]);
      Customer tempCustomer = Customer(
          // profileImage: image,
          // ward: Ward(id: "1", name: "1"),
          email: resp.message!.customer!.first.emailId!,
          id: resp.message!.customer!.first.name!,
          name: resp.message!.customer!.first.customerName!,
          phone: resp.message!.customer!.first.mobileNo!,
          isSynced: true,
          modifiedDateTime: DateTime.now());

      List<Customer> custlist = [];
      custlist.add(tempCustomer);
      //TODO:: Siddhant - Uncomment this if found any issue with the customer search
      //await DbCustomer().addCustomers(custlist);

      //returning the CommanResponse as true
      return CommanResponse(
          status: true, message: SUCCESS, apiStatus: ApiStatus.REQUEST_SUCCESS);
    }

    return CommanResponse(
        status: false,
        message: NO_INTERNET_LOADING_DATA_FROM_LOCAL,
        apiStatus: ApiStatus.NO_INTERNET);
  }
}
