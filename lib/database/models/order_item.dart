import 'dart:convert';
import 'dart:typed_data';

import 'package:hive/hive.dart';
import 'package:nb_posx/database/models/taxes.dart';

import '../db_utils/db_constants.dart';
import 'attribute.dart';

part 'order_item.g.dart';

@HiveType(typeId: OrderItemBoxTypeId)
class OrderItem extends HiveObject {
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
  double orderedQuantity;

  @HiveField(8)
  Uint8List productImage;

  @HiveField(9)
  DateTime productUpdatedTime;

  @HiveField(10)
  double orderedPrice;

  @HiveField(11, defaultValue: '')
  String? productImageUrl;

  @HiveField(12)
  List<Taxes> tax;

  OrderItem(
      {required this.id,
      required this.name,
      required this.group,
      required this.description,
      required this.stock,
      required this.price,
      required this.attributes,
      this.orderedQuantity = 0,
      this.orderedPrice = 0,
      required this.productImage,
      required this.productUpdatedTime,
      required this.productImageUrl,
      required this.tax});

  OrderItem copyWith(
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
      String? productImageUrl,
      List<Taxes>? tax}) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      group: group ?? this.group,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      price: price ?? this.price,
      attributes: attributes ?? this.attributes,
      orderedQuantity: orderedQuantity ?? this.orderedQuantity,
      orderedPrice: orderedPrice ?? this.orderedPrice,
      productImage: productImage ?? this.productImage,
      productUpdatedTime: productUpdatedTime ?? this.productUpdatedTime,
      productImageUrl: productImageUrl ?? this.productImageUrl,
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
      'attributes': attributes,
      'orderedQuantity': orderedQuantity,
      'orderedPrice': orderedPrice,
      'productImage': productImage,
      'productUpdatedTime': productUpdatedTime.toIso8601String(),
      'tax': tax
    };
  }

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    // List<int> data = map['productImage'].codeUnits;
    List<int>? data =
        (map["productImage"] as List).map((e) => e as int).toList();

    return OrderItem(
      id: map['id'],
      name: map['name'],
      group: map['group'],
      description: map['description'],
      stock: map['stock'],
      price: map['price'],
      // List<OrderItem>.from(
      // map['items']?.map((x) => OrderItem.fromMap(x)))
      attributes: List<Attribute>.from(
          map['attributes']?.map((x) => Attribute.fromMap(x))),
      orderedQuantity: map['orderedQuantity'] ?? 0,
      orderedPrice: map['orderedPrice'] ?? map['price'],
      productImage: Uint8List.fromList(data), //map['productImage'],
      productUpdatedTime: DateTime.parse(map['productUpdatedTime']),
      productImageUrl: map['productImageUrl'],
    //      tax: (map['tax'] as List<Map<String, dynamic>>?)
    //  ?.map((taxMap) => Taxes.fromMap(taxMap))
    //  .toList() ?? []);
     // tax:(map['tax'] as List<Map<String, dynamic>>?)?? map((taxMap) => Taxes.fromMap(taxMap))
    //   tax: (map['tax'] as List<Map<String, dynamic>>?)
    // ?.map((taxMap) => Taxes.fromMap(taxMap))
    // ?.toList() ?? [];
    tax:List<Taxes>.from(
          map['tax']?.map((x) => Taxes.fromMap(x))),
    );
      //tax: map['tax']
    
  }

  String toJson() => json.encode(toMap());

  factory OrderItem.fromJson(String source) =>
      OrderItem.fromMap(json.decode(source));

  @override
  String toString() {
    return 'OrderItem(id: $id,  name: $name, group: $group, description: $description, stock: $stock, price: $price, attributes: $attributes, orderedQuantity: $orderedQuantity, orderedPrice: $orderedPrice, productImage: $productImage, productUpdatedTime: $productUpdatedTime, tax:$tax)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OrderItem &&
        other.id == id &&
        other.name == name &&
        other.group == group &&
        other.description == description &&
        other.stock == stock &&
        other.price == price &&
        other.attributes == attributes &&
        other.orderedQuantity == orderedQuantity &&
        other.orderedPrice == orderedPrice &&
        other.productImage == productImage &&
        other.productUpdatedTime == productUpdatedTime &&
        other.tax == tax;
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
        orderedQuantity.hashCode ^
        orderedPrice.hashCode ^
        productImage.hashCode ^
        productUpdatedTime.hashCode ^
        tax.hashCode;
  }
}
