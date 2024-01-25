import 'dart:developer';
import 'package:hive/hive.dart';
import 'package:nb_posx/core/mobile/create_order_new/ui/widget/calculate_taxes.dart';
import 'package:nb_posx/database/models/order_item.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';
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


  Future<int> deleteTaxes() async {
    box = await Hive.openBox<Taxes>(TAX_BOX);
    return box.clear();
  }

  
//to save tax list in db for itemwise taxation
  Future<List> saveItemWiseTax(orderId, List<Taxes> list) async {
    box = await Hive.openBox<Taxes>(TAX_BOX);
    for (Taxes item in list) {
      await box.put(item.itemTaxTemplate, item);
    }
    
    return list;
  }

   Future<List<Taxes>> getItemWiseTax(String orderId) async {
  var box = await Hive.openBox<Taxes>(TAX_BOX);

  // Assuming you have stored the itemTaxTemplate as the key for each item
  List<Taxes> taxList = box.values.where((tax) => tax.itemTaxTemplate == orderId).toList();

  return taxList;
}
//  Future<List<Taxes>> getItemWiseTax(String orderId ) async {
//   var box = await Hive.openBox<Taxes>(TAX_BOX);

//   // Assuming itemTaxTemplate contains order information
//   List<Taxes> taxList = box.values.where((tax) => tax.itemTaxTemplate.contains(orderId)).toList();

//   return taxList;
// }


}
