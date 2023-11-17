import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:nb_posx/core/service/create_order/model/selected_options.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/taxes.dart';

part 'sales_order_req_items.g.dart';

@HiveType(typeId: SalesOrderRequestItemsId)
class SaleOrderRequestItems extends HiveObject {
  @HiveField(0)
  String? itemCode;

  @HiveField(1)
  String? name;

  @HiveField(2)
  double? price;

  @HiveField(3)
  List<SelectedOptions>? selectedOption;

  @HiveField(4)
  double? orderedQuantity;

  @HiveField(5)
  double? orderedPrice;

  @HiveField(6)
  List<Taxes>? tax;

  SaleOrderRequestItems( {
    required this.itemCode,
    required this.name,
    required this.price,
    required this.selectedOption,
    required this.orderedQuantity,
    required this.orderedPrice,
    required this.tax,
  });

  SaleOrderRequestItems copyWith({
    String? itemCode,
    String? name,
    double? price,
    double? orderedQuantity,
    List<SelectedOptions>? selectedOption,
    double? orderedPrice,
    List<Taxes>? tax,
  }) {
    return SaleOrderRequestItems(
      itemCode: itemCode ?? this.itemCode,
      name: name ?? this.name,
      price: price ?? this.price,
      orderedQuantity: orderedQuantity ?? this.orderedQuantity,
      selectedOption: selectedOption ?? this.selectedOption,
      orderedPrice: orderedPrice ?? this.orderedPrice,
      tax: tax ?? this.tax,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemCode': itemCode,
      'name': name,
      'price': price,
      'selectedOption': selectedOption!.map((x) => x.toMap()).toList(),
      'orderedQuantity': orderedQuantity,
      'orderedPrice': orderedPrice,
      'tax': tax!.map((x) => x.toMap()).toList(),
    };
  }

  factory SaleOrderRequestItems.fromMap(Map<String, dynamic> map) {
    return SaleOrderRequestItems(
      itemCode: map['itemCode'],
      name: map['name'],
      price: map['price'],
      selectedOption: List<SelectedOptions>.from(
          map['selectedOption']?.map((x) => SelectedOptions.fromMap(x))),
      orderedQuantity: map['orderedQuantity'],
      orderedPrice: map['orderedPrice'],
      tax: map['tax'],
    );
  }

  String toJson() => json.encode(toMap());

  factory SaleOrderRequestItems.fromJson(String source) =>
      SaleOrderRequestItems.fromMap(json.decode(source));

  @override
  String toString() {
    return 'SaleOrder(itemCode: $itemCode, name: $name, price: $price,  selectedOption: $selectedOption, orderedQuantity: $orderedQuantity, orderedPrice: $orderedPrice, tax: $tax )';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SaleOrderRequestItems &&
        other.itemCode == itemCode &&
        other.name == name &&
        other.price == price &&
        other.orderedQuantity == orderedQuantity &&
        listEquals(other.selectedOption, selectedOption) &&
        other.orderedPrice == orderedPrice &&
        other.tax == tax;
  }

  @override
  int get hashCode {
    return itemCode.hashCode ^
        name.hashCode ^
        price.hashCode ^
        selectedOption.hashCode ^
        orderedQuantity.hashCode ^
        orderedPrice.hashCode ^
        tax.hashCode;
  }
}
