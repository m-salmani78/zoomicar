// To parse this JSON data, do
//
//     final mechanic = mechanicFromJson(jsonString);
import 'package:zoomicar/utils/helpers/distance_helper.dart';

mechanicsFromList({
  required List data,
  required List<Mechanic> mechanics,
  required List<Mechanic> advertise,
}) {
  for (var item in data) {
    if (item["advertise"]) {
      advertise.add(Mechanic.fromJson(item));
    } else {
      mechanics.add(Mechanic.fromJson(item));
    }
  }
  // List<Mechanic>.from(data.map((x) => Mechanic.fromJson(x)));
}

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
    // required this.advertise,
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
  // final bool advertise;

  double getDistance(CustomLocation location) {
    return calculateDistance(this.location, location);
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
        // advertise: json["advertise"],
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
