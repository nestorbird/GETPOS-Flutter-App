class CreateSalesOrderResponse {
  CreateSalesOrderResponse({
    required this.message,
  });
  late final Message message;

  CreateSalesOrderResponse.fromJson(Map<String, dynamic> json) {
    message = Message.fromJson(json['message']);
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['message'] = message.toJson();
    return data;
  }
}

class Message {
  Message({
    required this.successKey,
    required this.message,
    required this.salesOrder,
  });
  late final int successKey;
  late final String message;
  late final SalesOrder salesOrder;

  Message.fromJson(Map<String, dynamic> json) {
    successKey = json['success_key'];
    message = json['message'];
    salesOrder = SalesOrder.fromJson(json['sales_order'] ?? {});
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['success_key'] = successKey;
    data['message'] = message;
    data['sales_order'] = salesOrder.toJson();
    return data;
  }
}

class SalesOrder {
  SalesOrder({
    required this.name,
    required this.docStatus,
  });
  late final String name;
  late final int docStatus;

  SalesOrder.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    docStatus = json['doc_status'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    data['doc_status'] = docStatus;
    return data;
  }
}
