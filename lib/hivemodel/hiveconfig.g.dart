// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiveconfig.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HiveConfigAdapter extends TypeAdapter<HiveConfig> {
  @override
  final int typeId = 1;

  @override
  HiveConfig read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HiveConfig(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, HiveConfig obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.link)
      ..writeByte(1)
      ..write(obj.remark)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.isclicked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HiveConfigAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
