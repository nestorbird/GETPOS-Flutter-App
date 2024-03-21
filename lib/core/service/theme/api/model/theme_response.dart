import 'dart:developer';

import 'package:get/get.dart';

class ThemeResponse {
  ThemeResponse({
    required this.message,
  });
  late final Message message;

  ThemeResponse.fromJson(Map<String, dynamic> json) {
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

  Message.fromJson(Map<String, dynamic> json) {
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

  ColorsData.fromJson(Map<String, dynamic> json) {
    primary = json['primary'] != null && json['primary'] != ""
        ? json['primary']
        : "#DC1E44";
    secondary = json['secondary'] != null && json['secondary'] != ""
        ? json['secondary']
        : "#62B146";
    asset = json['asset'] != null && json['asset'] != ""
        ? json['asset']
        : "#707070";
    textandCancelIcon = json['text_and_cancel_icon'] != null &&
            json['text_and_cancel_icon'] != ""
        ? json['text_and_cancel_icon']
        : "#000000";
    shadowBorder = json['shadow_border'] != null && json['shadow_border'] != ""
        ? json['shadow_border']
        : "#C7C5C5";
    hintText = json['hint_text'] != null && json['hint_text'] != ""
        ? json['hint_text']
        : "#F3F2F5";
    fontWhiteColor =
        json['font_white_color'] != null && json['font_white_color'] != ""
            ? json['font_white_color']
            : "#FFFFFF";
    parkOrderButton =
        json['park_order_button'] != null && json['park_order_button'] != ""
            ? json['park_order_button']
            : "#4A4A4A";
    active = json['active'] != null && json['active'] != ""
        ? json['active']
        : "#FEF9FA";
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
