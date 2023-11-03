import 'dart:developer';


import 'package:hive/hive.dart';
import 'package:nb_posx/core/mobile/create_order_new/ui/widget/calculate_taxes.dart';
import 'package:nb_posx/database/models/order_item.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';
import 'package:nb_posx/database/models/taxes.dart';

import 'db_constants.dart';

class DbOrderTax {
  late Box box;

  Future<void> addOrderTaxes(List<OrderTax> lists) async {
    box = await Hive.openBox<OrderTax>(ORDERTAX_BOX);
    for (OrderTax item in lists) {
      await box.put(item.taxId, item);
    }
  }

 

  Future<List<OrderTax>> getOrderTaxes() async {
    box = await Hive.openBox<OrderTax>(ORDERTAX_BOX);
    List<OrderTax> list = [];

    for (var item in box.values) {
      var tax = item as OrderTax;
     
      var product = item as OrderItem;

      if (product.stock > 0 && product.price > 0 && tax.taxRate > 0) {
        list.add(tax);
      }
    }
    return list;
  }

 

 

  Future<int> deleteTaxes() async {
    box = await Hive.openBox<OrderTax>(ORDERTAX_BOX);
    return box.clear();
  }

   

//to save tax list in db for orderwise taxation
  Future<List> saveOrderWiseTax(orderId, List<OrderTaxes> list) async {
    box = await Hive.openBox<OrderTaxes>(ORDERTAX_BOX);
    for (OrderTaxes item in list) {
      await box.put(item.id, item);
    }

    return list;
  }
}
