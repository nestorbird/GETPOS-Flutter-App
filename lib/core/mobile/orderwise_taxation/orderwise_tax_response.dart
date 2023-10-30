// To parse this JSON data, do
//
//     final orderwiseTaxationResponse = orderwiseTaxationResponseFromJson(jsonString);

import 'dart:convert';

OrderwiseTaxationResponse orderwiseTaxationResponseFromJson(String str) => OrderwiseTaxationResponse.fromJson(json.decode(str));

String orderwiseTaxationResponseToJson(OrderwiseTaxationResponse data) => json.encode(data.toJson());

class OrderwiseTaxationResponse {
    List<Message> message;

    OrderwiseTaxationResponse({
        required this.message,
    });

    factory OrderwiseTaxationResponse.fromJson(Map<String, dynamic> json) => OrderwiseTaxationResponse(
        message: List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
    };
}

class Message {
    String name;
   
    int isDefault;
    int disabled;
   
    String taxCategory;
    List<Tax> tax;

    Message({
        required this.name,
        
        required this.isDefault,
        required this.disabled,
   
        required this.taxCategory,
        required this.tax,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        name: json["name"],
       
        isDefault: json["is_default"],
        disabled: json["disabled"],
        
        taxCategory: json["tax_category"],
        tax: List<Tax>.from(json["tax"].map((x) => Tax.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        
        "is_default": isDefault,
        "disabled": disabled,
        
        "tax_category": taxCategory,
        "tax": List<dynamic>.from(tax.map((x) => x.toJson())),
    };
}

class Tax {
    String itemTaxTemplate;
   
    String taxType;

    
    double taxRate;
   
     
    int total;

    Tax({
        required this.itemTaxTemplate,
       
        required this.taxType,
    

        required this.taxRate,
        
       
        required this.total,
    });

    factory Tax.fromJson(Map<String, dynamic> json) => Tax(
        itemTaxTemplate: json["name"],
        
        taxType: json["account_head"],
       
       
        taxRate: json["rate"],
       
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "name": itemTaxTemplate,
        
        "account_head": taxType,
        
        "rate": taxRate,
      
        "total": total,
    };
}
