import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/core/mobile/create_order_new/ui/widget/calculate_taxes.dart';

import '../../constants/app_constants.dart';
import '../models/order_item.dart';
import '../models/product.dart';
import '../models/sale_order.dart';
import 'db_categories.dart';
import 'db_constants.dart';
import 'db_hub_manager.dart';
import 'db_order_item.dart';
import 'db_preferences.dart';
import 'db_product.dart';

class DbSaleOrder {
  late Box box;

  Future<String> createOrder(SaleOrder order) async {
    String res = await saveOrder(order);
    await DBPreferences().incrementOrderNo(order.id);
    await DbCategory().reduceInventory(order.items);
    if (order.transactionId.isEmpty) {
      await DbHubManager().updateCashBalance(order.orderAmount);
    }
    await box.close();
    return res;
  }

  Future<String> updateOrder(String newID, SaleOrder order) async {
    box = await Hive.openBox<SaleOrder>(SALE_ORDER_BOX);
    String orderKey = _getOrderKey(order);
    SaleOrder item = await box.get(orderKey);
    item.transactionSynced = true;
    item.id = newID;
    item.save();

    return orderKey;
  }

  Future<List<SaleOrder>> getOrders() async {
    // LazyBox box = await Hive.openLazyBox(SALE_ORDER_BOX);
    box = await Hive.openBox<SaleOrder>(SALE_ORDER_BOX);

    List<SaleOrder> list = [];

    for (var key in box.keys) {
      var item = await box.get(key);
      var order = item as SaleOrder;

      Future.forEach(order.items, (item) async {
        var product = item as Product;
        Product? pro = await DbProduct().getProductDetails(product.id);
        if (pro != null) {
          product.productImage = pro.productImage;
        }
      });
      list.add(order);
    }
    // await box.close();
    return list;
  }

  Future<List<SaleOrder>> getOfflineOrders() async {
    box = await Hive.openBox<SaleOrder>(SALE_ORDER_BOX);

    List<SaleOrder> list = [];
    // print("TOTAL ORDERS: ${box.keys.length}");
    for (var key in box.keys) {
      var item = await box.get(key);
      var product = item as SaleOrder;
      if (product.transactionSynced == false) list.add(product);
    }
    await box.close();
    return list;
  }

  Future<double> getOfflineOrderCashBalance() async {
    box = await Hive.openBox<SaleOrder>(SALE_ORDER_BOX);

    double cashBalance = 0;
    // print("TOTAL ORDERS: ${box.keys.length}");
    for (var key in box.keys) {
      var item = await box.get(key);
      var product = item as SaleOrder;
      if (product.transactionSynced == false) {
        if (product.transactionId.isEmpty) {
          cashBalance = cashBalance + product.orderAmount;
        }
      }
    }
    await box.close();
    return cashBalance;
  }

  Future<String> saveOrder(SaleOrder order) async {
    box = await Hive.openBox<SaleOrder>(SALE_ORDER_BOX);
    String orderKey = _getOrderKey(order);
    await box.put(orderKey, order);
    // await box.close();
    return orderKey;
  }

  Future<bool> saveOrders(List<SaleOrder> sales) async {
    box = await Hive.openBox<SaleOrder>(SALE_ORDER_BOX);
    await Future.forEach(sales, (saleOrder) async {
      SaleOrder order = saleOrder as SaleOrder;
      String orderKey = _getOrderKey(order);

      await box.put(orderKey, order);
    });
    return true;
  }

  Future<void> delete() async {
    box = await Hive.openBox<SaleOrder>(SALE_ORDER_BOX);
    await box.clear();
    await box.close();
  }

  String _getOrderKey(SaleOrder order) {
    // return "${order.date}_${order.time}";
    return "${order.tracsactionDateTime.millisecondsSinceEpoch}";
  }

  Future<bool> modifySevenDaysOrdersFromToday() async {
    box = await Hive.openBox<SaleOrder>(SALE_ORDER_BOX);

    List<SaleOrder> list = [];

    for (var key in box.keys) {
      var item = await box.get(key);
      var order = item as SaleOrder;

      Future.forEach(order.items, (item) async {
        var product = item as OrderItem;
        OrderItem? pro = await DbOrderItem().getProductDetails(product.id);
        if (pro != null) {
          product.productImage = pro.productImage;
        }
      });
      list.add(order);
    }

    DateTime todaysDateTime = DateTime.now();
    int deleteCounter = 0;

    var dataUpto =
        todaysDateTime.subtract(const Duration(days: OFFLINE_DATA_FOR));

    var salesData = list.where((element) =>
        element.tracsactionDateTime.isBefore(dataUpto) &&
        element.transactionSynced == true);

    int itemsToDelete = salesData.length;

    await Future.forEach(salesData, (order) async {
      var orderData = order as SaleOrder;

      await orderData.delete();
      itemsToDelete += 1;
    });

    // await box.close();
    return itemsToDelete == deleteCounter;
  }

  //to save tax list in db for orderwise taxation
  Future<List> saveOrderWiseTax(orderId, List<OrderTaxes> list) async {
    box = await Hive.openBox<SaleOrder>(SALE_ORDER_BOX);
    for (OrderTaxes item in list) {
      await box.put(item.id, item);
    }
    // var taxwiseOrder=  await box.putAll();

    return list;
  }
}
