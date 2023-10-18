import 'dart:convert';
import 'dart:ffi';

import 'package:hive_flutter/hive_flutter.dart';

import '../db_utils/db_constants.dart';
part 'taxes.g.dart';

@HiveType(typeId: TaxBoxTypeId)
class Taxes extends HiveObject {
  @HiveField(0)
  String itemTaxTemplate;

  @HiveField(1, defaultValue: 0.0)
  double taxRate;

  Taxes({
    required this.itemTaxTemplate,
    required this.taxRate,
  });

  Taxes copyWith({
    String? itemTaxTemplate,
    double? taxRate,
  }) {
    return Taxes(
      itemTaxTemplate: itemTaxTemplate ?? this.itemTaxTemplate,
      taxRate: taxRate ?? this.taxRate,
      
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemTaxTemplate': itemTaxTemplate,
      'taxRate': taxRate,
    };
  }

  factory Taxes.fromMap(Map<String, dynamic> map) {
    return Taxes(
      itemTaxTemplate: map['itemTaxTemplate'] ?? '',
      taxRate: map['taxRate'] ?? '',
    );
  }
  String toJson() => json.encode(toMap());

  factory Taxes.fromJson(String source) => Taxes.fromMap(json.decode(source));
//
  @override
  String toString() =>
      'Taxes(itemTaxTemplate: $itemTaxTemplate)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Taxes &&
        other.itemTaxTemplate == itemTaxTemplate &&
        other.taxRate == taxRate;
  }

  @override
  int get hashCode => itemTaxTemplate.hashCode ^ taxRate.hashCode;
}
