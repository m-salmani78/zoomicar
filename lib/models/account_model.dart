import 'package:hive_flutter/hive_flutter.dart';

import 'problem_model.dart';
import 'car_model.dart';

part 'account_model.g.dart';

@HiveType(typeId: 0)
class Account {
  Account({required this.car, this.problems = const []});

  @HiveField(0)
  final Car car;
  @HiveField(1)
  final List<Problem> problems;

  int get id => car.carId;

  Problem? findProblem({required String tag}) {
    try {
      return problems.firstWhere((element) => element.tag == tag);
    } catch (e) {
      return null;
    }
  }

  @override
  int get hashCode => id.toString().hashCode;

  @override
  bool operator ==(Object other) {
    return other is Account && id == other.id;
  }
}
