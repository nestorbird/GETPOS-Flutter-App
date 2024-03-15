import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/payment_type.dart';
import 'package:nb_posx/database/models/pos_profile_cashier.dart';
import 'package:nb_posx/database/models/payment_info.dart'; // Import PaymentInfo model

part 'shift_management.g.dart';

@HiveType(typeId: ShiftManagementBoxId)
class ShiftManagement extends HiveObject {
  @HiveField(0)
  String posProfile;

  @HiveField(1)
  List<PaymentType> paymentsMethod;

  @HiveField(2) 
  List<PaymentInfo> paymentInfoList; 

  ShiftManagement({
    required this.posProfile,
    required this.paymentsMethod,
    required this.paymentInfoList, 
  });

  ShiftManagement copyWith({
    String? posProfile,
    List<PaymentType>? paymentsMethod,
    List<PaymentInfo>? paymentInfoList, 
  }) {
    return ShiftManagement(
      posProfile: posProfile ?? this.posProfile,
      paymentsMethod: paymentsMethod ?? this.paymentsMethod,
      paymentInfoList: paymentInfoList ?? this.paymentInfoList, 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'posProfile': posProfile,
      'paymentsMethod': paymentsMethod.map((payment) => payment.toMap()).toList(),
      'paymentInfoList': paymentInfoList.map((info) => info.toMap()).toList(),
    };
  }

  factory ShiftManagement.fromMap(Map<String, dynamic> map) {
    return ShiftManagement(
      posProfile: map['posProfile'],
      paymentsMethod: List<PaymentType>.from(map['paymentsMethod']?.map((x) => PaymentType.fromMap(x)) ?? []),
      paymentInfoList: List<PaymentInfo>.from(map['paymentInfoList']?.map((x) => PaymentInfo.fromMap(x)) ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ShiftManagement.fromJson(String source) =>
      ShiftManagement.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShiftManagement(pos_profiles_data: $posProfile, payments_method: $paymentsMethod, payment_info_list: $paymentInfoList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShiftManagement &&
        other.paymentsMethod == paymentsMethod &&
        other.posProfile == posProfile &&
        other.paymentInfoList == paymentInfoList; 
  }

  @override
  int get hashCode {
    return paymentsMethod.hashCode ^ posProfile.hashCode ^ paymentInfoList.hashCode; 
  }
}
