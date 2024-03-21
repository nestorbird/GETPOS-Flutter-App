// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_management.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShiftManagementAdapter extends TypeAdapter<ShiftManagement> {
  @override
  final int typeId = 27;

  @override
  ShiftManagement read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShiftManagement(
      posProfile: fields[0] as String,
      paymentsMethod: (fields[1] as List).cast<PaymentType>(),
      paymentInfoList: (fields[2] as List).cast<PaymentInfo>(),
    );
  }

  @override
  void write(BinaryWriter writer, ShiftManagement obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.posProfile)
      ..writeByte(1)
      ..write(obj.paymentsMethod)
      ..writeByte(2)
      ..write(obj.paymentInfoList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShiftManagementAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
