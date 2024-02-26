import 'package:hive/hive.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';

import 'db_constants.dart';

class DbOrderTax {
  late Box box;

  Future<void> addOrderTaxes(List<OrderTax> lists) async {
    box = await Hive.openBox<OrderTax>(ORDERTAX_BOX);
    for (OrderTax item in lists) {
      await box.put(item.taxType, item);
    }
  }

  

  Future<int> deleteTaxes() async {
    box = await Hive.openBox<OrderTax>(ORDERTAX_BOX);
    return box.clear();
  }

//to save tax list in db for orderwise taxation
  Future<List>? saveOrderWiseTax(String orderId, List<OrderTax> list) async {
    box = await Hive.openBox<List>(ORDERWISE_TAX_BOX);
    
    await box.put(orderId, list);
   
    return list;
  }

  //to fetch the Orderwise tax list
  Future<List<OrderTax>>? getOrderWiseTax(String orderId) async {
    final box = await Hive.openBox<List>(ORDERWISE_TAX_BOX);
    
    var orderTaxesList = box.get(orderId);
    if(orderTaxesList == null || orderTaxesList.isEmpty) {
      return List<OrderTax>.empty();
    }
    var list = orderTaxesList.cast<OrderTax>(); 
    return list;
  }

 Future<void> clearOrderTaxes() async {
  box = await Hive.openBox<OrderTax>(ORDERTAX_BOX);

  // Iterate through the keys in the box and remove each item
  final keys = box.keys;
  for (var key in keys) {
    await box.delete(key);
  }
}
}