import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../db_utils/db_constants.dart';

part 'option.g.dart';

@HiveType(typeId: OptionBoxTypeId)
class Option extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  bool selected;

  @HiveField(4)
  double tax;

  Option({
    required this.id,
    required this.name,
    required this.price,
    required this.selected,
    required this.tax,
  });

  Option copyWith({
    String? id,
    String? name,
    double? price,
    bool? selected,
    double? tax,
  }) {
    return Option(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      selected: selected ?? this.selected,
      tax: tax ?? this.tax,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'selected': selected,
      'tax': tax
    };
  }

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      selected: map['selected'] ?? false,
      tax: map['tax'] ?? 0.0
    );
  }

  String toJson() => json.encode(toMap());

  factory Option.fromJson(String source) => Option.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Option(id: $id, name: $name, price: $price, selected: $selected, tax: $tax)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Option &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.selected == selected;
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ price.hashCode ^ selected.hashCode;
  }
}
