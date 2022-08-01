import 'dart:convert';

import 'package:equatable/equatable.dart';
import '../../../../database/models/customer.dart';
import '../../../../database/models/order_item.dart';

class Transaction extends Equatable {
  final String id;
  final String date;
  final String time;
  final Customer customer;
  final List<OrderItem> items;
  final double orderAmount;
  final DateTime tracsactionDateTime;

  const Transaction({
    required this.id,
    required this.date,
    required this.time,
    required this.customer,
    required this.items,
    required this.orderAmount,
    required this.tracsactionDateTime,
  });

  Transaction copyWith({
    String? id,
    String? date,
    String? time,
    Customer? customer,
    List<OrderItem>? items,
    double? orderAmount,
    DateTime? tracsactionDateTime,
  }) {
    return Transaction(
      id: id ?? this.id,
      date: date ?? this.date,
      time: time ?? this.time,
      customer: customer ?? this.customer,
      items: items ?? this.items,
      orderAmount: orderAmount ?? this.orderAmount,
      tracsactionDateTime: tracsactionDateTime ?? this.tracsactionDateTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'time': time,
      'customer': customer.toMap(),
      'items': items.map((x) => x.toMap()).toList(),
      'orderAmount': orderAmount,
      'tracsactionDateTime': tracsactionDateTime.millisecondsSinceEpoch,
    };
  }

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      customer: Customer.fromMap(map['customer']),
      items:
          List<OrderItem>.from(map['items']?.map((x) => OrderItem.fromMap(x))),
      orderAmount: map['orderAmount']?.toDouble() ?? 0.0,
      tracsactionDateTime:
          DateTime.fromMillisecondsSinceEpoch(map['tracsactionDateTime']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Transaction.fromJson(String source) =>
      Transaction.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Transaction(id: $id, date: $date, time: $time, customer: $customer, items: $items, orderAmount: $orderAmount, tracsactionDateTime: $tracsactionDateTime)';
  }

  @override
  List<Object> get props {
    return [
      id,
      date,
      time,
      customer,
      items,
      orderAmount,
      tracsactionDateTime,
    ];
  }
}
