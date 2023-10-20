import 'dart:convert';
import 'dart:ffi';

import 'package:hive_flutter/hive_flutter.dart';

import '../db_utils/db_constants.dart';
part 'taxes.g.dart';

@HiveType(typeId: TaxBoxTypeId)
class Taxes extends HiveObject {
  @HiveField(0)
  String itemTaxTemplate;

  @HiveField(1)
   String taxType;

  @HiveField(2)
  double taxRate;
 

  Taxes({
    required this.itemTaxTemplate,
    required this.taxType,
    required this.taxRate,
    
  });

  Taxes copyWith({
    String? itemTaxTemplate,
    String? taxType,
    double? taxRate,
    
  }) {
    return Taxes(
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

  factory Taxes.fromMap(Map<String, dynamic> map) {
    return Taxes(
      itemTaxTemplate: map['itemTaxTemplate'] ?? '',
      taxType: map['taxType'] ?? '',
      taxRate: map['taxRate'] ?? '',
      

    );
  }
  String toJson() => json.encode(toMap());

  factory Taxes.fromJson(String source) => Taxes.fromMap(json.decode(source));
//
  @override
  String toString() =>
      'Taxes(itemTaxTemplate: $itemTaxTemplate, taxType: $taxType, tax: $taxRate )';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Taxes &&
        other.itemTaxTemplate == itemTaxTemplate && other.taxType == taxType &&
        other.taxRate == taxRate;
  }

  @override
  int get hashCode => itemTaxTemplate.hashCode ^ taxType.hashCode ^ taxRate.hashCode;
}
