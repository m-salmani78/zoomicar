import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:zoomicar/utils/services/mechanics_service.dart';
import '/constants/app_constants.dart';
import '/models/mechanic.dart';
import '/screens/mechanic_details/mechanic_details.dart';
import 'package:readmore/readmore.dart';

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
    // widget.mechanics.sort((a, b) {
    //   if (a.advertise && !b.advertise) return -1;
    //   if (!a.advertise && b.advertise) return 1;
    //   return 0;
    // });
    return Flexible(
      child: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: mechanics.length + advertises.length,
        itemBuilder: (context, index) {
          final mechanic = (index < advertises.length)
              ? advertises[index]
              : mechanics[index - advertises.length];
          return buildMechanicItem(
            context,
            mechanic: mechanic,
            location: location,
            isAdvertise: index == 0,
          );
        },
      ),
    );
  }
}

Widget buildMechanicItem(BuildContext context,
    {required Mechanic mechanic,
    required CustomLocation location,
    bool isAdvertise = false}) {
  return Card(
    margin: const EdgeInsets.all(8),
    clipBehavior: Clip.antiAlias,
    elevation: defaultElevation,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadius)),
    child: InkWell(
      splashColor: Colors.transparent,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MechanicDetailsScreen(
                mechanic: mechanic,
                location: location,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              if (isAdvertise)
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: SvgPicture.asset(
                    'assets/icons/ic-advertiser.svg',
                    height: 24,
                    width: 24,
                    fit: BoxFit.fill,
                  ),
                ),
              Text(
                mechanic.name,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Spacer(),
              Text(
                '${mechanic.getDistance(location).toStringAsFixed(1)} km',
                textDirection: TextDirection.ltr,
                style: Theme.of(context).textTheme.caption,
              ),
            ]),
            const SizedBox(height: 8),
            Text(
              mechanic.phoneNumber,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            ),
            const SizedBox(height: 8),
            ReadMoreText(
              mechanic.description,
              trimLines: 2,
              style: const TextStyle(fontSize: 14),
              trimMode: TrimMode.Line,
              // colorClickableText: Colors.pink,
              trimCollapsedText: 'بیشتر',
              trimExpandedText: 'کمتر',
            ),
          ],
        ),
      ),
    ),
  );
}
