import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/payment_type.dart';
import 'package:nb_posx/database/models/pos_profile_cashier.dart';

part 'shift_management.g.dart';

@HiveType(typeId: ShiftManagementBoxId)
class ShiftManagement extends HiveObject {

  @HiveField(0)
  List<PosProfileCashier> posProfilesData;

  @HiveField(1)
  List<PaymentType> paymentsMethod;

  ShiftManagement(
      {required this.posProfilesData, required this.paymentsMethod});

  ShiftManagement copyWith({
    List<PosProfileCashier>? posProfilesData,
    List<PaymentType>? paymentsMethod,
  }) {
    return ShiftManagement(
        posProfilesData: posProfilesData ?? this.posProfilesData,
        paymentsMethod: paymentsMethod ?? this.paymentsMethod);
  }

  Map<String, dynamic> toMap() {
    return {
      "pos_profiles_data": posProfilesData.map((x) => x.toMap()).toList(),
      "payments_method": paymentsMethod.map((x) => x.toMap()).toList()
    };
  }

  factory ShiftManagement.fromMap(Map<String, dynamic> map) {
    return ShiftManagement(
        posProfilesData: List<PosProfileCashier>.from(
            map['pos_profiles_data']?.map((x) => PosProfileCashier.fromMap(x))),
        paymentsMethod: List<PaymentType>.from(
            map['payments_method']?.map((x) => PaymentType.fromMap(x))));
  }

  String toJson() => json.encode(toMap());

  factory ShiftManagement.fromJson(String source) =>
      ShiftManagement.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ShiftManagement(pos_profiles_data: $posProfilesData, payments_method: $paymentsMethod)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ShiftManagement &&
        other.paymentsMethod == paymentsMethod &&
        other.posProfilesData == posProfilesData;
  }

  @override
  int get hashCode {
    return paymentsMethod.hashCode ^ posProfilesData.hashCode;
  }
}
