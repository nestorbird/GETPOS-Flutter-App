// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_tax_template.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderTaxTemplateAdapter extends TypeAdapter<OrderTaxTemplate> {
  @override
  final int typeId = 22;

  @override
  OrderTaxTemplate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderTaxTemplate(
      name: fields[0] as String,
      isDefault: fields[1] as int,
      disabled: fields[2] as int,
      taxCategory: fields[3] as String,
      tax: (fields[4] as List).cast<OrderTax>(),
    );
  }

  @override
  void write(BinaryWriter writer, OrderTaxTemplate obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.isDefault)
      ..writeByte(2)
      ..write(obj.disabled)
      ..writeByte(3)
      ..write(obj.taxCategory)
      ..writeByte(4)
      ..write(obj.tax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderTaxTemplateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
