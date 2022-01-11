import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:zoomicar/constants/api_keys.dart';
import 'package:zoomicar/models/mechanic.dart';
import 'package:zoomicar/utils/helpers/show_snack_bar.dart';

import 'account_change_handler.dart';

class MechanicsService extends ChangeNotifier {
  static final _instance = MechanicsService._();
  CustomLocation? _location;
  final List<Mechanic> _mechanics = [];
  final List<Mechanic> _advertises = [];

  List<Mechanic> get advertise => _advertises;
  List<Mechanic> get mechanics => _mechanics;
  CustomLocation? get location => _location;

  MechanicsService._();
  factory MechanicsService() => _instance;

  Future<CustomLocation> getLocation(BuildContext context) async {
    if (_location == null) {
      Location location = Location();
      PermissionStatus permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.denied) {
        PermissionStatus permissionStatus = await location.requestPermission();
        bool result = permissionStatus == PermissionStatus.granted;
        if (!result) {
          showWarningSnackBar(context,
              message:
                  'برای ارائه خدمات بهتر لطفا اجازه دسترسی به مکان را تایید کنید.');
          throw Exception();
        }
      }
      bool serviceEnabled = await location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await location.requestService();
        if (!serviceEnabled) throw Exception();
      }
      final locationData = await location.getLocation();
      _location = CustomLocation(
        long: locationData.longitude ?? 0,
        lat: locationData.latitude ?? 0,
      );
    }
    return _location!;
  }

  Future<List<Mechanic>> getServiceCenters(CustomLocation location) async {
    if (_mechanics.isEmpty) {
      Dio dio = Dio(BaseOptions(
        baseUrl: baseUrl,
        headers: {authorization: AccountChangeHandler().token ?? ''},
      ));
      Response response = await dio.post(
        '/car/service_centers',
        data: {"long": location.long, "lat": location.lat},
      );
      _advertises.clear();
      mechanicsFromList(
          data: response.data, mechanics: _mechanics, advertise: _advertises);
    }
    return _advertises + _mechanics;
  }
}
