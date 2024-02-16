import 'package:hive/hive.dart';

import '../models/payment_type.dart';
import 'db_constants.dart';

class DbPaymentTypes {
  late Box box;

  Future<void> addPaymentMethod(List<PaymentType> list) async {
    box = await Hive.openBox<PaymentType>(PAYMENT_METHOD_BOX);

    for (PaymentType paymentType in list) {
      await box.put(paymentType.parent, paymentType);
    }
  }

  Future<List<PaymentType>> getPaymentMethod() async {
    box = await Hive.openBox<PaymentType>(PAYMENT_METHOD_BOX);
    List<PaymentType> list = [];
    for (var paymentType in box.values) {
      var paymentMethod = paymentType as PaymentType;
      list.add(paymentMethod);
    }
    return list;
  }

  Future<int> deletePaymentMethods() async {
    box = await Hive.openBox<PaymentType>(PAYMENT_METHOD_BOX);
    return box.clear();
  }
}
