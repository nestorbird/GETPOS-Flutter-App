import 'package:hive_flutter/hive_flutter.dart';
import 'package:nb_posx/database/models/taxes.dart';

class Taxation extends HiveObject {
  String id, itemTaxTemplate, taxType;
  double taxRate, taxationAmount;
  Taxation(
      {required this.id,
      required this.itemTaxTemplate,
      required this.taxType,
      required this.taxRate,
      required this.taxationAmount});
}

class OrderTaxes extends HiveObject {
  String id, itemTaxTemplate, taxType;
  double taxRate, taxationAmount;
  OrderTaxes(
      {required this.id,
      required this.itemTaxTemplate,
      required this.taxType,
      required this.taxRate,
      required this.taxationAmount});
}
