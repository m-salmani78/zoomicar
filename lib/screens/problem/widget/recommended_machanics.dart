import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import '/constants/app_constants.dart';
import '/models/mechanic.dart';
import '/models/problem_model.dart';
import '/screens/mechanic_details/mechanic_details.dart';
import '/utils/services/api_keys.dart';
import '/widgets/form_error.dart';
import 'package:location/location.dart';
import 'package:readmore/readmore.dart';

class RecommendedMechanics extends StatefulWidget {
  final Problem problem;

  // ignore: use_key_in_widget_constructors
  const RecommendedMechanics({required this.problem});

  @override
  _RecommendedMechanicsState createState() => _RecommendedMechanicsState();
}

class _RecommendedMechanicsState extends State<RecommendedMechanics> {
  Location location = Location();

  PermissionStatus _permissionGranted = PermissionStatus.denied;
  bool _serviceEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: FutureBuilder(
          future: location.getLocation(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildLoading();
            }
            if (snapshot.hasError) {
              return Center(
                child: TextButton.icon(
                    icon: const Icon(Icons.location_on),
                    onPressed: () async {
                      _permissionGranted = await location.hasPermission();
                      if (_permissionGranted == PermissionStatus.denied) {
                        _permissionGranted = await location.requestPermission();
                        if (_permissionGranted != PermissionStatus.granted) {
                          return;
                        }
                      }
                      _serviceEnabled = await location.serviceEnabled();
                      if (!_serviceEnabled) {
                        _serviceEnabled = await location.requestService();
                        if (!_serviceEnabled) {
                          return;
                        }
                      }
                      setState(() {});
                    },
                    label: const Text('GPS را روشن کنید')),
              );
            }
            if (snapshot.connectionState == ConnectionState.done) {
              final locationData = snapshot.data as LocationData;
              CustomLocation customLocation = CustomLocation(
                long: locationData.longitude ?? 0,
                lat: locationData.latitude ?? 0,
              );
              return FutureBuilder(
                future: http.post(
                  Uri.parse(baseUrl + '/car/service_centers'),
                  body: customLocation.toJson(),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildLoading();
                  }
                  if (snapshot.hasError) {
                    // log('@ Mechanic Rrror: ' + snapshot.error.toString());
                    return _buildError();
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    final response = snapshot.data as http.Response;
                    // log('@ Mechanic StatusCode: ' +
                    //     response.statusCode.toString());
                    if (response.statusCode == 200) {
                      final response = snapshot.data as http.Response;
                      // log('@ Mechanic Response: ' + response.body);
                      final mechanics =
                          mechanicFromJson(utf8.decode(response.bodyBytes));
                      return _buildMachanicList(
                          mechanics
                              .where((item) =>
                                  item.tags.contains(widget.problem.tag))
                              .toList(),
                          customLocation);
                    }
                  }
                  return _buildLoading();
                },
              );
            }
            return _buildLoading();
          }),
    );
  }

  Widget _buildMachanicList(List<Mechanic> mechanics, CustomLocation location) {
    mechanics.sort(
        (a, b) => a.getDistance(location).compareTo(b.getDistance(location)));
    mechanics.sort((a, b) {
      if (a.advertise && !b.advertise) return -1;
      if (!a.advertise && b.advertise) return 1;
      return 0;
    });
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: mechanics.length,
      itemBuilder: (context, index) {
        final mechanic = mechanics[index];
        return _buildMechanicItem(mechanic, location);
      },
    );
  }

  Widget _buildMechanicItem(Mechanic mechanic, CustomLocation location) {
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
                if (mechanic.advertise)
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
