import 'package:flutter/material.dart';
import 'package:zoomicar/screens/mechanics/widgets/mechanic_item.dart';
import 'package:zoomicar/utils/services/mechanics_service.dart';
import '/models/mechanic.dart';
import '/models/problem_model.dart';
import '/widgets/form_error.dart';
import 'package:location/location.dart';

class RecommendedMechanics extends StatefulWidget {
  final Problem problem;

  // ignore: use_key_in_widget_constructors
  const RecommendedMechanics({required this.problem});

  @override
  _RecommendedMechanicsState createState() => _RecommendedMechanicsState();
}

class _RecommendedMechanicsState extends State<RecommendedMechanics> {
  Location location = Location();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: FutureBuilder(
        future: MechanicsService().getLocation(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoading();
          }
          if (snapshot.hasError) {
            return Center(
              child: TextButton.icon(
                  icon: const Icon(Icons.location_on),
                  onPressed: () => setState(() {}),
                  label: const Text('GPS را روشن کنید')),
            );
          }
          final customLocation = snapshot.data as CustomLocation;
          return FutureBuilder(
            future: MechanicsService().getServiceCenters(customLocation),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildLoading();
              }
              if (snapshot.hasError) {
                // log('@ Mechanic Rrror: ' + snapshot.error.toString());
                return _buildError();
              }
              if (snapshot.connectionState == ConnectionState.done) {
                final mechanics = snapshot.data as List<Mechanic>;
                return _buildMachanicList(
                    mechanics: mechanics
                        .where((item) => item.tags.contains(widget.problem.tag))
                        .toList(),
                    advertises: MechanicsService()
                        .advertise
                        .where((item) => item.tags.contains(widget.problem.tag))
                        .toList(),
                    location: customLocation);
              }
              return _buildLoading();
            },
          );
        },
      ),
    );
  }

  Widget _buildMachanicList(
      {required List<Mechanic> mechanics,
      required List<Mechanic> advertises,
      required CustomLocation location}) {
    mechanics.sort(
        (a, b) => a.getDistance(location).compareTo(b.getDistance(location)));
    // mechanics.sort((a, b) {
    //   if (a.advertise && !b.advertise) return -1;
    //   if (!a.advertise && b.advertise) return 1;
    //   return 0;
    // });
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: mechanics.length + advertises.length,
      itemBuilder: (context, index) {
        final mechanic = (index < advertises.length)
            ? advertises[index]
            : mechanics[index - advertises.length];
        return MechanicItemView(
          mechanic: mechanic,
          location: location,
        );
      },
    );
  }

  Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  Widget _buildError() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ignore: prefer_const_constructors
          FormError(errors: const ['اتصال برقرار نیست']),
          TextButton.icon(
            onPressed: () => setState(() {}),
            label: const Text('تلاش مجدد'),
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
    );
  }
}
