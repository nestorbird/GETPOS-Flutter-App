import 'api_status.dart';

///[CommanResponse] class to handle the basic response from api
class CommanResponse {
  bool? status;
  dynamic message;
  ApiStatus? apiStatus;
  dynamic data;
  //constructor
  CommanResponse(
      {this.status = true,
      this.message = 'success',
      this.apiStatus = ApiStatus.NONE,
      this.data});

  //create class object from json
  CommanResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    apiStatus = json['apiStatus'];
    data = json['data'];
  }

  // convert object to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['apiStatus'] = apiStatus;
    data['data'] = data;
    return data;
  }
}
