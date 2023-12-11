import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/models/customer.dart';
import 'package:nb_posx/database/models/sale_order.dart';
import 'package:path_provider/path_provider.dart';

import 'db_constants.dart';

///[DBPreferences] class to save the user preferences.
///We can save the preference as key - value pair.
class DBPreferences {
  Box? prefBox;

  ///Function to save the preference into database.
  ///[key] -> Unique key to identify the value saved into database.
  ///NOTE : if [key] is not unique then it is replaced by existing one.
  ///[value] -> Data for the defined [key].
  Future<void> savePreference(String key, dynamic value) async {
    //Open the PreferenceBox
    await openPreferenceBox();
    //Saving preference data into PreferenceBox database
    await prefBox!.put(key, value);
    //Close the PreferenceBox
    _closePreferenceBox();
  }

  ///Function to get the saved user preference in database.
  ///[key] -> Unique key to be supplied to get the saved value.
  ///If key not exist then it will return blank string.
  Future<dynamic> getPreference(String key) async {
    //Open the PreferenceBox
    await openPreferenceBox();
    //Getting value by key.
    dynamic value = prefBox!.get(key, defaultValue: '');
    //Close the PreferenceBox
    _closePreferenceBox();
    //Return the value
    return value;
  }

  ///Open the PreferenceBox
  openPreferenceBox() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    prefBox = await Hive.openBox(PREFERENCE_BOX, path: path);
    // prefBox = await Hive.openBox(PREFERENCE_BOX);
  }

  ///Close the PreferenceBox
  _closePreferenceBox() async {
    //await prefBox!.close();
  }

  Future<void> delete() async {
    prefBox = await Hive.openBox(PREFERENCE_BOX);
    await prefBox!.clear();
    await prefBox!.close();
  }

  // Future<void> deleteTranscationData() async {
  //   prefBox = await Hive.openBox(CUSTOMER_BOX);
  //   await prefBox!.clear();
  //   await prefBox!.close();
  //   prefBox = await Hive.openBox(SALE_ORDER_BOX);
  //   await prefBox!.clear();
  //   await prefBox!.close();
  // }

  Future<void> deleteTransactionData() async {
  // Open and clear the "customers" box
  var customerBox = await Hive.openBox<Customer>(CUSTOMER_BOX);
  await customerBox.clear();
  await customerBox.close();

  // Open and clear the "sale_orders" box
  var saleOrderBox = await Hive.openBox<SaleOrder>(SALE_ORDER_BOX);
  await saleOrderBox.clear();
  await saleOrderBox.close();
}


  Future<int> incrementOrderNo(String orderId) async {
    prefBox = await Hive.openBox(PREFERENCE_BOX);
    var list = orderId.split("-");
    //String orderNo = list.last;
    String orderNo = list.elementAt(list.indexOf(list.last) - 1);
    if (orderNo.isEmpty) orderNo = "0001";
    int newOrderNo = int.parse(orderNo) + 1;
    await savePreference(CURRENT_ORDER_NUMBER, "$newOrderNo");
    return newOrderNo;
  }
}
