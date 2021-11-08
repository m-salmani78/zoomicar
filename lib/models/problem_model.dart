import 'dart:convert';
import 'dart:math' as math;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'problem_model.g.dart';

enum ProblemStatus { urgent, critical, fair, none }

ProblemStatus percentToProblemStatus(double percentage) {
  assert(percentage >= 0 && percentage <= 100);
  if (percentage >= 90) {
    return ProblemStatus.urgent;
  } else if (percentage >= 70) {
    return ProblemStatus.critical;
  } else if (percentage >= 50) {
    return ProblemStatus.fair;
  } else {
    return ProblemStatus.none;
  }
}

Color colorFromProblemStatus(ProblemStatus problemStatus) {
  switch (problemStatus) {
    case ProblemStatus.urgent:
      return Colors.red;
    case ProblemStatus.critical:
      return Colors.orange;
    case ProblemStatus.fair:
      return Colors.lightGreen;
    default:
      return Colors.green;
  }
}

Map<DateTime, int> notifsFromJson(dynamic notifs) {
  try {
    var list = notifs as List<dynamic>;
    return Map.fromIterable(
      list,
      key: (json) {
        return DateTime.parse(json["date"]);
      },
      value: (json) {
        if (json["percentage"].toString() == 'passed') {
          return 100;
        }
        try {
          return double.parse(json["percentage"].toString()).round();
        } catch (e) {
          return int.parse(json["percentage"].toString());
        }
      },
    );
  } catch (e) {
    return {DateTime.parse(notifs["date"]): notifs["percentage"]};
  }
}

List<Problem> problemsFromJson(String str, {required int carId}) {
  Map<String, dynamic> json = jsonDecode(str);
  return json.keys.map((key) {
    final problem = Problem(carId: carId, tag: key, description: 'description');
    problem.notifs = notifsFromJson(json[key]);
    return problem;
  }).toList();
}

String tagToTitle(String tag) {
  switch (tag) {
    case 'oil_filter':
      return 'فیلتر روغن';
    case 'tire':
      return 'تایر';
    case 'gasoline_filter':
      return 'فیلتر بنزین';
    case 'air_filter':
      return 'فیلتر هوا';
    case 'engine_oil':
      return 'روغن موتور';
    case 'gearbox_oil':
      return 'روغن گیربکس';
    case 'brakepad':
      return 'لنت ترمز';
    case 'timingbelt':
      return 'تسمه تایم';
    case 'insurance':
      return 'بیمه شخص ثالث';
    default:
      return tag;
  }
}

String tagToAsset(String tag) => 'assets/images/$tag.png';

@HiveType(typeId: 2)
class Problem {
  Problem({
    required this.carId,
    required this.tag,
    required this.description,
    this.notifs = const {},
  });

  @HiveField(0)
  int carId;
  @HiveField(1)
  String tag;
  @HiveField(2)
  String description;
  @HiveField(3)
  Map<DateTime, int> notifs;

  String get title => tagToTitle(tag);

  String get imageAssetAddress => tagToAsset(tag);

  ProblemStatus get problemStatus {
    try {
      return percentToProblemStatus(percent);
    } catch (e) {
      return ProblemStatus.none;
    }
  }

  double get percent {
    final now = DateTime.now();
    final result = date;
    if (result == null) return 100;
    var difference = result.difference(now).inDays.toDouble();
    difference = math.max(difference / 7, 0);
    // print('@ percentage = ' + notifs[result].toString());
    // print('@@@ difference = ' + difference.toString());
    return math.max((notifs[result] ?? 40) - difference, 20);
  }

  DateTime? get date {
    final now = DateTime.now();
    try {
      var date = notifs.keys.first;
      while (date.isBefore(now)) {
        int i = notifs.remove(date) ?? -1;
        log('@ $tag remove = ' + i.toString());
        date = notifs.keys.first;
      }
      return date;
    } catch (e) {
      return null;
    }
  }

  Color get color => colorFromProblemStatus(problemStatus);

  @override
  int get hashCode {
    return (tag + carId.toString()).hashCode;
  }

  @override
  bool operator ==(Object other) {
    return other is Problem && tag == other.tag && carId == other.carId;
  }
}
