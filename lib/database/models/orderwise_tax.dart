import 'dart:convert';

import 'package:hive/hive.dart';

import '../db_utils/db_constants.dart';
part 'orderwise_tax.g.dart';

@HiveType(typeId: OrderwiseTaxBoxTypeId)
class OrderTax extends HiveObject {
 

  @HiveField(1)
  String itemTaxTemplate;

  @HiveField(2)
  String taxType;

  @HiveField(3)
  double taxRate;

  OrderTax({
   
    required this.itemTaxTemplate,
    required this.taxType,
    required this.taxRate,
  });

  OrderTax copyWith({
    
    String? itemTaxTemplate,
    String? taxType,
    double? taxRate,
    double? taxAmount,
  }) {
    return OrderTax(
    
      itemTaxTemplate: itemTaxTemplate ?? this.itemTaxTemplate,
      taxType: taxType ?? this.taxType,
      taxRate: taxRate ?? this.taxRate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      
      'itemTaxTemplate': itemTaxTemplate,
      'taxType': taxType,
      'taxRate': taxRate,
    };
  }

  factory OrderTax.fromMap(Map<String, dynamic> map) {
    return OrderTax(
     
      itemTaxTemplate: map['itemTaxTemplate'] ?? '',
      taxType: map['taxType'] ?? '',
      taxRate: map['taxRate'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());

  factory OrderTax.fromJson(String source) =>
      OrderTax.fromMap(json.decode(source));
//
  @override
  String toString() =>
      'Taxes(itemTaxTemplate: $itemTaxTemplate, taxType: $taxType, tax: $taxRate )';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderTax &&
        other.itemTaxTemplate == itemTaxTemplate &&
        other.taxType == taxType &&
        other.taxRate == taxRate;
  }

  @override
  int get hashCode =>
      itemTaxTemplate.hashCode ^ taxType.hashCode ^ taxRate.hashCode;
}
