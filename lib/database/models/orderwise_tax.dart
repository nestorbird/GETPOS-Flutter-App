import 'dart:convert';

import 'package:hive/hive.dart';

import '../db_utils/db_constants.dart';
part 'orderwise_tax.g.dart';

@HiveType(typeId: OrderwiseTaxBoxTypeId)
class OrderTax extends HiveObject {
  @HiveField(1)
  String taxId;

  @HiveField(2)
  String itemTaxTemplate;

  @HiveField(3)
  String taxType;

  @HiveField(4)
  double taxRate;

  @HiveField(5, defaultValue: 0.0)
  double taxAmount;

  OrderTax({
    required this.taxId,
    required this.itemTaxTemplate,
    required this.taxType,
    required this.taxRate,
    required this.taxAmount,
  });

  OrderTax copyWith({
   String? taxId,
    String? itemTaxTemplate,
    String? taxType,
    double? taxRate,
    double? taxAmount,
  }) {
    return OrderTax(
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

  factory OrderTax.fromMap(Map<String, dynamic> map) {
    return OrderTax(
      taxId: map["tax_id"] ?? "",
      itemTaxTemplate: map['item_tax_template'] ?? '',
      taxType: map['tax_type'] ?? '',
     taxRate: (map['tax_rate'] ?? 0.0).toDouble(),
    taxAmount: (map['tax_amount'] ?? 0.0).toDouble(),
    );
  }
  String toJson() => json.encode(toMap());

  factory OrderTax.fromJson(String source) =>
      OrderTax.fromMap(json.decode(source));
  @override
  String toString() =>
       'Taxes(tax_id: $taxId,item_tax_template: $itemTaxTemplate, tax_type: $taxType, tax_rate: $taxRate , tax_amount: $taxAmount)';


  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderTax &&
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
