// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../friend.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FriendAdapter extends TypeAdapter<Friend> {
  @override
  final int typeId = 3;

  @override
  Friend read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Friend(
      friendID: fields[0] as String,
      fullName: fields[1] as String,
      username: fields[3] as String,
      avatar: fields[4] as String?,
      isOnline: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Friend obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.friendID)
      ..writeByte(1)
      ..write(obj.fullName)
      ..writeByte(3)
      ..write(obj.username)
      ..writeByte(4)
      ..write(obj.avatar)
      ..writeByte(5)
      ..write(obj.isOnline);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
