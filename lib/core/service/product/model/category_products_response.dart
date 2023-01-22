class CategoryProductsResponse {
  List<Message>? message;

  CategoryProductsResponse({this.message});

  CategoryProductsResponse.fromJson(Map<String, dynamic> json) {
    if (json['message'] != null) {
      message = <Message>[];
      json['message'].forEach((v) {
        message!.add(Message.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Message {
  String? itemGroup;
  List<Items>? items;
  String? itemGroupImage;

  Message({this.itemGroup, this.items, this.itemGroupImage});

  Message.fromJson(Map<String, dynamic> json) {
    itemGroup = json['item_group'];
    itemGroupImage = json['item_group_image'];
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_group'] = itemGroup;
    data['item_group_image'] = itemGroupImage;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? id;
  String? name;
  List<Attributes>? attributes;
  String? image;
  List<Tax>? tax;
  double? productPrice;
  String? warehouse;
  double? stockQty;

  Items(
      {this.id,
      this.name,
      this.attributes,
      this.image,
      this.tax,
      this.productPrice,
      this.warehouse,
      this.stockQty});

  Items.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(Attributes.fromJson(v));
      });
    }
    image = json['image'] ?? "";
    if (json['tax'] != null && json['tax'] != '') {
      tax = <Tax>[];
      json['tax'].forEach((v) {
        tax!.add(Tax.fromJson(v));
      });
    }
    productPrice = json['product_price'];
    warehouse = json['warehouse'];
    stockQty = json['stock_qty'] == 0 ? 0.0 : json['stock_qty'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (attributes != null) {
      data['attributes'] = attributes!.map((v) => v.toJson()).toList();
    }
    data['image'] = image;
    if (tax != null) {
      data['tax'] = tax!.map((v) => v.toJson()).toList();
    }
    data['product_price'] = productPrice;
    data['warehouse'] = warehouse;
    data['stock_qty'] = stockQty;
    return data;
  }
}

class Attributes {
  String? name;
  String? type;
  int? moq;
  List<Options>? options;

  Attributes({this.name, this.type, this.moq, this.options});

  Attributes.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    moq = json['moq'];
    if (json['options'] != null) {
      options = <Options>[];
      json['options'].forEach((v) {
        options!.add(Options.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['moq'] = moq;
    if (options != null) {
      data['options'] = options!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Options {
  String? id;
  String? name;
  List<Tax>? tax;
  double? price;
  bool? selected;
  String? warehouse;
  double? stockQty;

  Options(
      {this.id,
      this.name,
      this.tax,
      this.price,
      this.selected,
      this.warehouse,
      this.stockQty});

  Options.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['tax'] != null && json['tax'] != '') {
      tax = <Tax>[];
      json['tax'].forEach((v) {
        tax!.add(Tax.fromJson(v));
      });
    }
    price = json['price'] == "" ? 0.0 : json['price'];
    selected = json['selected'];
    warehouse = json['warehouse'];
    stockQty = double.tryParse(json['stock_qty'].toString());
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (tax != null) {
      data['tax'] = tax!.map((v) => v.toJson()).toList();
    }
    data['price'] = price;
    data['selected'] = selected;
    data['warehouse'] = warehouse;
    data['stock_qty'] = stockQty;
    return data;
  }
}

class Tax {
  String? itemTaxTemplate;
  double? taxRate;

  Tax({this.itemTaxTemplate, this.taxRate});

  Tax.fromJson(Map<String, dynamic> json) {
    itemTaxTemplate = json['item_tax_template'] ?? "";
    taxRate = json['tax_rate'] ?? 0.0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_tax_template'] = itemTaxTemplate;
    data['tax_rate'] = taxRate;
    return data;
  }
}
