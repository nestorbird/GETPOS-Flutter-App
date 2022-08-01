import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';

import '../db_utils/db_constants.dart';

part 'hub_manager.g.dart';

@HiveType(typeId: HubManagerBoxTypeId)
class HubManager extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String emailId;

  @HiveField(3)
  String phone;

  @HiveField(4)
  double cashBalance;

  @HiveField(5)
  Uint8List profileImage;

  HubManager(
      {required this.id,
      required this.name,
      required this.emailId,
      required this.phone,
      this.cashBalance = 0,
      required this.profileImage});

  HubManager copyWith({
    String? id,
    String? name,
    String? emailId,
    String? phone,
    double? cashBalance,
    Uint8List? profileImage,
  }) {
    return HubManager(
      id: id ?? this.id,
      name: name ?? this.name,
      emailId: emailId ?? this.emailId,
      phone: phone ?? this.phone,
      cashBalance: cashBalance ?? this.cashBalance,
      profileImage: profileImage ?? this.profileImage,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'emailId': emailId,
      'phone': phone,
      'cashBalance': cashBalance,
      'profileImage': profileImage,
    };
  }

  factory HubManager.fromMap(Map<String, dynamic> map) {
    return HubManager(
      id: map['id'],
      name: map['name'],
      emailId: map['emailId'],
      phone: map['phone'],
      cashBalance: map['cashBalance'],
      profileImage: map['profileImage'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HubManager.fromJson(String source) =>
      HubManager.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HubManager(id: $id, name: $name, emailId: $emailId, phone: $phone,  cashBalance: $cashBalance)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HubManager &&
        other.id == id &&
        other.name == name &&
        other.emailId == emailId &&
        other.phone == phone &&
        other.profileImage == profileImage &&
        other.cashBalance == cashBalance;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        emailId.hashCode ^
        phone.hashCode ^
        profileImage.hashCode ^
        cashBalance.hashCode;
  }
}
