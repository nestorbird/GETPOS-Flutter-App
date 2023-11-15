// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_order_req.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SalesOrderRequestAdapter extends TypeAdapter<SalesOrderRequest> {
  @override
  final int typeId = 23;

  @override
  SalesOrderRequest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SalesOrderRequest(
      id: fields[0] as String?,
      hubManager: fields[1] as String?,
      customer: fields[2] as String?,
      transactionDate: fields[3] as String?,
      deliveryDate: fields[4] as String?,
      items: (fields[5] as List?)?.cast<SaleOrderRequestItems>(),
      modeOfPayment: fields[6] as String?,
      mpesaNo: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, SalesOrderRequest obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.hubManager)
      ..writeByte(2)
      ..write(obj.customer)
      ..writeByte(3)
      ..write(obj.transactionDate)
      ..writeByte(4)
      ..write(obj.deliveryDate)
      ..writeByte(5)
      ..write(obj.items)
      ..writeByte(6)
      ..write(obj.modeOfPayment)
      ..writeByte(7)
      ..write(obj.mpesaNo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SalesOrderRequestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
