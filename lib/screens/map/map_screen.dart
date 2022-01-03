import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:zoomicar/constants/app_constants.dart';
import '/models/mechanic.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

class MapScreen extends StatefulWidget {
  final CustomLocation location;
  final Mechanic mechanic;
  const MapScreen({
    Key? key,
    required this.location,
    required this.mechanic,
  }) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool trafficEnabled = false;
  bool hybridType = false;
  @override
  void initState() {
    if (defaultTargetPlatform == TargetPlatform.android) {
      AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // late GoogleMapController mapController;
    final latLng = LatLng(widget.location.lat, widget.location.long);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'نقشه',
          style: TextStyle(
            color: Colors.white,
            shadows: [
              Shadow(blurRadius: 1, offset: shadowOffset, color: Colors.black38)
            ],
          ),
        ),
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            tooltip: 'موارد بیشتر',
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(cornerRadius),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                padding: EdgeInsets.zero,
                child: CheckboxListTile(
                  dense: true,
                  value: trafficEnabled,
                  onChanged: (value) => setState(() {
                    trafficEnabled = value ?? false;
                    Navigator.pop(context);
                  }),
                  title: const Text('نمایش ترافیک شهری'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
              PopupMenuItem(
                padding: EdgeInsets.zero,
                child: CheckboxListTile(
                  dense: true,
                  value: hybridType,
                  onChanged: (value) => setState(() {
                    hybridType = value ?? false;
                    Navigator.pop(context);
                  }),
                  title: const Text('تصاویر ماهواره ای'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),
            ],
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 3,
      ),
      body: SafeArea(
        child: GoogleMap(
          padding: const EdgeInsets.only(bottom: 64),
          onMapCreated: (controller) {
            // mapController = controller;
            setState(() {});
          },
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          mapType: hybridType ? MapType.hybrid : MapType.normal,
          trafficEnabled: trafficEnabled,
          initialCameraPosition: CameraPosition(
            target: latLng,
            zoom: 15.0,
          ),
          markers: {
            Marker(
              markerId: MarkerId('${widget.mechanic.id}'),
              position: latLng,
              infoWindow: InfoWindow(title: widget.mechanic.name),
            )
          },
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8),
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
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=${widget.location.lat},${widget.location.long}';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }
}

/*
FlutterMap(
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
      )
*/