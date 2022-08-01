import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

import '../db_utils/db_constants.dart';
import 'customer.dart';
import 'hub_manager.dart';
import 'order_item.dart';

part 'park_order.g.dart';

@HiveType(typeId: ParkOrderBoxTypeId)
class ParkOrder extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String date;

  @HiveField(2)
  String time;

  @HiveField(3)
  Customer customer;

  @HiveField(4)
  HubManager manager;

  @HiveField(5)
  List<OrderItem> items;

  @HiveField(6)
  double orderAmount;

  @HiveField(7)
  DateTime transactionDateTime;

  ParkOrder({
    required this.id,
    required this.date,
    required this.time,
    required this.customer,
    required this.manager,
    required this.items,
    required this.orderAmount,
    required this.transactionDateTime,
  });

  ParkOrder copyWith({
    String? id,
    String? date,
    String? time,
    Customer? customer,
    HubManager? manager,
    List<OrderItem>? items,
    double? orderAmount,
    DateTime? transactionDateTime,
  }) {
    return ParkOrder(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      customer: customer ?? this.customer,
      manager: manager ?? this.manager,
      items: items ?? this.items,
      orderAmount: orderAmount ?? this.orderAmount,
      transactionDateTime: transactionDateTime ?? this.transactionDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'customer': customer.toMap(),
      'manager': manager.toMap(),
      'items': items.map((x) => x.toMap()).toList(),
      'orderAmount': orderAmount,
      'transactionDateTime': transactionDateTime,
    };
  }

  factory ParkOrder.fromMap(Map<String, dynamic> map) {
    return ParkOrder(
      id: map['id'],
      date: map['date'],
      time: map['time'],
      customer: Customer.fromMap(map['customer']),
      manager: HubManager.fromMap(map['manager']),
      items:
          List<OrderItem>.from(map['items']?.map((x) => OrderItem.fromMap(x))),
      orderAmount: map['orderAmount'],
      transactionDateTime: map['transactionDateTime'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ParkOrder.fromJson(String source) =>
      ParkOrder.fromMap(json.decode(source));

  @override
  String toString() {
    return 'ParkOrder(id: $id, date: $date, time: $time, customer: $customer, manager: $manager, items: $items, orderAmount: $orderAmount)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ParkOrder &&
        other.id == id &&
        other.date == date &&
        other.time == time &&
        other.customer == customer &&
        other.manager == manager &&
        other.items == items &&
        other.transactionDateTime == transactionDateTime &&
        other.orderAmount == orderAmount;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        date.hashCode ^
        time.hashCode ^
        customer.hashCode ^
        manager.hashCode ^
        items.hashCode ^
        transactionDateTime.hashCode ^
        orderAmount.hashCode;
  }
}
