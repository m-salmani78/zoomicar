import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import '/models/mechanic.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatelessWidget {
  final CustomLocation location;
  const MapScreen({Key? key, required this.location}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final latLng = LatLng(location.lat, location.long);
    return Scaffold(
      appBar: AppBar(
        title: const Text('نقشه', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 4,
      ),
      body: FlutterMap(
        options: MapOptions(
          center: latLng,
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 80.0,
                height: 80.0,
                point: latLng,
                builder: (ctx) => Image.asset(
                  'assets/images/machanic_location.png',
                  width: 24,
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ConstrainedBox(
        constraints:
            BoxConstraints(minWidth: MediaQuery.of(context).size.width - 32),
        child: ElevatedButton.icon(
            onPressed: () {
              try {
                _launchMaps();
              } catch (e) {
                log('Could not launch url');
              }
            },
            icon: const Icon(Icons.directions),
            label: const Text('مسیریابی')),
      ),
    );
  }

  _launchMaps() async {
    // String googleUrl =
    //     'comgooglemaps://?center=${location.lat},${location.long}';
    // String appleUrl =
    //     'https://maps.apple.com/?sll=${location.lat},${location.long}';
    // if (await canLaunch("comgooglemaps://")) {
    //   log('launching com googleUrl');
    //   await launch(googleUrl);
    // } else if (await canLaunch(appleUrl)) {
    //   log('launching apple url');
    //   await launch(appleUrl);
    // } else {
    //   throw 'Could not launch url';
    // }
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${location.lat},${location.long}';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}
