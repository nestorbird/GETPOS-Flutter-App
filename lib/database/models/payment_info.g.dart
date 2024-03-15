// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PaymentInfoAdapter extends TypeAdapter<PaymentInfo> {
  @override
  final int typeId = 1;

  @override
  PaymentInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PaymentInfo(
      paymentType: fields[0] as String,
      amount: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PaymentInfo obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.paymentType)
      ..writeByte(1)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
