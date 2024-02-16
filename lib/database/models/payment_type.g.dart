// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentTypeAdapter extends TypeAdapter<PaymentType> {
  @override
  final int typeId = 26;

  @override
  PaymentType read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentType(
      parent: fields[0] as String,
      isDefault: fields[1] as bool,
      allowInReturns: fields[2] as bool,
      modeOfPayment: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentType obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.parent)
      ..writeByte(1)
      ..write(obj.isDefault)
      ..writeByte(2)
      ..write(obj.allowInReturns)
      ..writeByte(3)
      ..write(obj.modeOfPayment);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
