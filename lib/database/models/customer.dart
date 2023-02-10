import 'dart:convert';

import 'package:hive/hive.dart';

import '../db_utils/db_constants.dart';

part 'customer.g.dart';

@HiveType(typeId: CustomerBoxTypeId)
class Customer extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String phone;

  @HiveField(4)
  bool isSynced;

  @HiveField(5)
  DateTime modifiedDateTime;

  Customer(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      required this.isSynced,
      required this.modifiedDateTime});

  Customer copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    bool? isSynced,
    DateTime? modifiedDateTime,
  }) {
    return Customer(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        phone: phone ?? this.phone,
        isSynced: isSynced ?? this.isSynced,
        modifiedDateTime: modifiedDateTime ?? this.modifiedDateTime);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'isSynced': isSynced,
      'modifiedDateTime': modifiedDateTime
    };
  }

  factory Customer.fromMap(Map<String, dynamic> map) {
    return Customer(
        id: map['id'],
        name: map['name'],
        email: map['email'],
        phone: map['phone'],
        isSynced: map['isSynced'],
        modifiedDateTime: map['modifiedDateTime']);
  }

  String toJson() => json.encode(toMap());

  factory Customer.fromJson(String source) =>
      Customer.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Customer(id: $id, name: $name, email: $email, phone: $phone, isSynced: $isSynced, modifiedDateTime: $modifiedDateTime)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Customer &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.isSynced == isSynced &&
        other.modifiedDateTime == modifiedDateTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        isSynced.hashCode ^
        modifiedDateTime.hashCode;
  }
}
