// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderItemAdapter extends TypeAdapter<OrderItem> {
  @override
  final int typeId = 19;

  @override
  OrderItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderItem(
      id: fields[0] as String,
      name: fields[1] as String,
      group: fields[3] as String,
      description: fields[4] as String,
      stock: fields[5] as double,
      price: fields[2] as double,
      attributes: (fields[6] as List).cast<Attribute>(),
      orderedQuantity: fields[7] as double,
      orderedPrice: fields[10] as double,
      productImage: fields[8] as Uint8List,
      productUpdatedTime: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, OrderItem obj) {
    writer
      ..writeByte(11)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.group)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.stock)
      ..writeByte(6)
      ..write(obj.attributes)
      ..writeByte(7)
      ..write(obj.orderedQuantity)
      ..writeByte(8)
      ..write(obj.productImage)
      ..writeByte(9)
      ..write(obj.productUpdatedTime)
      ..writeByte(10)
      ..write(obj.orderedPrice);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
