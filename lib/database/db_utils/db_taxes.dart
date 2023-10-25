import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/models/order_item.dart';
import 'package:nb_posx/database/models/taxes.dart';

import 'db_constants.dart';

class DbTaxes {
  late Box box;

  Future<void> addTaxes(List<Taxes> list) async {
    box = await Hive.openBox<Taxes>(TAX_BOX);

    for (Taxes item in list) {
      await box.put(item.taxId, item);
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

  Future<List<Taxes>> getTaxes() async {
    box = await Hive.openBox<Taxes>(TAX_BOX);
    List<Taxes> list = [];

    for (var item in box.values) {
      var tax = item as Taxes;
      getProducts();
      var product = item as OrderItem;

      if (product.stock > 0 && product.price > 0 && tax.taxRate > 0) {
        list.add(tax);
      }
    }
    return list;
  }

  Future<Taxes?> getProductDetails(String key) async {
    box = await Hive.openBox<Taxes>(TAX_BOX);
    return box.get(key);
  }

  // Future<void> reduceInventory(List<Taxes> items) async {
  //   box = await Hive.openBox<Taxes>(TAX_BOX);
  //   for (Taxes item in items) {
  //     Taxes itemInDB = box.get(item.id) as Taxes;
  //     var availableQty = itemInDB.stock - item.orderedQuantity;
  //     itemInDB.stock = availableQty;
  //     itemInDB.orderedQuantity = 0;
  //     itemInDB.productUpdatedTime = DateTime.now();
  //     await itemInDB.save();
  //   }
  // }

  Future<int> deleteProducts() async {
    box = await Hive.openBox<Taxes>(TAX_BOX);
    return box.clear();
  }

  Future<List<Taxes>> getAllProducts() async {
    box = await Hive.openBox<Taxes>(TAX_BOX);
    List<Taxes> list = [];
    for (var item in box.values) {
      var tax = item as Taxes;
      getProducts();
      var product = item as OrderItem;
      if (product.stock > 0 && product.price > 0 && tax.taxRate > 0) {
        list.add(tax);
      }
    }
    box.close();
    return list;
  }
}
