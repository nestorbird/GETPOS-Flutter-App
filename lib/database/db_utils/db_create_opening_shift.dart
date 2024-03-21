import 'dart:developer';

import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';
import 'package:nb_posx/database/models/create_opening_shift.dart';
import 'package:nb_posx/database/models/payment_info.dart';
import 'package:nb_posx/database/models/shift_management.dart';

import '../models/payment_type.dart';
import '../models/pos_profile_cashier.dart';

class DbCreateShift{
  late Box box;

///CREATE THE SHIFT OF SELECTED POS PROFILE
  Future<void> createShift(CreateOpeningShiftDb createShift) async {
    // Open the Hive box
    var box = await Hive.openBox<CreateOpeningShiftDb>(CREATE_SHIFT_BOX);

    // Save the shift management data
    await box.put('shift', createShift);

    // Close the Hive box
    await box.close();
  }
///DELETE THE SHIFT THAT HAS BEEN CREATED
Future<int> deleteShift() async {
    box = await Hive.openBox<CreateOpeningShiftDb>(CREATE_SHIFT_BOX);
    return box.clear();
  }

///FETCH THE DATA OF POS PROFILE 
Future<CreateOpeningShiftDb?> getOpeningShiftData() async {
  var box = await Hive.openBox<CreateOpeningShiftDb>(CREATE_SHIFT_BOX);
  var shiftData = box.get('shift');
  return shiftData;
}
}


