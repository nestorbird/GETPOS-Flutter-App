import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/order_item.dart';
import '../models/park_order.dart';
import 'db_constants.dart';
import 'db_order_item.dart';

class DbParkedOrder {
  late Box box;

  Future<String> createOrder(ParkOrder order) async {
    String res = await saveOrder(order);
    // DBPreferences().incrementOrderNo(order.id);
    DbOrderItem().reduceInventory(order.items);

    await box.close();
    return res;
  }

  // Future<String> updateOrder(String newID, ParkOrder order) async {
  //   box = await Hive.openBox<ParkOrder>(PARKED_ORDER_BOX);
  //   String orderKey = _getOrderKey(order);
  //   ParkOrder item = await box.get(orderKey);
  //   item.id = newID;
  //   item.save();

  //   return orderKey;
  // }

  Future<List<ParkOrder>> getOrders() async {
    // LazyBox box = await Hive.openLazyBox(PARKED_ORDER_BOX);
    box = await Hive.openBox<ParkOrder>(PARKED_ORDER_BOX);

    List<ParkOrder> list = [];

    for (var key in box.keys) {
      var item = await box.get(key);
      var order = item as ParkOrder;

      Future.forEach(order.items, (item) async {
        var product = item as OrderItem;
        OrderItem? pro = await DbOrderItem().getProductDetails(product.id);
        if (pro != null) {
          product.productImage = pro.productImage;
        }
      });
      list.add(order);
    }
    // await box.close();
    return list;
  }

  // Future<List<ParkOrder>> getOfflineOrders() async {
  //   box = await Hive.openBox<ParkOrder>(PARKED_ORDER_BOX);

  //   List<ParkOrder> list = [];
  //   // print("TOTAL ORDERS: ${box.keys.length}");
  //   for (var key in box.keys) {
  //     var item = await box.get(key);
  //     var product = item as ParkOrder;
  //     if (product.transactionSynced == false) list.add(product);
  //   }
  //   // await box.close();
  //   return list;
  // }

  // Future<double> getOfflineOrderCashBalance() async {
  //   box = await Hive.openBox<ParkOrder>(PARKED_ORDER_BOX);

  //   double cashBalance = 0;
  //   // print("TOTAL ORDERS: ${box.keys.length}");
  //   for (var key in box.keys) {
  //     var item = await box.get(key);
  //     var product = item as ParkOrder;
  //     if (product.transactionSynced == false) {
  //       if (product.transactionId.isEmpty) {
  //         cashBalance = cashBalance + product.orderAmount;
  //       }
  //     }
  //   }
  //   await box.close();
  //   return cashBalance;
  // }

  Future<String> saveOrder(ParkOrder order) async {
    box = await Hive.openBox<ParkOrder>(PARKED_ORDER_BOX);
    String orderKey = _getOrderKey(order);
    await box.put(orderKey, order);
    // await box.close();
    return orderKey;
  }

  // Future<bool> saveOrders(List<ParkOrder> sales) async {
  //   box = await Hive.openBox<ParkOrder>(PARKED_ORDER_BOX);
  //   await Future.forEach(sales, (parkOrder) async {
  //     ParkOrder order = parkOrder as ParkOrder;
  //     String orderKey = _getOrderKey(order);

  //     await box.put(orderKey, order);
  //   });
  //   return true;
  // }

  Future<void> delete() async {
    box = await Hive.openBox<ParkOrder>(PARKED_ORDER_BOX);
    await box.clear();
    await box.close();
  }

  String _getOrderKey(ParkOrder order) {
    // return "${order.date}_${order.time}";
    return "${order.transactionDateTime.millisecondsSinceEpoch}";
  }

  Future<bool> deleteOrder(ParkOrder order) async {
    box = await Hive.openBox<ParkOrder>(PARKED_ORDER_BOX);
    String orderKey = _getOrderKey(order);
    ParkOrder? parkOrder = box.get(orderKey);
    parkOrder!.delete();
    return true;
  }

  Future<bool> deleteOrderById(String orderId) async {
    try {
      box = await Hive.openBox<ParkOrder>(PARKED_ORDER_BOX);
      // String orderKey = _getOrderKey(order);
      ParkOrder parkOrder = box.get(orderId);
      parkOrder.delete();
    } catch (e) {
      debugPrintStack(label: 'Delete order by ID');
    }
    return true;
  }

  Future<bool> removeOrderItem(ParkOrder order, OrderItem item) async {
    try {
      box = await Hive.openBox<ParkOrder>(PARKED_ORDER_BOX);
      String orderKey = _getOrderKey(order);
      ParkOrder parkOrder = box.get(orderKey);
      for (OrderItem i in parkOrder.items) {
        if (i == item) {
          parkOrder.items.remove(i);
          break;
        }
      }
      return true;
    } catch (ex) {
      debugPrint("Exception occured while Removing item from order");
      debugPrintStack();
      return false;
    }
  }
}
