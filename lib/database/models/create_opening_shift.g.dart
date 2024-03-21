// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_opening_shift.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CreateOpeningShiftDbAdapter extends TypeAdapter<CreateOpeningShiftDb> {
  @override
  final int typeId = 0;

  @override
  CreateOpeningShiftDb read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CreateOpeningShiftDb(
      name: fields[0] as String,
      owner: fields[1] as String,
      creation: fields[2] as String,
      modified: fields[3] as String,
      modifiedBy: fields[4] as String,
      idx: fields[5] as int,
      docstatus: fields[6] as int,
      periodStartDate: fields[7] as String,
      status: fields[8] as String,
      postingDate: fields[9] as String,
      setPostingDate: fields[10] as int,
      company: fields[11] as String,
      posProfile: fields[12] as String,
      user: fields[13] as String,
      doctype: fields[14] as String,
      balanceDetails: (fields[15] as List).cast<BalanceDetail>(),
    );
  }

  @override
  void write(BinaryWriter writer, CreateOpeningShiftDb obj) {
    writer
      ..writeByte(16)
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
      ..write(obj.idx)
      ..writeByte(6)
      ..write(obj.docstatus)
      ..writeByte(7)
      ..write(obj.periodStartDate)
      ..writeByte(8)
      ..write(obj.status)
      ..writeByte(9)
      ..write(obj.postingDate)
      ..writeByte(10)
      ..write(obj.setPostingDate)
      ..writeByte(11)
      ..write(obj.company)
      ..writeByte(12)
      ..write(obj.posProfile)
      ..writeByte(13)
      ..write(obj.user)
      ..writeByte(14)
      ..write(obj.doctype)
      ..writeByte(15)
      ..write(obj.balanceDetails);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateOpeningShiftDbAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
