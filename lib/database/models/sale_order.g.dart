// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_order.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SaleOrderAdapter extends TypeAdapter<SaleOrder> {
  @override
  final int typeId = 11;

  @override
  SaleOrder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SaleOrder(
      id: fields[0] as String,
      date: fields[1] as String,
      time: fields[2] as String,
      customer: fields[3] as Customer,
      manager: fields[4] as HubManager,
      items: (fields[5] as List).cast<OrderItem>(),
      orderAmount: fields[6] as double,
      transactionId: fields[7] as String,
      transactionSynced: fields[8] as bool,
      tracsactionDateTime: fields[9] as DateTime,
      paymentMethod: fields[10] == null ? '' : fields[10] as String,
      paymentStatus: fields[11] == null ? 'Unpaid' : fields[11] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SaleOrder obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.time)
      ..writeByte(3)
      ..write(obj.customer)
      ..writeByte(4)
      ..write(obj.manager)
      ..writeByte(5)
      ..write(obj.items)
      ..writeByte(6)
      ..write(obj.orderAmount)
      ..writeByte(7)
      ..write(obj.transactionId)
      ..writeByte(8)
      ..write(obj.transactionSynced)
      ..writeByte(9)
      ..write(obj.tracsactionDateTime)
      ..writeByte(10)
      ..write(obj.paymentMethod)
      ..writeByte(11)
      ..write(obj.paymentStatus);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SaleOrderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
