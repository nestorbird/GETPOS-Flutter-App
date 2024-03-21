import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:nb_posx/database/models/balance_details.dart';

import '../models/payment_type.dart';
import 'db_constants.dart';
///
///DB FOR STORE THE POS PROFILE CASHIER LOCALLY
///
class DbBalanceDetails {
  late Box box;
///
  /// ADD THE PAYMENT METHODS
  ///
  Future<void> addBalanceDetails(List<BalanceDetail> list) async {
    box = await Hive.openBox<BalanceDetail>(BALANCE_DETAILS_BOX);

    for (BalanceDetail balanceDetail in list) {
      await box.add(balanceDetail);
       log('Added box:$box');

    }
  }

}
