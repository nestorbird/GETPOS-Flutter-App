class HubManagerDetailsResponse {
  late Message message;

  HubManagerDetailsResponse({required this.message});

  HubManagerDetailsResponse.fromJson(Map<String, dynamic> json) {
    message = Message.fromJson(json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['message'] = message.toJson();

    return data;
  }
}

class Message {
  late final int successKey;
  late final String message;
  late final String name;
  late final String fullName;
  late final String email;
  late final String mobileNo;
  late final String hubManager;
  late final String series;
  String? image;
  late final double balance;
  late final String appCurrency;
  late final String lastTransactionDate;
  late final List<Wards> wards;

  Message(
      {required this.successKey,
      required this.message,
      required this.name,
      required this.fullName,
      required this.email,
      required this.mobileNo,
      required this.hubManager,
      required this.series,
      required this.image,
      required this.balance,
      required this.appCurrency,
      required this.lastTransactionDate,
      required this.wards});

  Message.fromJson(Map<String, dynamic> json) {
    successKey = json['success_key'];
    message = json['message'];
    name = json['name'];
    fullName = json['full_name'];
    email = json['email'];
    mobileNo = json['mobile_no'] ?? "";
    hubManager = json['hub_manager'] ?? "";
    series = json['series'] ?? "T-.YYYY.-.MM.-.####";
    image = json['image'];
    balance = json['balance'] ?? 0;
    appCurrency = json['app_currency'] ?? "\$";
    lastTransactionDate = json['last_transaction_date'] ?? '';
    if (json['wards'] != null) {
      wards = [];
      json['wards'].forEach((v) {
        wards.add(Wards.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success_key'] = successKey;
    data['message'] = message;
    data['name'] = name;
    data['full_name'] = fullName;
    data['email'] = email;
    data['mobile_no'] = mobileNo;
    data['hub_manager'] = hubManager;
    data['series'] = series;
    data['image'] = image;
    data['balance'] = balance;
    data['app_currency'] = appCurrency;
    data['last_transaction_date'] = lastTransactionDate;

    data['wards'] = wards.map((v) => v.toJson()).toList();

    return data;
  }
}

class Wards {
  late final String ward;
  late final int isAssigned;

  Wards({required this.ward, required this.isAssigned});

  Wards.fromJson(Map<String, dynamic> json) {
    ward = json['ward'];
    isAssigned = json['is_assigned'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ward'] = ward;
    data['is_assigned'] = isAssigned;
    return data;
  }
}
