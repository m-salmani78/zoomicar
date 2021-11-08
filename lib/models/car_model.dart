import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shamsi_date/shamsi_date.dart';

part 'car_model.g.dart';

Car carFromJson(String str) => Car.fromJson(json.decode(str));

String carToJson(Car data) => json.encode(data.toJson());

enum CarUseAmount { fullTime, highConsumption, medium, lowConsumption }

String shamsiToString(Jalali value) {
  return "${value.year}/${value.month}/${value.day}";
}

Jalali? shamsiFromString(String value) {
  try {
    var params = value.split('/');
    return Jalali(
      int.parse(params[0]),
      int.parse(params[1]),
      int.parse(params[2]),
    );
  } catch (e) {
    return null;
  }
}

@HiveType(typeId: 1)
class Car {
  @HiveField(0)
  int carId;
  @HiveField(1)
  String name;
  @HiveField(2)
  String model;
  @HiveField(3)
  String image;
  @HiveField(4)
  int kilometerage;
  @HiveField(5)
  Jalali? thirdPartyInsurance;
  @HiveField(6)
  int lastMotorRepair;
  @HiveField(7)
  int lastGearboxRepair;
  @HiveField(8)
  int lastEngineOilChange;
  @HiveField(9)
  int lastGearboxOilChange;
  @HiveField(10)
  int lastBrakepadChange;
  @HiveField(11)
  int lastTimingbeltChange;
  @HiveField(12)
  int lastTireChange;
  @HiveField(13)
  int lastOilFilterChange;
  @HiveField(14)
  int lastGasolineFilterChange;
  @HiveField(15)
  int lastAirFilterChange;
  @HiveField(16)
  CarUseAmount carUseAmount;

  Car({
    this.carId = -1,
    this.name = '',
    this.model = '',
    this.image = '',
    this.thirdPartyInsurance,
    this.kilometerage = 0,
    this.lastAirFilterChange = 0,
    this.lastBrakepadChange = 0,
    this.lastGearboxOilChange = 0,
    this.lastEngineOilChange = 0,
    this.lastGasolineFilterChange = 0,
    this.lastGearboxRepair = 0,
    this.lastMotorRepair = 0,
    this.lastOilFilterChange = 0,
    this.lastTimingbeltChange = 0,
    this.lastTireChange = 0,
    this.carUseAmount = CarUseAmount.fullTime,
  });
  factory Car.fromJson(Map<String, dynamic> json) => Car(
        carId: json["car_id"],
        name: json["carfamily"],
        model: json["carname"],
        image: json["image"],
        kilometerage: json["kilometrage"],
        carUseAmount: CarUseAmount.values[json["kilometer_per_day_index"]],
        lastMotorRepair: json["last_engine_repair"],
        lastGearboxRepair: json["last_gearbox_repair"],
        thirdPartyInsurance: Jalali.fromDateTime(
            DateTime.parse(json["third_party_insurance_date"])),
        lastOilFilterChange: json["last_oil_filter_change"],
        lastTireChange: json["last_tire_change"],
        lastGasolineFilterChange: json["last_gasoline_filter_change"],
        lastAirFilterChange: json["last_air_filter_change"],
        lastEngineOilChange: json["last_engine_oil_change"],
        lastGearboxOilChange: json["last_gearbox_oil_change"],
        lastBrakepadChange: json["last_brakepad_change"],
        lastTimingbeltChange: json["last_timingbelt_change"],
      );

  Map<String, String> toJson({int? id}) {
    final editMode = (id == null) ? {} : {"car_id": id.toString()};
    var date =
        thirdPartyInsurance == null ? null : thirdPartyInsurance!.toDateTime();
    return {
      ...editMode,
      "carname": model,
      "kilometrage": kilometerage.toString(),
      "kilometer_per_day_index": carUseAmount.index.toString(),
      "last_engine_repair": lastMotorRepair.toString(),
      "last_gearbox_repair": lastGearboxRepair.toString(),
      "third_party_insurance_date":
          (date == null) ? "" : "${date.year} / ${date.month} / ${date.day}",
      "last_oil_filter_change": lastOilFilterChange.toString(),
      "last_tire_change": lastTireChange.toString(),
      "last_gasoline_filter_change": lastGasolineFilterChange.toString(),
      "last_air_filter_change": lastAirFilterChange.toString(),
      "last_engine_oil_change": lastEngineOilChange.toString(),
      "last_gearbox_oil_change": lastGearboxOilChange.toString(),
      "last_brakepad_change": lastBrakepadChange.toString(),
      "last_timingbelt_change": lastTimingbeltChange.toString(),
    };
  }

  Car copyInstance() => Car(
        carId: carId,
        model: model,
        name: name,
        thirdPartyInsurance: thirdPartyInsurance,
        carUseAmount: carUseAmount,
        image: image,
        kilometerage: kilometerage,
        lastAirFilterChange: lastAirFilterChange,
        lastBrakepadChange: lastBrakepadChange,
        lastGearboxOilChange: lastGearboxOilChange,
        lastEngineOilChange: lastEngineOilChange,
        lastGasolineFilterChange: lastGasolineFilterChange,
        lastGearboxRepair: lastGearboxRepair,
        lastMotorRepair: lastMotorRepair,
        lastOilFilterChange: lastOilFilterChange,
        lastTimingbeltChange: lastTimingbeltChange,
        lastTireChange: lastTireChange,
      );
  bool editParamWithTag({required String tag, required int value}) {
    switch (tag) {
      case 'oil_filter':
        lastOilFilterChange = value;
        break;
      case 'gasoline_filter':
        lastGasolineFilterChange = value;
        break;
      case 'air_filter':
        lastAirFilterChange = value;
        break;
      case 'tire':
        lastTireChange = value;
        break;
      case 'engine_oil':
        lastEngineOilChange = value;
        break;
      case 'gearbox_oil':
        lastGearboxOilChange = value;
        break;
      case 'brakepad':
        lastBrakepadChange = value;
        break;
      case 'timingbelt':
        lastTimingbeltChange = value;
        break;
      default:
        return false;
    }
    return true;
  }
}
