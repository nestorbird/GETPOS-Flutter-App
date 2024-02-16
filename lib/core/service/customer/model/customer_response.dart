class CustomersResponse {
  late Message message;

  CustomersResponse({required this.message});

  CustomersResponse.fromJson(Map<String, dynamic> json) {
    if (json.isNotEmpty) message = Message.fromJson(json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['message'] = message.toJson();

    return data;
  }
}

class Message {
  late int successKey;
  late String message;
  late List<CustomerList> customerList;

  Message(
      {required this.successKey,
      required this.message,
      required this.customerList});

  Message.fromJson(Map<String, dynamic> json) {
    successKey = json['success_key'];
    message = json['message'];
    if (json['customer'] != null) {
      customerList = [];
      json['customer'].forEach((v) {
        customerList.add(CustomerList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success_key'] = successKey;
    data['message'] = message;
    data['customer'] = customerList.map((v) => v.toJson()).toList();

    return data;
  }
}

class CustomerList {
  late String customerName;
  late String emailId;
  late String mobileNo;
  late String ward;
  late String wardName;
  late String name;
  late String creation;
  late String modified;
  late int disabled;
  String? image;

  CustomerList(
      {required this.customerName,
      required this.emailId,
      required this.mobileNo,
      required this.ward,
      required this.wardName,
      required this.name,
      required this.creation,
      required this.modified,
      required this.disabled,
      required this.image});

  CustomerList.fromJson(Map<String, dynamic> json) {
    customerName = json['customer_name'] ?? "Guest";
    emailId = json['email_id'] ?? "";
    mobileNo = json['mobile_no'] ?? "";
    ward = json['ward'] ?? "";
    wardName = json['ward_name'] ?? "";
    name = json['name'] ?? "";
    creation = json['creation'] ?? "";
    modified = json['modified'] ?? "";
    disabled = json['disabled'] ?? 0;
    image = json['image'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['customer_name'] = customerName;
    data['email_id'] = emailId;
    data['mobile_no'] = mobileNo;
    data['ward'] = ward;
    data['ward_name'] = wardName;
    data['name'] = name;
    data['creation'] = creation;
    data['modified'] = modified;
    data['disabled'] = disabled;
    data['image'] = image;
    return data;
  }
}
