class LoginResponse {
  LoginResponse({
    required this.message,
    required this.homePage,
    required this.fullName,
  });
  Message? message;
  String? homePage;
  String? fullName;

  LoginResponse.fromJson(Map<String, dynamic> json) {
    message = Message.fromJson(json['message']);
    homePage = json['home_page'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message!.toJson();
    data['home_page'] = homePage;
    data['full_name'] = fullName;
    return data;
  }
}

class Message {
  Message({
    required this.successKey,
    required this.message,
    required this.sid,
    required this.apiKey,
    required this.apiSecret,
    required this.username,
    required this.email,
  });
  int? successKey;
  String? message;
  String? sid;
  String? apiKey;
  String? apiSecret;
  String? username;
  String? email;

  Message.fromJson(Map<String, dynamic> json) {
    successKey = json['success_key'];
    message = json['message'];
    sid = json['sid'];
    apiKey = json['api_key'];
    apiSecret = json['api_secret'];
    username = json['username'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success_key'] = successKey;
    data['message'] = message;
    data['sid'] = sid;
    data['api_key'] = apiKey;
    data['api_secret'] = apiSecret;
    data['username'] = username;
    data['email'] = email;
    return data;
  }
}
