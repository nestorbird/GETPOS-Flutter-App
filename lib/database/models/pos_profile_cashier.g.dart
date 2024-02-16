// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pos_profile_cashier.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PosProfileCashierAdapter extends TypeAdapter<PosProfileCashier> {
  @override
  final int typeId = 25;

  @override
  PosProfileCashier read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PosProfileCashier(
      name: fields[0] as String,
      company: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PosProfileCashier obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.company);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PosProfileCashierAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
