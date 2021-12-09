import 'package:flutter/material.dart';
import 'package:zoomicar/screens/mechanics/widgets/mechanic_item.dart';
import 'package:zoomicar/utils/services/mechanics_service.dart';
import '/models/mechanic.dart';

class MechanicsList extends StatelessWidget {
  final List<Mechanic> mechanics;
  final CustomLocation location;

  const MechanicsList({
    Key? key,
    required this.mechanics,
    required this.location,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Mechanic> advertises = MechanicsService().advertise;
    mechanics.sort(
      (a, b) => a.getDistance(location).compareTo(b.getDistance(location)),
    );
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: mechanics.length + advertises.length,
        itemBuilder: (context, index) {
          final mechanic = (index < advertises.length)
              ? advertises[index]
              : mechanics[index - advertises.length];
          return MechanicItemView(
            mechanic: mechanic,
            location: location,
            isAdvertise: index == 0,
          );
        },
      ),
    );
  }
}
