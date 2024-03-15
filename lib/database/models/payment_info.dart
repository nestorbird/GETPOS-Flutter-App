import 'package:hive/hive.dart';

part 'payment_info.g.dart';

@HiveType(typeId: 1) // Provide a unique typeId for Hive
class PaymentInfo {
  @HiveField(0)
  final String paymentType;

  @HiveField(1)
  final String amount;

  PaymentInfo({required this.paymentType, required this.amount});

  Map<String, dynamic> toMap() {
    return {
      'paymentType': paymentType,
      'amount': amount,
    };
  }

  factory PaymentInfo.fromMap(Map<String, dynamic> map) {
    return PaymentInfo(
      paymentType: map['paymentType'],
      amount: map['amount'],
    );
  }
}
