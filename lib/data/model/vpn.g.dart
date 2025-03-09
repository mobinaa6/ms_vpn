// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class VpnAdapter extends TypeAdapter<Vpn> {
  @override
  final int typeId = 0;

  @override
  Vpn read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Vpn(
      fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Vpn obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.configLink);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VpnAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
