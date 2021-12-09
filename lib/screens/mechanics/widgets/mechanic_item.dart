import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:readmore/readmore.dart';
import 'package:zoomicar/constants/app_constants.dart';
import 'package:zoomicar/models/mechanic.dart';
import 'package:zoomicar/screens/mechanic_details/mechanic_details.dart';

class MechanicItemView extends StatelessWidget {
  final Mechanic mechanic;
  final CustomLocation location;
  final bool isAdvertise;
  const MechanicItemView(
      {Key? key,
      required this.mechanic,
      required this.location,
      this.isAdvertise = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
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
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
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
}
