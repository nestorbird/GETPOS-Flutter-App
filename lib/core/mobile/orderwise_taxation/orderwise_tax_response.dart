import 'dart:convert';
OrderWiseTaxation orderWiseTaxationFromJson(String str) =>
    OrderWiseTaxation.fromJson(json.decode(str));
String orderWiseTaxationToJson(OrderWiseTaxation data) =>
    json.encode(data.toJson());
class OrderWiseTaxation {
  List<Message> message;
  OrderWiseTaxation({
    required this.message,
  });
  factory OrderWiseTaxation.fromJson(Map<String, dynamic> json) =>
      OrderWiseTaxation(
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
      };
}
class Message {
  String name;
  String title;
  int isDefault;
  int disabled;
  String company;
  String taxCategory;
  List<Tax> tax;
  Message({
    required this.name,
    required this.title,
    required this.isDefault,
    required this.disabled,
    required this.company,
    required this.taxCategory,
    required this.tax,
  });
  factory Message.fromJson(Map<String, dynamic> json) => Message(
        name: json["name"],
        title: json["title"],
        isDefault: json["is_default"],
        disabled: json["disabled"],
        company: json["company"],
        taxCategory: json["tax_category"],
        tax: List<Tax>.from(json["tax"].map((x) => Tax.fromJson(x))),
      );
  Map<String, dynamic> toJson() => {
        "name": name,
        "title": title,
        "is_default": isDefault,
        "disabled": disabled,
        "company": company,
        "tax_category": taxCategory,
        "tax": List<dynamic>.from(tax.map((x) => x.toJson())),
      };
}
class Tax {
  String name;
  String taxId;
  String itemTaxTemplate;
  String chargeType;
  String taxType;
  String description;
  String costDenter;
  double taxRate;
  dynamic accountCurrency;
  double taxAmount;
  double total;
  Tax({
    required this.name,
    required this.taxId,
    required this.itemTaxTemplate,
    required this.chargeType,
    required this.taxType,
    required this.description,
    required this.costDenter,
    required this.taxRate,
    required this.accountCurrency,
    required this.taxAmount,
    required this.total,
  });
  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        name: json["name"],
        taxId: json["taxId"],
        itemTaxTemplate: json["item_tax_template"],
        chargeType: json["charge_type"],
        taxType: json["tax_type"],
        description: json["description"],
        costDenter: json["cost_denter"],
        taxRate: json["tax_rate"],
        accountCurrency: json["account_currency"],
        taxAmount: json["tax_amount"],
        total: json["total"],
      );
  Map<String, dynamic> toJson() => {
        "name": name,
        "item_tax_template": itemTaxTemplate,
        "charge_type": chargeType,
        "tax_type": taxType,
        "description": description,
        "cost_denter": costDenter,
        "tax_rate": taxRate,
        "account_currency": accountCurrency,
        "tax_amount": taxAmount,
        "total": total,
      };
}














