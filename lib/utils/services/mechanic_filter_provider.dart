import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zoomicar/models/mechanic.dart';
import 'package:zoomicar/utils/services/mechanics_service.dart';

const int minDistance = 0;
const int maxDistance = 10000;

class MechanicsFilterProvider extends ChangeNotifier {
  static var _instance = MechanicsFilterProvider._();
  RangeValues rangeDistance =
      RangeValues(minDistance.toDouble(), maxDistance.toDouble());
  List<String> filterTags = [];

  MechanicsFilterProvider._();

  factory MechanicsFilterProvider() => _instance;

  static MechanicsFilterProvider newInstance() =>
      _instance = MechanicsFilterProvider._();

  int filtersNum() =>
      filterTags.length +
      (rangeDistance.start != minDistance || rangeDistance.end != maxDistance
          ? 1
          : 0);

  void addTagFilter(String tag) {
    if (filterTags.contains(tag)) return;
    filterTags.add(tag);
    notifyListeners();
  }

  void deleteTagFilter(String tag) {
    if (filterTags.remove(tag)) notifyListeners();
  }

  void deleteAllTags() {
    filterTags.clear();
    notifyListeners();
  }

  void changeRangeDistanceFilter(RangeValues rangeValues) {
    log('changeRangeDistance');
    rangeDistance = rangeValues;
    notifyListeners();
  }

  void deleteRangeDistanceFilter() => rangeDistance =
      RangeValues(minDistance.toDouble(), maxDistance.toDouble());

  List<Mechanic> getFilteredList(List<Mechanic> list) {
    final location = MechanicsService().location!;
    return list.where((element) {
      return rangeDistance.start <= element.getDistance(location) &&
          element.getDistance(location) <= rangeDistance.end;
    }).where((element) {
      return filterTags.every((tag) => element.tags.contains(tag));
    }).toList();
  }
}
