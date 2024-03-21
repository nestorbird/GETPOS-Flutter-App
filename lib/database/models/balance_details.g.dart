// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'balance_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BalanceDetailAdapter extends TypeAdapter<BalanceDetail> {
  @override
  final int typeId = 29;

  @override
  BalanceDetail read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BalanceDetail(
      name: fields[0] as String,
      owner: fields[1] as String,
      creation: fields[2] as String,
      modified: fields[3] as String,
      modifiedBy: fields[4] as String,
      parent: fields[5] as String,
      parentField: fields[6] as String,
      parentType: fields[7] as String,
      idx: fields[8] as int,
      docstatus: fields[9] as int,
      modeOfPayment: fields[10] as String,
      amount: fields[11] as int,
      doctype: fields[12] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BalanceDetail obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.owner)
      ..writeByte(2)
      ..write(obj.creation)
      ..writeByte(3)
      ..write(obj.modified)
      ..writeByte(4)
      ..write(obj.modifiedBy)
      ..writeByte(5)
      ..write(obj.parent)
      ..writeByte(6)
      ..write(obj.parentField)
      ..writeByte(7)
      ..write(obj.parentType)
      ..writeByte(8)
      ..write(obj.idx)
      ..writeByte(9)
      ..write(obj.docstatus)
      ..writeByte(10)
      ..write(obj.modeOfPayment)
      ..writeByte(11)
      ..write(obj.amount)
      ..writeByte(12)
      ..write(obj.doctype);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BalanceDetailAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
