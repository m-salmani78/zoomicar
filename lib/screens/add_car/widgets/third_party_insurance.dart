import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '/models/car_model.dart';

class ThirdPartyInsurance extends StatefulWidget {
  final ValueChanged<Jalali> onSaved;
  final void Function() onDismissed;
  final String? initialValue;
  const ThirdPartyInsurance(
      {required this.onSaved, this.initialValue, required this.onDismissed});

  @override
  _ThirdPartyInsuranceState createState() => _ThirdPartyInsuranceState();
}

class _ThirdPartyInsuranceState extends State<ThirdPartyInsurance> {
  late TextEditingController _controller;
  String date = shamsiToString(Jalali.now());

  @override
  void dispose() {
    log('dispose controller', name: 'ThirdPartyInsurance');
    _controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _controller = TextEditingController(
        text: widget.initialValue?.split('/').reversed.join(' / '));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            'بیمه شخص ثالث:',
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        Flexible(
          child: TextFormField(
            readOnly: true,
            textAlign: TextAlign.center,
            controller: _controller,
            decoration: const InputDecoration(
              hintText: '00 / 00 / 00',
              contentPadding: EdgeInsets.all(12),
            ),
            onTap: () async {
              final result = await showCupertinoModalPopup<String>(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    actions: [
                      _buildDatePicker(),
                    ],
                    title: const Text('انتخاب تاریخ',
                        style: TextStyle(fontFamily: "IranianSans")),
                    cancelButton: CupertinoActionSheetAction(
                      onPressed: () => Navigator.of(context).pop('confirm'),
                      child: const Text(
                        'تایید',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: "IranianSans",
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  );
                },
              );
              if (result == null) {
                _controller.clear();
                widget.onDismissed();
              } else {
                _controller.text = date.split('/').reversed.join(' / ');
                widget.onSaved(shamsiFromString(date)!);
              }
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker() {
    return Container(
      padding: const EdgeInsets.only(top: 8),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: LinearDatePicker(
            initialDate: date,
            endDate: shamsiToString(Jalali.now()),
            dateChangeListener: (value) {
              date = value;
            },
            showDay: true, //false -> only select year & month
            labelStyle: TextStyle(
              fontFamily: "IranianSans",
              fontSize: 16.0,
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.none,
            ),
            selectedRowStyle: TextStyle(
              fontFamily: "IranianSans",
              fontSize: 18.0,
              color: Theme.of(context).colorScheme.onBackground,
              decoration: TextDecoration.none,
            ),
            unselectedRowStyle: TextStyle(
              fontFamily: "IranianSans",
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color:
                  Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
              decoration: TextDecoration.none,
            ),
            showLabels: true,
            columnWidth: MediaQuery.of(context).size.width / 3 - 8,
            showMonthName: true,
            isJalaali: true),
      ),
    );
  }
}
