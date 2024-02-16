import 'dart:convert';

import 'package:hive/hive.dart';

import '../db_utils/db_constants.dart';

part 'pos_profile_cashier.g.dart';

@HiveType(typeId: PosProfileCashierBoxId)
class PosProfileCashier extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String company;

  PosProfileCashier({
    required this.name,
    required this.company,
  });

  PosProfileCashier copyWith({
    String? name,
    String? company,
  }) {
    return PosProfileCashier(
        name: name ?? this.name, company: company ?? this.company);
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'company': company};
  }

  factory PosProfileCashier.fromMap(Map<String, dynamic> map) {
    return PosProfileCashier(
      name: map['name'],
      company: map['company'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PosProfileCashier.fromJson(String source) =>
      PosProfileCashier.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PosProfileCashier(name: $name, company: $company)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PosProfileCashier &&
        other.name == name &&
        other.company == company;
  }

  @override
  int get hashCode {
    return name.hashCode ^ company.hashCode ;
  }
}
