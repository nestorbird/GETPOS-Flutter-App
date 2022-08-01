import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../../../../database/models/product.dart';

class Category {
  String id;
  String name;
  List<Product> itemList;
  bool isExpanded;
  Category({
    required this.id,
    required this.name,
    required this.itemList,
    this.isExpanded = false,
  });

  Category copyWith({
    String? id,
    String? name,
    List<Product>? itemList,
    bool? isExpanded,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      itemList: itemList ?? this.itemList,
      isExpanded: isExpanded ?? this.isExpanded,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'itemList': itemList.map((x) => x.toMap()).toList(),
      'isExpanded': isExpanded,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      itemList:
          List<Product>.from(map['itemList']?.map((x) => Product.fromMap(x))),
      isExpanded: map['isExpanded'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Category(id: $id, name: $name, itemList: $itemList, isExpanded: $isExpanded)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.id == id &&
        other.name == name &&
        listEquals(other.itemList, itemList) &&
        other.isExpanded == isExpanded;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        itemList.hashCode ^
        isExpanded.hashCode;
  }

  static List<Category> getCategories(List<Product> products) {
    List<Category> catList = [];
    for (Product p in products) {
      Category cat = Category(
          id: p.name, name: p.name, itemList: products, isExpanded: false);
      catList.add(cat);
    }
    return catList;
  }
}
