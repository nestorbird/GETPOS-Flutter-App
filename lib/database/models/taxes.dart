import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../db_utils/db_constants.dart';
part 'taxes.g.dart';

@HiveType(typeId: TaxBoxTypeId)
class Taxes extends HiveObject {
  @HiveField(0)
  String taxId;

  @HiveField(1)
  String itemTaxTemplate;

  @HiveField(2)
  String taxType;

  @HiveField(3)
  double taxRate;

  @HiveField(4)
  double? taxAmount;

  Taxes({
    required this.taxId,
    required this.itemTaxTemplate,
    required this.taxType,
    required this.taxRate,
    required this.taxAmount,
  });

  Taxes copyWith({
    String? taxId,
    String? itemTaxTemplate,
    String? taxType,
    double? taxRate,
    double? taxAmount,
  }) {
    return Taxes(
      taxId: taxId ?? this.taxId,
      itemTaxTemplate: itemTaxTemplate ?? this.itemTaxTemplate,
      taxType: taxType ?? this.taxType,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tax_id': taxId,
      'item_tax_template': itemTaxTemplate,
      'tax_type': taxType,
      'tax_rate': taxRate,
      'tax_amount':taxAmount
    };
  }

  factory Taxes.fromMap(Map<String, dynamic> map) {
    return Taxes(
      taxId: map["tax_id"] ?? "",
      itemTaxTemplate: map['item_tax_template'] ?? '',
      taxType: map['tax_type'] ?? '',
     taxRate: (map['tax_rate'] ?? 0.0).toDouble(),
    taxAmount: (map['tax_amount'] ?? 0.0).toDouble(),
    );
  }
  String toJson() => json.encode(toMap());

  factory Taxes.fromJson(String source) => Taxes.fromMap(json.decode(source));
//
  @override
  String toString() =>
      'Taxes(tax_id: $taxId,item_tax_template: $itemTaxTemplate, tax_type: $taxType, tax_rate: $taxRate , tax_amount: $taxAmount)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Taxes &&
        other.taxId == taxId &&
        other.itemTaxTemplate == itemTaxTemplate &&
        other.taxType == taxType &&
        other.taxRate == taxRate &&
        other.taxAmount == taxAmount;
  }

  @override
  int get hashCode =>
      taxId.hashCode ^
      itemTaxTemplate.hashCode ^
      taxType.hashCode ^
      taxRate.hashCode ^
      taxAmount.hashCode;
}
