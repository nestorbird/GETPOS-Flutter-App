import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/order_item.dart';
import 'package:nb_posx/database/models/order_tax_template.dart';
import 'package:nb_posx/database/models/orderwise_tax.dart';

class DbOrderTaxTemplate {
  late Box box;

  Future<void> addOrderTaxes(List<OrderTaxTemplate> lists) async {
    box = await Hive.openBox<OrderTaxTemplate>(ORDERTAXTEMPLATE_BOX);
    for (OrderTaxTemplate item in lists) {
      await box.put(item.taxCategory, item);
    }
  }

  Future<List<OrderTaxTemplate>> getOrderTaxesTemplate() async {
    box = await Hive.openBox<OrderTaxTemplate>(ORDERTAXTEMPLATE_BOX);
    List<OrderTaxTemplate> list = [];

   
    box.values
        .where((item) => item.isDefault == 1 && item.disabled == 0)
        .forEach((item) => list.add(item));

    
    return list;
  }

  Future<int> deleteTaxes() async {
    box = await Hive.openBox<OrderTaxTemplate>(ORDERTAXTEMPLATE_BOX);
    return box.clear();
  }

// //to save tax list in db for orderwise taxation
//   Future<List> saveOrderWiseTax(orderId, List<OrderTaxTemplate> list) async {
//     box = await Hive.openBox<OrderTaxTemplate>(ORDERTAXTEMPLATE_BOX);
//     for (OrderTaxTemplate item in list) {
//       await box.put(item.id, item);
//     }

//     return list;
//   }
}
