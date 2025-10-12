// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoleModelAdapter extends TypeAdapter<RoleModel> {
  @override
  final int typeId = 1;

  @override
  RoleModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoleModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      description: fields[2] as String?,
      sales: fields[3] as bool?,
      purchase: fields[4] as bool?,
      users: fields[5] as bool?,
      roles: fields[6] as bool?,
      settings: fields[7] as bool?,
      categories: fields[8] as bool?,
      products: fields[9] as bool?,
      units: fields[10] as bool?,
      branches: fields[11] as bool?,
      customers: fields[12] as bool?,
      expenseCategories: fields[13] as bool?,
      expenses: fields[14] as bool?,
      purchaseReturn: fields[15] as bool?,
      saleReturn: fields[16] as bool?,
      suppliers: fields[17] as bool?,
      taxes: fields[18] as bool?,
      discounts: fields[19] as bool?,
      inventory: fields[22] as bool?,
      stock: fields[23] as bool?,
      printers: fields[24] as bool?,
      createdAt: fields[20] as String?,
      updatedAt: fields[21] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RoleModel obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.sales)
      ..writeByte(4)
      ..write(obj.purchase)
      ..writeByte(5)
      ..write(obj.users)
      ..writeByte(6)
      ..write(obj.roles)
      ..writeByte(7)
      ..write(obj.settings)
      ..writeByte(8)
      ..write(obj.categories)
      ..writeByte(9)
      ..write(obj.products)
      ..writeByte(10)
      ..write(obj.units)
      ..writeByte(11)
      ..write(obj.branches)
      ..writeByte(12)
      ..write(obj.customers)
      ..writeByte(13)
      ..write(obj.expenseCategories)
      ..writeByte(14)
      ..write(obj.expenses)
      ..writeByte(15)
      ..write(obj.purchaseReturn)
      ..writeByte(16)
      ..write(obj.saleReturn)
      ..writeByte(17)
      ..write(obj.suppliers)
      ..writeByte(18)
      ..write(obj.taxes)
      ..writeByte(19)
      ..write(obj.discounts)
      ..writeByte(22)
      ..write(obj.inventory)
      ..writeByte(23)
      ..write(obj.stock)
      ..writeByte(24)
      ..write(obj.printers)
      ..writeByte(20)
      ..write(obj.createdAt)
      ..writeByte(21)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoleModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
