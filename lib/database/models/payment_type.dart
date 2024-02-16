import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';

part 'payment_type.g.dart';


@HiveType(typeId: PaymentTypeBoxId)
class PaymentType extends HiveObject {
  @HiveField(0)
  String parent;

  @HiveField(1)
  bool isDefault;

  @HiveField(2)
  bool  allowInReturns;

  @HiveField(3)
  String modeOfPayment;

  PaymentType({required this.parent,
  required this.isDefault,
  required this.allowInReturns,
  required this.modeOfPayment});
 


  PaymentType copyWith({
    String? parent,
    bool? isDefault,
    bool? allowInReturns,
    String? modeOfPayment,
    
  }) {
    return PaymentType(
        parent: parent ?? this.parent,
        isDefault: isDefault ?? this.isDefault,
        allowInReturns: allowInReturns ?? this.allowInReturns,
        modeOfPayment: modeOfPayment??this.modeOfPayment);
  }

  Map<String, dynamic> toMap() {
    return {
      'parent': parent,
      'default': isDefault,
      'allow_in_returns': allowInReturns,
      'mode_of_payment':modeOfPayment
    };
  }

  factory PaymentType.fromMap(Map<String, dynamic> map) {
    return PaymentType(
        parent: map['parent'],
        isDefault: map['default'],
        allowInReturns: map['allow_in_returns'],
        modeOfPayment:map['mode_of_payment']
        );
  }

  String toJson() => json.encode(toMap());

  factory PaymentType.fromJson(String source) =>
      PaymentType.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PaymentType(parent: $parent, default: $isDefault, allow_in_returns: $allowInReturns, mode_of_payment: $modeOfPayment)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaymentType &&
        other.parent == parent &&
        other.isDefault == isDefault &&
        other.allowInReturns == allowInReturns&&
        other.modeOfPayment==modeOfPayment;
  }

  @override
  int get hashCode {
    return parent.hashCode ^ isDefault.hashCode ^ allowInReturns.hashCode^ modeOfPayment.hashCode;
  }
}
