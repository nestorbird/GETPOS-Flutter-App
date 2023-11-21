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
      hubManager: fields[0] as String?,
      customer: fields[1] as String?,
      transactionDate: fields[2] as String?,
      deliveryDate: fields[3] as String?,
      items: (fields[4] as List?)?.cast<SaleOrderRequestItems>(),
      modeOfPayment: fields[5] as String?,
      mpesaNo: fields[6] as String?,
      tax: (fields[7] as List?)?.cast<OrderTax>(),
    );
  }

  @override
  void write(BinaryWriter writer, SalesOrderRequest obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.hubManager)
      ..writeByte(1)
      ..write(obj.customer)
      ..writeByte(2)
      ..write(obj.transactionDate)
      ..writeByte(3)
      ..write(obj.deliveryDate)
      ..writeByte(4)
      ..write(obj.items)
      ..writeByte(5)
      ..write(obj.modeOfPayment)
      ..writeByte(6)
      ..write(obj.mpesaNo)
      ..writeByte(7)
      ..write(obj.tax);
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
