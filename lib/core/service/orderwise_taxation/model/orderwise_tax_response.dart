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
  List<Taxes> tax;
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
        tax: List<Taxes>.from(json["tax"].map((x) => Taxes.fromJson(x))),
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

class Taxes {
  String name;

  String itemTaxTemplate;
  String chargeType;
  String taxType;
  String description;
  String costDenter;
  double taxRate;
  dynamic accountCurrency = "";
  double taxAmount;
  double total;
  Taxes({
    required this.name,
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
  factory Taxes.fromJson(Map<String, dynamic> json) => Taxes(
        name: json["name"],
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
