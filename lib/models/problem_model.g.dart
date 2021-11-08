// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProblemAdapter extends TypeAdapter<Problem> {
  @override
  final int typeId = 2;

  @override
  Problem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Problem(
      carId: fields[0] as int,
      tag: fields[1] as String,
      description: fields[2] as String,
      notifs: (fields[3] as Map).cast<DateTime, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, Problem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.carId)
      ..writeByte(1)
      ..write(obj.tag)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.notifs);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProblemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
