// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pivot_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PivotModelAdapter extends TypeAdapter<PivotModel> {
  @override
  final int typeId = 3;

  @override
  PivotModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PivotModel(
      userId: fields[0] as int?,
      branchId: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PivotModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.branchId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PivotModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
