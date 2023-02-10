import 'dart:convert';

import 'package:flutter/foundation.dart';

class SalesOrderRequest {
  late String hubManager;
  late String customer;
  late String transactionDate;
  late String deliveryDate;
  late List<Items> items;
  late String modeOfPayment;
  late String mpesaNo;

  SalesOrderRequest(
      {required this.hubManager,
      required this.customer,
      required this.transactionDate,
      required this.deliveryDate,
      required this.items,
      required this.modeOfPayment,
      this.mpesaNo = ""});

  SalesOrderRequest.fromJson(Map<String, dynamic> json) {
    hubManager = json['hub_manager'];
    customer = json['customer'];
    transactionDate = json['transaction_date'];
    deliveryDate = json['delivery_date'];
    if (json['items'] != null) {
      items = [];
      json['items'].forEach((v) {
        items.add(Items.fromJson(v));
      });
    }
    modeOfPayment = json['mode_of_payment'];
    mpesaNo = json['mpesa_no'];
  }

  Map toJson() {
    // final Map<String, dynamic> data = <String, dynamic>{};
    // data['hub_manager'] = hubManager;
    // // data['ward'] = ward;
    // data['customer'] = customer;
    // data['transaction_date'] = transactionDate;
    // data['delivery_date'] = deliveryDate;
    // // ignore: unnecessary_null_comparison
    // if (items != null) {
    //   data['items'] = items.map((v) => v.toJson()).toList();
    // }
    // data['mode_of_payment'] = modeOfPayment;
    // data['mpesa_no'] = mpesaNo;
    List<Map> itemList = items.map((v) => v.toJson()).toList();
    return {
      'hub_manager': hubManager,
      'customer': customer,
      'transaction_date': transactionDate,
      'delivery_date': deliveryDate,
      'mode_of_payment': modeOfPayment,
      'items': itemList
    };
  }
}

class Items {
  String itemCode;
  String name;
  double price;
  List<SelectedOptions> selectedOption;
  double orderedQuantity;
  double orderedPrice;
  Items({
    required this.itemCode,
    required this.name,
    required this.price,
    required this.selectedOption,
    required this.orderedQuantity,
    required this.orderedPrice,
  });

  Items copyWith({
    String? itemCode,
    String? name,
    double? price,
    List<SelectedOptions>? selectedOption,
    double? orderedQuantity,
    double? orderedPrice,
  }) {
    return Items(
      itemCode: itemCode ?? this.itemCode,
      name: name ?? this.name,
      price: price ?? this.price,
      selectedOption: selectedOption ?? this.selectedOption,
      orderedQuantity: orderedQuantity ?? this.orderedQuantity,
      orderedPrice: orderedPrice ?? this.orderedPrice,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_code': itemCode,
      'item_name': name,
      'rate': price,
      'sub_items': selectedOption.map((x) => x.toMap()).toList(),
      'qty': orderedQuantity,
      'ordered_price': orderedPrice,
    };
  }

  factory Items.fromMap(Map<String, dynamic> map) {
    return Items(
      itemCode: map['itemCode'] ?? '',
      name: map['name'] ?? '',
      price: map['price'] ?? '',
      selectedOption: List<SelectedOptions>.from(
          map['selectedOption']?.map((x) => SelectedOptions.fromMap(x))),
      orderedQuantity: map['orderedQuantity'] ?? '',
      orderedPrice: map['orderedPrice'] ?? '',
    );
  }

  Map toJson() => toMap();

  factory Items.fromJson(String source) => Items.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Items(itemCode: $itemCode, name: $name, price: $price, selectedOption: $selectedOption, orderedQuantity: $orderedQuantity, orderedPrice: $orderedPrice)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Items &&
        other.itemCode == itemCode &&
        other.name == name &&
        other.price == price &&
        listEquals(other.selectedOption, selectedOption) &&
        other.orderedQuantity == orderedQuantity &&
        other.orderedPrice == orderedPrice;
  }

  @override
  int get hashCode {
    return itemCode.hashCode ^
        name.hashCode ^
        price.hashCode ^
        selectedOption.hashCode ^
        orderedQuantity.hashCode ^
        orderedPrice.hashCode;
  }
}

class SelectedOptions {
  String id;
  String name;
  double price;
  double qty;
  SelectedOptions({
    required this.id,
    required this.name,
    required this.price,
    required this.qty,
  });

  SelectedOptions copyWith({
    String? id,
    String? name,
    double? price,
    double? qty,
  }) {
    return SelectedOptions(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      qty: qty ?? this.qty,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'item_code': id,
      'item_name': name,
      'qty': qty,
      'rate': price,
    };
  }

  factory SelectedOptions.fromMap(Map<String, dynamic> map) {
    return SelectedOptions(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      qty: map['qty'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory SelectedOptions.fromJson(String source) =>
      SelectedOptions.fromMap(json.decode(source));

  @override
  String toString() =>
      'SelectedOptions(id: $id, name: $name, price: $price, qty: $qty)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SelectedOptions &&
        other.id == id &&
        other.name == name &&
        other.price == price &&
        other.qty == qty;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ price.hashCode ^ qty.hashCode;
}
