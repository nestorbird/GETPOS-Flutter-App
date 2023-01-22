import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../db_utils/db_constants.dart';
import 'product.dart';

part 'category.g.dart';

@HiveType(typeId: CategoryBoxTypeId)
class Category extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  Uint8List image;

  @HiveField(3)
  List<Product> items;

  String? imageUrl;

  bool isExpanded;

  Category(
      {required this.id,
      required this.name,
      required this.image,
      required this.items,
      this.isExpanded = false,
      this.imageUrl = ''});

  Category copyWith({
    String? id,
    String? name,
    Uint8List? image,
    List<Product>? items,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      items: List<Product>.from(map['items']?.map((x) => Product.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Category.fromJson(String source) =>
      Category.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Category(id: $id, name: $name, image: $image, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Category &&
        other.id == id &&
        other.name == name &&
        other.image == image &&
        listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return id.hashCode ^ name.hashCode ^ image.hashCode ^ items.hashCode;
  }
}
