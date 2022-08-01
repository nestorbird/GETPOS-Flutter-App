class ProductsResponse {
  late Message message;

  ProductsResponse({required this.message});

  ProductsResponse.fromJson(Map<String, dynamic> json) {
    message = Message.fromJson(json['message']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['message'] = message.toJson();

    return data;
  }
}

class Message {
  late int successKey;
  late String message;
  late List<ItemList> itemList;

  Message(
      {required this.successKey,
      required this.message,
      required this.itemList});

  Message.fromJson(Map<String, dynamic> json) {
    successKey = json['success_key'];
    message = json['message'];
    if (json['item_list'] != null) {
      itemList = [];
      json['item_list'].forEach((v) {
        itemList.add(ItemList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success_key'] = successKey;
    data['message'] = message;

    data['item_list'] = itemList.map((v) => v.toJson()).toList();

    return data;
  }
}

class ItemList {
  late String itemCode;
  late String itemName;
  late String itemGroup;
  late String description;
  late int hasVariants;
  late String variantBasedOn;
  String? image;
  late double priceListRate;
  late String itemModified;
  late String priceModified;
  late double availableQty;
  late String stockModified;

  ItemList(
      {required this.itemCode,
      required this.itemName,
      required this.itemGroup,
      required this.description,
      required this.hasVariants,
      required this.variantBasedOn,
      required this.image,
      required this.priceListRate,
      required this.itemModified,
      required this.priceModified,
      required this.availableQty,
      required this.stockModified});

  ItemList.fromJson(Map<String, dynamic> json) {
    itemCode = json['item_code'];
    itemName = json['item_name'];
    itemGroup = json['item_group'];
    description = json['description'];
    hasVariants = json['has_variants'];
    variantBasedOn = json['variant_based_on'];
    image = json['image'];
    priceListRate = json['price_list_rate'];
    itemModified = json['item_modified'];
    priceModified = json['price_modified'];
    availableQty = json['available_qty'];
    stockModified = json['stock_modified'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_code'] = itemCode;
    data['item_name'] = itemName;
    data['item_group'] = itemGroup;
    data['description'] = description;
    data['has_variants'] = hasVariants;
    data['variant_based_on'] = variantBasedOn;
    data['image'] = image;
    data['price_list_rate'] = priceListRate;
    data['item_modified'] = itemModified;
    data['price_modified'] = priceModified;
    data['available_qty'] = availableQty;
    data['stock_modified'] = stockModified;
    return data;
  }
}
