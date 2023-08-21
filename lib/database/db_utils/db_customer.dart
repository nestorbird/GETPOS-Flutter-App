import 'package:hive_flutter/hive_flutter.dart';

import '../models/customer.dart';
import 'db_constants.dart';

class DbCustomer {
  late Box box;

  Future<void> addCustomers(List<Customer> list) async {
    box = await Hive.openBox<Customer>(CUSTOMER_BOX);
    for (Customer c in list) {
      await box.put(c.id, c);
    }
  }

  Future<List<Customer>> getCustomers() async {
    box = await Hive.openBox<Customer>(CUSTOMER_BOX);
    List<Customer> list = [];
    for (var item in box.values) {
      var customer = item as Customer;
      list.add(customer);
    }
    return list;
  }

  Future<List<Customer>> getOfflineCustomers() async {
    box = await Hive.openBox<Customer>(CUSTOMER_BOX);
    List<Customer> list = [];

    for (var key in box.keys) {
      var item = await box.get(key);
      var customer = item as Customer;
      if (customer.isSynced == false) list.add(customer);
    }

    return list;
  }

  Future<List<Customer>> getCustomer(String mobileNo) async {
    box = await Hive.openBox<Customer>(CUSTOMER_BOX);
    List<Customer> list = [];
    for (var item in box.values) {
      var customer = item as Customer;
      if (customer.phone == mobileNo) {
        list.add(customer);
      }
    }
    return list;
  }

  Future<List<Customer>> getCustomerNo(String mobileNo) async {
    box = await Hive.openBox<Customer>(CUSTOMER_BOX);
    List<Customer> list = [];
    for (var item in box.values) {
      var customer = item as Customer;
      if (customer.phone.contains(mobileNo)) {
        list.add(customer);
      }
    }
    return list;
  }

  Future<Customer?> getCustomerDetails(String key) async {
    box = await Hive.openBox<Customer>(CUSTOMER_BOX);
    return box.get(key);
  }

  Future<int> deleteCustomers() async {
    box = await Hive.openBox<Customer>(CUSTOMER_BOX);
    return box.clear();
  }

  Future<bool> deleteCustomer(String key) async {
    box = await Hive.openBox<Customer>(CUSTOMER_BOX);
    Customer? customer = box.get(key);
    if (customer != null) customer.delete();
    return true;
  }

  Future<void> updateCustomer(Customer customer) async {
    box = await Hive.openBox<Customer>(CUSTOMER_BOX);
    box.put(customer.id, customer);
  }

  // Future<int> deleteWardCustomer(String wardId) async {
  //   box = await Hive.openBox<Customer>(CUSTOMER_BOX);
  //   for (Customer customer in box.values) {
  //     if (customer.ward.id == wardId) customer.delete();
  //   }
  //   return 0;
  // }
}
