import 'api_status.dart';

///[CommanResponse] class to handle the basic response from api
class CommanResponse {
  bool? status;
  dynamic message;
  ApiStatus? apiStatus;

  //constructor
  CommanResponse(
      {this.status = true,
      this.message = 'success',
      this.apiStatus = ApiStatus.NONE});

  //create class object from json
  CommanResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    apiStatus = json['apiStatus'];
  }

  // convert object to json
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['apiStatus'] = apiStatus;
    return data;
  }
}
