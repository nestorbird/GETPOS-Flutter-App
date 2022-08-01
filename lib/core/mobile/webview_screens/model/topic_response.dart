class TopicResponse {
  TopicResponse({
    required this.message,
  });
  late final Message message;

  TopicResponse.fromJson(Map<String, dynamic> json) {
    message = Message.fromJson(json['message']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message.toJson();
    return data;
  }
}

class Message {
  Message({
    required this.successKey,
    required this.message,
    required this.privacyPolicy,
    required this.termsAndConditions,
  });
  late final int successKey;
  late final String message;
  late final String privacyPolicy;
  late final String termsAndConditions;

  Message.fromJson(Map<String, dynamic> json) {
    successKey = json['success_key'];
    message = json['message'];
    privacyPolicy = json['Privacy_Policy'];
    termsAndConditions = json['Terms_and_Conditions'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success_key'] = successKey;
    data['message'] = message;
    data['Privacy_Policy'] = privacyPolicy;
    data['Terms_and_Conditions'] = termsAndConditions;
    return data;
  }
}
