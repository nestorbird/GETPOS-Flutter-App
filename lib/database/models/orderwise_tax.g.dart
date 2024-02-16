// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orderwise_tax.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderTaxAdapter extends TypeAdapter<OrderTax> {
  @override
  final int typeId = 21;

  @override
  OrderTax read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderTax(
      taxId: fields[1] as String,
      itemTaxTemplate: fields[2] as String,
      taxType: fields[3] as String,
      taxRate: fields[4] as double,
      taxAmount: fields[5] == null ? 0.0 : fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, OrderTax obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.taxId)
      ..writeByte(2)
      ..write(obj.itemTaxTemplate)
      ..writeByte(3)
      ..write(obj.taxType)
      ..writeByte(4)
      ..write(obj.taxRate)
      ..writeByte(5)
      ..write(obj.taxAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderTaxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
