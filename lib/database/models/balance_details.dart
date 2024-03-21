import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:nb_posx/database/db_utils/db_constants.dart';

part 'balance_details.g.dart';

@HiveType(typeId: BalanceDetailsBoxId)
class BalanceDetail extends HiveObject {
  @HiveField(0)
  late String name;

  @HiveField(1)
  late String owner;

  @HiveField(2)
  late String creation;

  @HiveField(3)
  late String modified;

  @HiveField(4)
  late String modifiedBy;

  @HiveField(5)
  late String parent;

  @HiveField(6)
  late String parentField;

  @HiveField(7)
  late String parentType;

  @HiveField(8)
  late int idx;

  @HiveField(9)
  late int docstatus;

  @HiveField(10)
  late String modeOfPayment;

  @HiveField(11)
  late int amount;

  @HiveField(12)
  late String doctype;

  BalanceDetail({
    required this.name,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.parent,
    required this.parentField,
    required this.parentType,
    required this.idx,
    required this.docstatus,
    required this.modeOfPayment,
    required this.amount,
    required this.doctype,
  });

  factory BalanceDetail.fromJson(Map<String, dynamic> json) {
    return BalanceDetail(
      name: json['name'],
      owner: json['owner'],
      creation: json['creation'],
      modified: json['modified'],
      modifiedBy: json['modified_by'],
      parent: json['parent'],
      parentField: json['parentfield'],
      parentType: json['parenttype'],
      idx: json['idx'],
      docstatus: json['docstatus'],
      modeOfPayment: json['mode_of_payment'],
      amount: json['amount'],
      doctype: json['doctype'],
    );
  }

   Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner': owner,
      'creation': creation,
      'modified': modified,
      'modified_by': modifiedBy,
      'parent': parent,
      'parentfield': parentField,
      'parenttype': parentType,
      'idx': idx,
      'docstatus': docstatus,
      'mode_of_payment': modeOfPayment,
      'amount': amount,
      'doctype': doctype,
    };
  }
}
