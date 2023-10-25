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
      taxId: fields[0] as String,
      itemTaxTemplate: fields[1] as String,
      taxType: fields[2] as String,
      taxRate: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Taxes obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.taxId)
      ..writeByte(1)
      ..write(obj.itemTaxTemplate)
      ..writeByte(2)
      ..write(obj.taxType)
      ..writeByte(3)
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
