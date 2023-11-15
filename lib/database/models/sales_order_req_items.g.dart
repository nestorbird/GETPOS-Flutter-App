// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_req_items.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleOrderRequestItemsAdapter extends TypeAdapter<SaleOrderRequestItems> {
  @override
  final int typeId = 24;

  @override
  SaleOrderRequestItems read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleOrderRequestItems(
      itemCode: fields[0] as String?,
      name: fields[1] as String?,
      price: fields[2] as double?,
      selectedOption: (fields[3] as List?)?.cast<SelectedOptions>(),
      orderedQuantity: fields[4] as double?,
      orderedPrice: fields[5] as double?,
      tax: (fields[6] as List?)?.cast<Taxes>(),
    );
  }

  @override
  void write(BinaryWriter writer, SaleOrderRequestItems obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.itemCode)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.selectedOption)
      ..writeByte(4)
      ..write(obj.orderedQuantity)
      ..writeByte(5)
      ..write(obj.orderedPrice)
      ..writeByte(6)
      ..write(obj.tax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleOrderRequestItemsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
