import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '/constants/app_constants.dart';
import '/utils/helpers/account_change_handler.dart';
import '/utils/services/api_keys.dart';
import '/models/car_model.dart';
import '/models/account_model.dart';
import 'package:http/http.dart' as http;

import 'widgets/body.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final accountBox = Hive.box<Account>(accountBoxKey);

  @override
  Widget build(BuildContext context) {
    int? index = AccountChangeHandler.carIndex;
    return (accountBox.isEmpty || index == null)
        ? FutureBuilder(
            future: http.get(
              Uri.parse(baseUrl + '/car/user_cars'),
              headers: {authorization: AccountChangeHandler.token ?? ''},
            ),
            builder: (context, snapshot) {
              if (snapshot.hasError) return const Body(account: null);
              if (snapshot.connectionState == ConnectionState.done) {
                final response = snapshot.data as http.Response;
                log('@ StatusCode: ${response.statusCode}');
                log('@ Response: ${response.body}');
                if (response.statusCode == 200) {
                  List json = jsonDecode(utf8.decode(response.bodyBytes));
                  final List<Car> cars =
                      json.map((item) => Car.fromJson(item)).toList();
                  if (cars.isNotEmpty) {
                    accountBox.putAll({
                      for (var element in cars)
                        element.carId: Account(car: element)
                    });
                    AccountChangeHandler.carIndex = 0;
                    return Body(account: accountBox.getAt(0));
                  }
                  return const Body(account: null);
                }
              }
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            },
          )
        : Body(account: accountBox.getAt(index));
  }
}
