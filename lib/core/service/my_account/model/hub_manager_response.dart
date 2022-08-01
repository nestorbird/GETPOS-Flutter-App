import 'dart:convert';

class HubManagerResponse {
  String name;
  String email;
  String phone;
  double cashBalance;

  HubManagerResponse({
    required this.name,
    required this.email,
    required this.phone,
    required this.cashBalance,
  });

  HubManagerResponse copyWith({
    String? name,
    String? email,
    String? phone,
    double? cashBalance,
  }) {
    return HubManagerResponse(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cashBalance: cashBalance ?? this.cashBalance,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'cashBalance': cashBalance,
    };
  }

  factory HubManagerResponse.fromMap(Map<String, dynamic> map) {
    return HubManagerResponse(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      cashBalance: map['cashBalance'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HubManagerResponse.fromJson(String source) =>
      HubManagerResponse.fromMap(json.decode(source));

  @override
  String toString() {
    return 'HubManagerResponse(name: $name, email: $email, phone: $phone, cashBalance: $cashBalance, wards: )';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HubManagerResponse &&
        other.name == name &&
        other.email == email &&
        other.phone == phone &&
        other.cashBalance == cashBalance;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        cashBalance.hashCode;
  }
}
