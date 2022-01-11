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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: ReadMoreText(
                      mechanic.description,
                      trimLines: 2,
                      style: const TextStyle(fontSize: 14),
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'بیشتر',
                      trimExpandedText: 'کمتر',
                    ),
                  ),
                  _buildAvgRate(context),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvgRate(BuildContext context) {
    final color = Theme.of(context).brightness == Brightness.light
        ? Colors.amber
        : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.amber.shade100.withOpacity(0.5)
            : Colors.black,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            mechanic.averageRate.toStringAsFixed(1),
            style: const TextStyle(fontSize: 13),
          ),
          Icon(Icons.star_rounded, color: color, size: 22),
        ],
      ),
    );
  }
}
