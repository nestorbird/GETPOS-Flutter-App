class CreateCustomerResponse {
  Message? message;

  CreateCustomerResponse({this.message});

  CreateCustomerResponse.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  int? successKey;
  String? message;
  CustomerRes? customer;

  Message({this.successKey, this.message, this.customer});

  Message.fromJson(Map<String, dynamic> json) {
    successKey = json['success_key'];
    message = json['message'];
    customer = json['customer'] != null
        ? CustomerRes.fromJson(json['customer'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success_key'] = successKey;
    data['message'] = message;
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class CustomerRes {
  String? name;
  String? customerName;
  String? mobileNo;
  String? emailId;

  CustomerRes({this.name, this.customerName, this.mobileNo, this.emailId});

  CustomerRes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    customerName = json['customer_name'];
    mobileNo = json['mobile_no'];
    emailId = json['email_id'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['customer_name'] = customerName;
    data['mobile_no'] = mobileNo;
    data['email_id'] = emailId;
    return data;
  }
}
