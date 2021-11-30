import 'dart:math' as math;

import 'package:zoomicar/models/mechanic.dart';

double calculateDistance(CustomLocation first, CustomLocation second) {
  const R = 6371; //kilo metres
  final deltaPhi = (first.lat - second.lat).abs() * math.pi / 180;
  final deltaLanda = (first.long - second.long).abs() * math.pi / 180;
  final a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
      math.cos(first.lat * math.pi / 180) *
          math.cos(second.lat * math.pi / 180) *
          math.sin(deltaLanda / 2) *
          math.sin(deltaLanda / 2);
  final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  return R * c;
}
