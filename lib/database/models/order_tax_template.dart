import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';
part 'order_tax_template.g.dart';

@HiveType(typeId: OrderTaxTemplateId)
class OrderTaxTemplate extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  int isDefault;

  @HiveField(2)
  int disabled;

  @HiveField(3)
  String taxCategory;

  @HiveField(4)
  List<OrderTax> tax;

  OrderTaxTemplate(
      {required this.name,
      required this.isDefault,
      required this.disabled,
      required this.taxCategory,
      required this.tax});

  OrderTaxTemplate copyWith({
    String? name,
    int? isDefault,
    int? disabled,
    String? taxCategory,
    List<OrderTax>? tax,
  }) {
    return OrderTaxTemplate(
      name: name ?? this.name,
      isDefault: isDefault ?? this.isDefault,
      disabled: disabled ?? this.disabled,
      taxCategory: taxCategory ?? this.taxCategory,
      tax: tax ?? this.tax,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'isDefault': isDefault,
      'disabled': disabled,
      'taxCategory': taxCategory,
      'tax': tax,
    };
  }

  factory OrderTaxTemplate.fromMap(Map<String, dynamic> map) {
    return OrderTaxTemplate(
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
      'Taxes(name: $name, isDefault: $isDefault, taxCategory: $taxCategory, tax: $tax )';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderTaxTemplate &&
        other.name == name &&
        other.isDefault == isDefault &&
        other.taxCategory == taxCategory &&
        other.disabled == disabled &&
        other.isDefault == isDefault &&
        other.tax == tax;
  }

  @override
  int get hashCode =>
      name.hashCode ^
      isDefault.hashCode ^
      taxCategory.hashCode ^
      disabled.hashCode ^
      isDefault.hashCode ^
      tax.hashCode;
}
