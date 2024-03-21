import 'dart:convert';

import 'package:nb_posx/database/models/payment_type.dart';
import 'package:nb_posx/database/models/pos_profile_cashier.dart';

class GetOpenDataResponse {
  final Message? message;

  GetOpenDataResponse({this.message});

  factory GetOpenDataResponse.fromJson(Map<String, dynamic> json) {
  return GetOpenDataResponse(
    message: json['message'] != null
        ? Message.fromJson(json['message'] as Map<String, dynamic>)
        : null,
  );
}
}

class Message {
  final List<Company>? companies;
  final List<PosProfileCashier>? posProfiles;
  final List<PaymentType>? paymentTypes;

  Message({this.companies, this.posProfiles, this.paymentTypes});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      companies: (json['companys'] as List<dynamic>?)
          ?.map((companyJson) => Company.fromJson(companyJson))
          .toList(),
       posProfiles: (json['pos_profiles_data'] as List<dynamic>?)
        ?.map((profileJson) => PosProfileCashier.fromJson(jsonEncode(profileJson)))
        .toList(),
      paymentTypes: (json['payments_method'] as List<dynamic>?)
          ?.map((paymentJson) => PaymentType.fromJson(jsonEncode(paymentJson)))
          .toList(),
    );
  }
}

class Company {
  final String? companyName;

  Company({this.companyName});

  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      companyName: json['name'] != null ? json['name'] as String : null,
    );
  }
}

