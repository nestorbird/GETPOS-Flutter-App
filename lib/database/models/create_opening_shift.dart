import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:nb_posx/database/models/balance_details.dart';

part 'create_opening_shift.g.dart';

@HiveType(typeId: 0)
class CreateOpeningShiftDb extends HiveObject {
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
  late int idx;

  @HiveField(6)
  late int docstatus;

  @HiveField(7)
  late String periodStartDate;

  @HiveField(8)
  late String status;

  @HiveField(9)
  late String postingDate;

  @HiveField(10)
  late int setPostingDate;

  @HiveField(11)
  late String company;

  @HiveField(12)
  late String posProfile;

  @HiveField(13)
  late String user;

  @HiveField(14)
  late String doctype;

  @HiveField(15)
  late List<BalanceDetail> balanceDetails;

  CreateOpeningShiftDb({
    required this.name,
    required this.owner,
    required this.creation,
    required this.modified,
    required this.modifiedBy,
    required this.idx,
    required this.docstatus,
    required this.periodStartDate,
    required this.status,
    required this.postingDate,
    required this.setPostingDate,
    required this.company,
    required this.posProfile,
    required this.user,
    required this.doctype,
    required this.balanceDetails,
  });

  factory CreateOpeningShiftDb.fromJson(Map<String, dynamic> json) {
    return CreateOpeningShiftDb(
      name: json['name'],
      owner: json['owner'],
      creation: json['creation'],
      modified: json['modified'],
      modifiedBy: json['modified_by'],
      idx: json['idx'],
      docstatus: json['docstatus'],
      periodStartDate: json['period_start_date'],
      status: json['status'],
      postingDate: json['posting_date'],
      setPostingDate: json['set_posting_date'],
      company: json['company'],
      posProfile: json['pos_profile'],
      user: json['user'],
      doctype: json['doctype'],
      balanceDetails: List<BalanceDetail>.from(
        json['balance_details'].map((x) => BalanceDetail.fromJson(x)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'owner': owner,
      'creation': creation,
      'modified': modified,
      'modified_by': modifiedBy,
      'idx': idx,
      'docstatus': docstatus,
      'period_start_date': periodStartDate,
      'status': status,
      'posting_date': postingDate,
      'set_posting_date': setPostingDate,
      'company': company,
      'pos_profile': posProfile,
      'user': user,
      'doctype': doctype,
      'balance_details': List<dynamic>.from(balanceDetails.map((x) => x.toJson())),
    };
  }
}

