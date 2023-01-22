import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../db_utils/db_constants.dart';
import 'option.dart';
part 'attribute.g.dart';

@HiveType(typeId: AttributeBoxTypeId)
class Attribute extends HiveObject {
  @HiveField(0)
  String name;

  @HiveField(1)
  String type;

  @HiveField(2)
  List<Option> options;

  @HiveField(3, defaultValue: 0)
  int moq;

  Attribute({
    required this.name,
    required this.type,
    required this.moq,
    required this.options,
  });

  Attribute copyWith({
    String? name,
    String? type,
    int? moq,
    List<Option>? options,
    double? tax,
  }) {
    return Attribute(
      name: name ?? this.name,
      type: type ?? this.type,
      moq: moq ?? this.moq,
      options: options ?? this.options,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'moq': moq,
      'options': options.map((x) => x.toMap()).toList(),
    };
  }

  factory Attribute.fromMap(Map<String, dynamic> map) {
    return Attribute(
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      moq: map['moq'] ?? 0,
      options: List<Option>.from(map['options']?.map((x) => Option.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory Attribute.fromJson(String source) =>
      Attribute.fromMap(json.decode(source));

  @override
  String toString() =>
      'Attribute(name: $name, moq: $moq type: $type, options: $options)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Attribute &&
        other.name == name &&
        other.type == type &&
        other.moq == moq &&
        listEquals(other.options, options);
  }

  @override
  int get hashCode => name.hashCode ^ type.hashCode ^ options.hashCode;
}
