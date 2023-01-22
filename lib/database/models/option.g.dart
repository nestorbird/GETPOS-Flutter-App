// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'option.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OptionAdapter extends TypeAdapter<Option> {
  @override
  final int typeId = 16;

  @override
  Option read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Option(
      id: fields[0] as String,
      name: fields[1] as String,
      price: fields[2] as double,
      selected: fields[3] as bool,
      tax: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Option obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.selected)
      ..writeByte(4)
      ..write(obj.tax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OptionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
