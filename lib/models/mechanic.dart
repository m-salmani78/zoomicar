// To parse this JSON data, do
//
//     final mechanic = mechanicFromJson(jsonString);
import 'dart:math' as math;
import 'dart:convert';

List<Mechanic> mechanicFromJson(String str) =>
    List<Mechanic>.from(json.decode(str).map((x) => Mechanic.fromJson(x)));

class Mechanic {
  Mechanic({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.image,
    required this.description,
    required this.location,
    required this.userRate,
    this.tags = const [],
    required this.advertise,
  });

  final int id;
  final String name;
  final String address;
  final String phoneNumber;
  final String image;
  final String description;
  final CustomLocation location;
  final List<String> tags;
  final int userRate;
  final bool advertise;

  double getDistance(CustomLocation location) {
    const R = 6371; //kilo metres
    final deltaPhi = (location.lat - this.location.lat).abs() * math.pi / 180;
    final deltaLanda =
        (location.long - this.location.long).abs() * math.pi / 180;
    final a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(this.location.lat * math.pi / 180) *
            math.cos(location.lat * math.pi / 180) *
            math.sin(deltaLanda / 2) *
            math.sin(deltaLanda / 2);
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return R * c;
  }

  factory Mechanic.fromJson(Map<String, dynamic> json) => Mechanic(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        phoneNumber: json["phone"],
        image: json["image"],
        description: json["description"],
        location: CustomLocation.fromJson(json["location"]),
        userRate: json["user_rate"],
        tags: List<String>.from(json["tags"].map((x) => x)),
        advertise: json["advertise"],
      );
}

class CustomLocation {
  const CustomLocation({
    required this.long,
    required this.lat,
  });

  final double long;
  final double lat;

  factory CustomLocation.fromJson(Map<String, dynamic> json) => CustomLocation(
        long: json["long"].toDouble(),
        lat: json["lat"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "long": long.toString(),
        "lat": lat.toString(),
      };
}
