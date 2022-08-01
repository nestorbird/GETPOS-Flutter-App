class NewCustomerResponse {
  Message? message;

  NewCustomerResponse({this.message});

  NewCustomerResponse.fromJson(Map<String, dynamic> json) {
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
  List<CustomerRes>? customer;

  Message({this.successKey, this.message, this.customer});

  Message.fromJson(Map<String, dynamic> json) {
    successKey = json['success_key'];
    message = json['message'];
    if (json['customer'] != null) {
      customer = <CustomerRes>[];
      json['customer'].forEach((v) {
        customer!.add(CustomerRes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success_key'] = successKey;
    data['message'] = message;
    if (customer != null) {
      data['customer'] = customer!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CustomerRes {
  String? name;
  String? customerName;
  String? customerPrimaryContact;
  String? mobileNo;
  String? emailId;
  dynamic primaryAddress;
  dynamic hubManager;

  CustomerRes(
      {this.name,
      this.customerName,
      this.customerPrimaryContact,
      this.mobileNo,
      this.emailId,
      this.primaryAddress,
      this.hubManager});

  CustomerRes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    customerName = json['customer_name'];
    customerPrimaryContact = json['customer_primary_contact'];
    mobileNo = json['mobile_no'];
    emailId = json['email_id'];
    primaryAddress = json['primary_address'];
    hubManager = json['hub_manager'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['customer_name'] = customerName;
    data['customer_primary_contact'] = customerPrimaryContact;
    data['mobile_no'] = mobileNo;
    data['email_id'] = emailId;
    data['primary_address'] = primaryAddress;
    data['hub_manager'] = hubManager;
    return data;
  }
}
