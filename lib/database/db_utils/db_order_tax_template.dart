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

    for (var item in box.values) {
      var tax = item as OrderTaxTemplate;

      // if (product.stock > 0 && product.price > 0 && tax.tax > 0) {
      list.add(tax);
      // }
    }
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
