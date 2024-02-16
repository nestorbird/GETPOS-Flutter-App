import 'package:hive/hive.dart';
import 'package:nb_posx/core/mobile/create_order_new/ui/widget/calculate_taxes.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';

class DbSaleOrderRequest {
  late Box box;
  Future<List> saveOrderWiseTax(orderId, List<OrderTaxes> list) async {
    box = await Hive.openBox<OrderTaxes>(SALES_ORDER_REQUEST_BOX);
    for (OrderTaxes item in list) {
      await box.put(item.id, item);
    }

    return list;
  }
}
