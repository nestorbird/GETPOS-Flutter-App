class SalesOrderResponse {
  Message? message;

  SalesOrderResponse({this.message});

  SalesOrderResponse.fromJson(Map<String, dynamic> json) {
    message =
        json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  int? successKey;
  String? message;
  List<OrderList>? orderList;
  int? numberOfOrders;

  Message({this.successKey, this.message, this.orderList, this.numberOfOrders});

  Message.fromJson(Map<String, dynamic> json) {
    successKey = json['success_key'];
    message = json['message'];
    if (json['order_list'] != null) {
      orderList = <OrderList>[];
      json['order_list'].forEach((v) {
        orderList!.add(OrderList.fromJson(v));
      });
    }
    numberOfOrders = json['number_of_orders'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success_key'] = successKey;
    data['message'] = message;
    if (orderList != null) {
      data['order_list'] = orderList!.map((v) => v.toJson()).toList();
    }
    data['number_of_orders'] = numberOfOrders;
    return data;
  }
}

class OrderList {
  String? name;
  String? transactionDate;
  String? transactionTime;
  String? ward;
  String? customer;
  String? customerName;
  String? hubManager;
  double? grandTotal;
  String? modeOfPayment;
  String? mpesaNo;
  String? contactName;
  String? contactPhone;
  String? contactMobile;
  String? contactEmail;
  String? creation;
  String? hubManagerName;
  String? image;
  List<Items>? items;

  OrderList(
      {this.name,
      this.transactionDate,
      this.transactionTime,
      this.ward,
      this.customer,
      this.customerName,
      this.hubManager,
      this.grandTotal,
      this.modeOfPayment,
      this.mpesaNo,
      this.contactName,
      this.contactPhone,
      this.contactMobile,
      this.contactEmail,
      this.creation,
      this.hubManagerName,
      this.image,
      this.items});

  OrderList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    transactionDate = json['transaction_date'];
    transactionTime = json['transaction_time'];
    ward = json['ward'];
    customer = json['customer'];
    customerName = json['customer_name'];
    hubManager = json['hub_manager'];
    grandTotal = json['grand_total'];
    modeOfPayment = json['mode_of_payment'];
    mpesaNo = json['mpesa_no'];
    contactName = json['contact_name'] ?? json['customer_name'];
    contactPhone = json['contact_phone'] ?? json['customer_name'];
    contactMobile = json['contact_mobile'] ?? json['customer_name'];
    contactEmail = json['contact_email'] ?? json['customer_name'];
    creation = json['creation'];
    hubManagerName = json['hub_manager_name'];
    image = json['image'] ?? "";
    if (json['items'] != null) {
      items = <Items>[];
      json['items'].forEach((v) {
        items!.add(Items.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['transaction_date'] = transactionDate;
    data['transaction_time'] = transactionTime;
    data['ward'] = ward;
    data['customer'] = customer;
    data['customer_name'] = customerName;
    data['hub_manager'] = hubManager;
    data['grand_total'] = grandTotal;
    data['mode_of_payment'] = modeOfPayment;
    data['mpesa_no'] = mpesaNo;
    data['contact_name'] = contactName;
    data['contact_phone'] = contactPhone;
    data['contact_mobile'] = contactMobile;
    data['contact_email'] = contactEmail;
    data['creation'] = creation;
    data['hub_manager_name'] = hubManagerName;
    data['image'] = image;
    if (items != null) {
      data['items'] = items!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Items {
  String? itemCode;
  String? itemName;
  double? qty;
  String? uom;
  double? rate;
  double? amount;
  String? image;
  List<SubItems>? subItems;

  Items(
      {this.itemCode,
      this.itemName,
      this.qty,
      this.uom,
      this.rate,
      this.amount,
      this.image,
      this.subItems});

  Items.fromJson(Map<String, dynamic> json) {
    itemCode = json['item_code'];
    itemName = json['item_name'];
    qty = json['qty'];
    uom = json['uom'];
    rate = json['rate'];
    amount = json['amount'];
    image = json['image'];
    if (json['sub_items'] != null) {
      subItems = <SubItems>[];
      json['sub_items'].forEach((v) {
        subItems!.add(SubItems.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_code'] = itemCode;
    data['item_name'] = itemName;
    data['qty'] = qty;
    data['uom'] = uom;
    data['rate'] = rate;
    data['amount'] = amount;
    data['image'] = image;
    if (subItems != null) {
      data['sub_items'] = subItems!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubItems {
  String? itemCode;
  String? itemName;
  double? qty;
  String? uom;
  double? rate;
  double? amount;
  double? tax;
  String? associatedItem;
  String? image;

  SubItems(
      {this.itemCode,
      this.itemName,
      this.qty,
      this.uom,
      this.rate,
      this.amount,
      this.tax,
      this.associatedItem,
      this.image});

  SubItems.fromJson(Map<String, dynamic> json) {
    itemCode = json['item_code'];
    itemName = json['item_name'];
    qty = json['qty'];
    uom = json['uom'];
    rate = json['rate'];
    amount = json['amount'];
    tax = json['tax'] ?? 0.0;
    associatedItem = json['associated_item'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_code'] = itemCode;
    data['item_name'] = itemName;
    data['qty'] = qty;
    data['uom'] = uom;
    data['rate'] = rate;
    data['amount'] = amount;
    data['tax'] = tax;
    data['associated_item'] = associatedItem;
    data['image'] = image;
    return data;
  }
}
