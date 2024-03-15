import 'dart:developer';

import 'package:hive/hive.dart';

import '../models/payment_type.dart';
import 'db_constants.dart';
///
///DB FOR STORE THE POS PROFILE CASHIER LOCALLY
///
class DbPaymentTypes {
  late Box box;
///
  /// ADD THE PAYMENT METHODS
  ///
  Future<void> addPaymentMethod(List<PaymentType> list) async {
    box = await Hive.openBox<PaymentType>(PAYMENT_METHOD_BOX);

    for (PaymentType paymentType in list) {
      await box.add(paymentType);
       log('Added box:$box');

    }
  }


//  Future<List<PaymentType>> getPaymentMethods(String selectedProfile) async {
//   box = await Hive.openBox<PaymentType>(PAYMENT_METHOD_BOX);
//   List<PaymentType> list = [];
//   for (var paymentType in box.values) {
//     if (paymentType.parent == selectedProfile) {
//       list.add(paymentType); 
//     }
//   }
// log('BOX:${box.values}');
//   return list;
// }


///
  /// FETCH THE PAYMENT METHODS BY PARENT i.e selected pos profile
  ///
Future<List<PaymentType>> getPaymentMethodsbyParent(String selectedProfile) async {
    box = await Hive.openBox<PaymentType>(PAYMENT_METHOD_BOX);
    
    log('HIVE BOX: $box');
    List<PaymentType> paymentOptions = [];

   
    box.values
    
        .where((profile) => profile.parent == selectedProfile)
        .forEach((profile) => {
          log('Values:$profile'),
          paymentOptions.add(profile)
});

    log('BOX:${box.values}');
      log('LIST:$paymentOptions');
    return paymentOptions;
  }

}
