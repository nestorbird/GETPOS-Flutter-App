import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/shift_management.dart';

import '../models/payment_type.dart';
import '../models/pos_profile_cashier.dart';

class DbShiftManagement {
  late Box box;

  Future<void> createShiftManagement(
      List<PosProfileCashier> cashier, List<PaymentType> paymentMethods) async {
    box = await Hive.openBox<ShiftManagement>(SHIFT_MANAGEMENT_BOX);

    //query

    //  await box.put( )
  }
}
