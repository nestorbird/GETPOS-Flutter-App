import 'dart:convert';

class CashbalanceRequest {
  double cashBalance;
  CashbalanceRequest({
    required this.cashBalance,
  });

  CashbalanceRequest copyWith({
    double? cashBalance,
  }) {
    return CashbalanceRequest(
      cashBalance: cashBalance ?? this.cashBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'cashBalance': cashBalance,
    };
  }

  factory CashbalanceRequest.fromMap(Map<String, dynamic> map) {
    return CashbalanceRequest(
      cashBalance: map['cashBalance'],
    );
  }

  String toJson() => json.encode(toMap());

  factory CashbalanceRequest.fromJson(String source) =>
      CashbalanceRequest.fromMap(json.decode(source));

  @override
  String toString() => 'CashbalanceRequest(cashBalance: $cashBalance)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CashbalanceRequest && other.cashBalance == cashBalance;
  }

  @override
  int get hashCode => cashBalance.hashCode;
}
