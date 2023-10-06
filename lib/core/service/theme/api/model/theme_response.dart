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
    required this.textandCancelIcon,
    required this.shadowBorder,
    required this.hintText,
     required this.fontWhiteColor,
    required this.parkOrderButton,
    required this.active,
    
  });
  late final String primary;
  late final String secondary;
  late final String asset;
  late final String textandCancelIcon;
  late final String shadowBorder;
  late final String hintText;
   late final String fontWhiteColor;
  late final String parkOrderButton;
  late final String active;
  
  
  ColorsData.fromJson(Map<String, dynamic> json){
    primary = json['primary'];
    secondary = json['secondary'];
    asset = json['asset'];
    asset = json['textandCancelIcon'];
    asset = json['shadowBorder'];
    asset = json['hintText'];
     asset = json['fontWhiteColor'];
    asset = json['parkOrderButton'];
    asset = json['active'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['primary'] = primary;
    _data['secondary'] = secondary;
    _data['asset'] = asset;
    _data['textandCancelIcon'] = textandCancelIcon;
    _data['shadowBorder'] = shadowBorder;
    _data['hintText'] = hintText;
    _data['fontWhiteColor'] = fontWhiteColor;
    _data['parkOrderButton'] = parkOrderButton;
    _data['active'] = active;
    return _data;
    
  }
}