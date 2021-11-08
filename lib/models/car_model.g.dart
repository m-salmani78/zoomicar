// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CarAdapter extends TypeAdapter<Car> {
  @override
  final int typeId = 1;

  @override
  Car read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Car(
      carId: fields[0] as int,
      name: fields[1] as String,
      model: fields[2] as String,
      image: fields[3] as String,
      thirdPartyInsurance: shamsiFromString(fields[5] as String),
      kilometerage: fields[4] as int,
      lastAirFilterChange: fields[15] as int,
      lastBrakepadChange: fields[10] as int,
      lastGearboxOilChange: fields[9] as int,
      lastEngineOilChange: fields[8] as int,
      lastGasolineFilterChange: fields[14] as int,
      lastGearboxRepair: fields[7] as int,
      lastMotorRepair: fields[6] as int,
      lastOilFilterChange: fields[13] as int,
      lastTimingbeltChange: fields[11] as int,
      lastTireChange: fields[12] as int,
      carUseAmount: CarUseAmount.values[fields[16] as int],
    );
  }

  @override
  void write(BinaryWriter writer, Car obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.carId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.model)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.kilometerage)
      ..writeByte(5)
      ..write(obj.thirdPartyInsurance == null
          ? ""
          : shamsiToString(obj.thirdPartyInsurance!))
      ..writeByte(6)
      ..write(obj.lastMotorRepair)
      ..writeByte(7)
      ..write(obj.lastGearboxRepair)
      ..writeByte(8)
      ..write(obj.lastEngineOilChange)
      ..writeByte(9)
      ..write(obj.lastGearboxOilChange)
      ..writeByte(10)
      ..write(obj.lastBrakepadChange)
      ..writeByte(11)
      ..write(obj.lastTimingbeltChange)
      ..writeByte(12)
      ..write(obj.lastTireChange)
      ..writeByte(13)
      ..write(obj.lastOilFilterChange)
      ..writeByte(14)
      ..write(obj.lastGasolineFilterChange)
      ..writeByte(15)
      ..write(obj.lastAirFilterChange)
      ..writeByte(16)
      ..write(obj.carUseAmount.index);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
