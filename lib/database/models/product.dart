import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';

import '../db_utils/db_constants.dart';
import 'attribute.dart';

part 'product.g.dart';

@HiveType(typeId: ProductsBoxTypeId)
class Product extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double price;

  @HiveField(3)
  String group;

  @HiveField(4)
  String description;

  @HiveField(5)
  double stock;

  @HiveField(6)
  List<Attribute> attributes;

  @HiveField(7)
  Uint8List productImage;

  @HiveField(8)
  DateTime productUpdatedTime;

  @HiveField(9, defaultValue: 0.0)
  double tax;

  String? productImageUrl;

  Product(
      {required this.id,
      required this.name,
      required this.group,
      required this.description,
      required this.stock,
      required this.price,
      required this.attributes,
      required this.productImage,
      required this.productUpdatedTime,
      this.productImageUrl = '',
      required this.tax});

  Product copyWith(
      {String? id,
      String? code,
      String? name,
      String? group,
      String? description,
      double? stock,
      double? price,
      List<Attribute>? attributes,
      double? orderedQuantity,
      double? orderedPrice,
      Uint8List? productImage,
      DateTime? productUpdatedTime,
      double? tax}) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      group: group ?? this.group,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      attributes: attributes ?? this.attributes,
      productImage: productImage ?? this.productImage,
      productUpdatedTime: productUpdatedTime ?? this.productUpdatedTime,
      tax: tax ?? this.tax,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'group': group,
      'description': description,
      'stock': stock,
      'price': price,
      'attributes': attributes.map((x) => x.toMap()).toList(),
      'productImage': productImage,
      'productUpdatedTime': productUpdatedTime.toIso8601String(),
      'tax': tax
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
        id: map['id'],
        name: map['name'],
        group: map['group'],
        description: map['description'],
        stock: map['stock'],
        price: map['price'],
        attributes: List<Attribute>.from(
            map['attributes']?.map((x) => Attribute.fromMap(x))),
        productImage: map['productImage'],
        productUpdatedTime: map['productUpdatedTime'],
        tax: map['tax']);
  }

  String toJson() => json.encode(toMap());

  factory Product.fromJson(String source) =>
      Product.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Product(id: $id,  name: $name, group: $group, description: $description, stock: $stock, price: $price, attributes: $attributes,  productImage: $productImage, productUpdatedTime: $productUpdatedTime, tax: $tax)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Product &&
        other.id == id &&
        other.name == name &&
        other.group == group &&
        other.description == description &&
        other.stock == stock &&
        other.price == price &&
        other.attributes == attributes &&
        other.productImage == productImage &&
        other.productUpdatedTime == productUpdatedTime;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        group.hashCode ^
        description.hashCode ^
        stock.hashCode ^
        price.hashCode ^
        attributes.hashCode ^
        productImage.hashCode ^
        productUpdatedTime.hashCode;
  }
}
