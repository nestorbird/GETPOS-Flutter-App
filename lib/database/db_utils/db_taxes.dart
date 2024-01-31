import 'package:hive/hive.dart';
import 'package:nb_posx/core/mobile/create_order_new/ui/widget/calculate_taxes.dart';
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
    box.close();
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

  Future<int> deleteTaxes() async {
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
   
    return list;
  }

//to save tax list in db for itemwise taxation
  Future<List> saveItemWiseTax(orderId, List<Taxation> list) async {
    box = await Hive.openBox<Taxation>(TAX_BOX);
    for (Taxation item in list) {
      await box.put(item.id, item);
    }
    
    return list;
  }
}
