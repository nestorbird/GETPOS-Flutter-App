// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hub_manager.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HubManagerAdapter extends TypeAdapter<HubManager> {
  @override
  final int typeId = 17;

  @override
  HubManager read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HubManager(
      id: fields[0] as String,
      name: fields[1] as String,
      emailId: fields[2] as String,
      phone: fields[3] as String,
      cashBalance: fields[4] as double,
      profileImage: fields[5] as Uint8List,
    );
  }

  @override
  void write(BinaryWriter writer, HubManager obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.emailId)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.cashBalance)
      ..writeByte(5)
      ..write(obj.profileImage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HubManagerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
