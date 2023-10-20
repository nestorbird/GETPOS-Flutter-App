// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'taxes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaxesAdapter extends TypeAdapter<Taxes> {
  @override
  final int typeId = 20;

  @override
  Taxes read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Taxes(
      itemTaxTemplate: fields[0] as String,
      taxType: fields[1] as String,
      taxRate: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Taxes obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.itemTaxTemplate)
      ..writeByte(1)
      ..write(obj.taxType)
      ..writeByte(2)
      ..write(obj.taxRate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaxesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
