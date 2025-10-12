// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'branche_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BrancheModelAdapter extends TypeAdapter<BrancheModel> {
  @override
  final int typeId = 2;

  @override
  BrancheModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BrancheModel(
      id: fields[0] as int?,
      name: fields[1] as String?,
      address: fields[2] as String?,
      phone: fields[3] as String?,
      email: fields[4] as String?,
      createdAt: fields[5] as String?,
      updatedAt: fields[6] as String?,
      pivot: fields[7] as PivotModel?,
    );
  }

  @override
  void write(BinaryWriter writer, BrancheModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.address)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.pivot);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BrancheModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
