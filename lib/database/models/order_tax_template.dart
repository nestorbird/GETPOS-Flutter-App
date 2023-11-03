import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';
part 'order_tax_template.g.dart';
@HiveType(typeId: OrderTaxTemplateId)
class OrderTaxTemplate extends HiveObject {
  @HiveField(0)
  String taxId;
  @HiveField(1)
  String name;

  @HiveField(2)
  int isDefault;

  @HiveField(3)
  int disabled;

  @HiveField(4)
  String taxCategory;

  @HiveField(5)
  List<OrderTax> tax;

  OrderTaxTemplate(
      {required this.taxId,
        required this.name,
      required this.isDefault,
      required this.disabled,
      required this.taxCategory,
      required this.tax});

  OrderTaxTemplate copyWith({
    String? taxId,
    String? name,
    int? isDefault,
    int? disabled,
    String? taxCategory,
    List<OrderTax>? tax,
  }) {
    return OrderTaxTemplate(
       taxId: taxId ?? this.taxId,
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      disabled: disabled ?? this.disabled,
      taxCategory: taxCategory ?? this.taxCategory,
      tax: tax ?? this.tax,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'taxId':taxId,
      'name': name,
      'isDefault': isDefault,
      'disabled': disabled,
      'taxCategory': taxCategory,
      'tax': tax,
    };
  }

  factory OrderTaxTemplate.fromMap(Map<String, dynamic> map) {
    return OrderTaxTemplate(
      taxId: map['taxId'] ?? '',
      name: map['name'] ?? '',
      isDefault: map['isDefault'] ?? '',
      disabled: map['disabled'] ?? '',
      taxCategory: map['taxCategory'] ?? '',
      tax: List<OrderTax>.from(map['tax']?.map((x) => OrderTax.fromMap(x))),
    );
  }
  String toJson() => json.encode(toMap());

  factory OrderTaxTemplate.fromJson(String source) =>
      OrderTaxTemplate.fromMap(json.decode(source));

  @override
  String toString() =>
      'Taxes(taxId:$taxId,name: $name, isDefault: $isDefault, taxCategory: $taxCategory, tax: $tax )';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderTaxTemplate &&
    other.taxId == taxId &&
        other.name == name &&
        other.isDefault == isDefault &&
        other.taxCategory == taxCategory &&
        other.disabled == disabled &&
        other.isDefault == isDefault &&
        other.tax == tax;
  }

  @override
  int get hashCode =>
  taxId.hashCode ^
      name.hashCode ^
      isDefault.hashCode ^
      taxCategory.hashCode ^
      disabled.hashCode ^
      isDefault.hashCode ^
      tax.hashCode;
}
