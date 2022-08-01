import 'package:hive_flutter/hive_flutter.dart';

import '../models/category.dart';
import '../models/order_item.dart';
import 'db_constants.dart';

class DbCategory {
  late Box box;

  Future<void> addCategory(List<Category> list) async {
    box = await Hive.openBox<Category>(CATEGORY_BOX);
    for (Category cat in list) {
      await box.put(cat.id, cat);
    }
  }

  Future<List<Category>> getCategories() async {
    box = await Hive.openBox<Category>(CATEGORY_BOX);
    List<Category> list = [];
    for (var item in box.values) {
      var cat = item as Category;
      list.add(cat);
    }
    return list;
  }

  Future<void> reduceInventory(List<OrderItem> items) async {
    box = await Hive.openBox<Category>(CATEGORY_BOX);
    for (OrderItem orderItem in items) {
      for (var item in box.values) {
        Category cat = item as Category;
        if (cat.name == orderItem.group) {
          for (var catItem in cat.items) {
            if (catItem.name == orderItem.name &&
                catItem.stock != -1 &&
                catItem.stock != 0) {
              var availableQty = catItem.stock - orderItem.orderedQuantity;
              catItem.stock = availableQty;
              catItem.productUpdatedTime = DateTime.now();
              await cat.save();
            }
          }
        }
      }
    }
  }
}
