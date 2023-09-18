class ThemeResponse {
  ThemeResponse({
    required this.message,
  });
  late final Message message;
  
  ThemeResponse.fromJson(Map<String, dynamic> json){
    message = Message.fromJson(json['message']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['message'] = message.toJson();
    return _data;
  }
}

class Message {
  Message({
    required this.data,
  });
  late final ColorsData data;
  
  Message.fromJson(Map<String, dynamic> json){
    data = ColorsData.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    return _data;
  }
}

class ColorsData {
  ColorsData({
    required this.primary,
    required this.secondary,
    required this.asset,
  });
  late final String primary;
  late final String secondary;
  late final String asset;
  
  ColorsData.fromJson(Map<String, dynamic> json){
    primary = json['primary'];
    secondary = json['secondary'];
    asset = json['asset'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['primary'] = primary;
    _data['secondary'] = secondary;
    _data['asset'] = asset;
    return _data;
    
  }
}