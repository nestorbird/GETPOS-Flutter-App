import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/db_utils/db_taxes.dart';
import 'package:nb_posx/database/models/taxes.dart';

import '../models/order_item.dart';
import 'db_constants.dart';

class DbOrderItem {
  late Box box;

  Future<void> addProducts(List<OrderItem> list) async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);

    for (OrderItem item in list) {
      await box.put(item.id, item);
    }
  }

  Future<List<OrderItem>> getProducts() async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
    List<OrderItem> list = [];
    for (var item in box.values) {
      var product = item as OrderItem;
      if (product.stock > 0 && product.price > 0) list.add(product);
    }
    return list;
  }

  Future<OrderItem?> getProductDetails(String key) async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
    return box.get(key);
  }

  Future<void> reduceInventory(List<OrderItem> items) async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
    for (OrderItem item in items) {
      OrderItem itemInDB = box.get(item.id) as OrderItem;
      var availableQty = itemInDB.stock - item.orderedQuantity;
      itemInDB.stock = availableQty;
      itemInDB.orderedQuantity = 0;
      itemInDB.productUpdatedTime = DateTime.now();
      await itemInDB.save();
    }
  }

  Future<int> deleteProducts() async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
    return box.clear();
  }

  Future<List<OrderItem>> getAllProducts() async {
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
    List<OrderItem> list = [];
    for (var item in box.values) {
      var product = item as OrderItem;
      if (product.stock > 0 && product.price > 0) list.add(product);
    }
    box.close();
    return list;
  }

 // Method to update tax amounts
  Future<void> updateTaxAmounts(String orderId,) async {
    // Retrieve tax amounts from the database
    final List<Taxes>? itemTaxesList = await DbTaxes().getItemWiseTax(orderId);

    // Update the tax field of each OrderItem
    box = await Hive.openBox<OrderItem>(ORDER_ITEM_BOX);
    for (var itemId in box.keys) {
      var itemInDB = box.get(itemId) as OrderItem?;
      if (itemInDB != null) {
        // Check if the order ID matches
        if (itemInDB.id == orderId) {
          itemInDB.tax = itemTaxesList; // Update the tax field
          await itemInDB.save(); // Save the updated OrderItem
        }
      }
    }
  }

}
