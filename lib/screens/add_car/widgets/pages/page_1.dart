import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '/constants/app_constants.dart';
import '../../../../constants/api_keys.dart';
import '/models/car_model.dart';
import 'package:provider/provider.dart';
import '/screens/add_car/repos/car_change_notifier.dart';
import '/screens/add_car/repos/interface.dart';

import '../custom_dropdown.dart';
import '../third_party_insurance.dart';

class Page1 extends StatefulWidget implements IAddCarPage {
  final _formKey = GlobalKey<FormState>();

  Page1({Key? key}) : super(key: key);
  @override
  _Page1State createState() => _Page1State();

  @override
  bool onGoNext() {
    return _formKey.currentState!.validate();
  }
}

class _Page1State extends State<Page1> {
  int? index;
  @override
  Widget build(BuildContext context) {
    final carHandler = Provider.of<CarChangeNotifier>(context);
    return Form(
      key: widget._formKey,
      child: Column(
        children: [
          const SizedBox(height: 8),
          ChooseCarParameter(
            onFind: (filter) async {
              var response =
                  await http.get(Uri.parse(baseUrl + '/car/carnames_list'));
              log('@ carnames: ' + response.body);
              final json = jsonDecode(utf8.decode(response.bodyBytes));
              final names = (json[0] as List).map((e) => e.toString()).toList();
              return names
                  .where((item) => item.toString().contains(filter ?? ''))
                  .toList();
            },
            hint: 'برند خودرو*',
            initialValue:
                carHandler.car.name == '' ? null : carHandler.car.name,
            onChanged: (value) => carHandler.car.name = value ?? '',
            validator: (value) {
              if (value == null || value.isEmpty) {
                return requiredInputError;
              }
            },
          ),
          const SizedBox(height: 24),
          ChooseCarParameter(
            onFind: (filter) async {
              var response =
                  await http.get(Uri.parse(baseUrl + '/car/carnames_dict'));
              log('@ carnames: ' + response.body);
              try {
                final json = jsonDecode(utf8.decode(response.bodyBytes));
                final names = (json[carHandler.car.name] as List)
                    .map((e) => e.toString())
                    .toList();
                return names
                    .map((e) => e.toString())
                    .where((item) => item.contains(filter ?? ''))
                    .toList();
              } catch (e) {
                return [];
              }
            },
            hint: 'مدل خودرو*',
            initialValue:
                carHandler.car.model == '' ? null : carHandler.car.model,
            onChanged: (value) {
              carHandler.car.model = value ?? '';
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return requiredInputError;
              }
            },
          ),
          const SizedBox(height: 24),
          _buildKilometer(
            carHandler,
            onChanged: (value) {
              try {
                carHandler.car.kilometerage = int.parse(value);
              } catch (e) {
                carHandler.car.kilometerage = 0;
              }
            },
          ),
          const SizedBox(height: 24),
          ThirdPartyInsurance(
            initialValue: carHandler.car.thirdPartyInsurance != null
                ? shamsiToString(carHandler.car.thirdPartyInsurance!)
                : null,
            onSaved: (value) {
              carHandler.car.thirdPartyInsurance = value;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKilometer(CarChangeNotifier notifier,
      {Function(String)? onChanged}) {
    return Row(
      children: [
        const Expanded(
            child: Text(
          'کیلومتر خودرو*',
          style: TextStyle(fontSize: 16),
        )),
        Flexible(
          child: TextFormField(
            initialValue: notifier.car.kilometerage == 0
                ? null
                : notifier.car.kilometerage.toString(),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textDirection: TextDirection.ltr,
            decoration: const InputDecoration(
              hintTextDirection: TextDirection.ltr,
              hintText: '0 Km',
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) return requiredInputError;
            },
            onChanged: onChanged,
          ),
        )
      ],
    );
  }
}
