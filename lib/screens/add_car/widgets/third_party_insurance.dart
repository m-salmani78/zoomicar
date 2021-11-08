import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_linear_datepicker/flutter_datepicker.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '/models/car_model.dart';

class ThirdPartyInsurance extends StatefulWidget {
  final ValueChanged<Jalali> onSaved;
  final String? initialValue;
  // ignore: use_key_in_widget_constructors
  const ThirdPartyInsurance({required this.onSaved, this.initialValue});

  @override
  _ThirdPartyInsuranceState createState() => _ThirdPartyInsuranceState();
}

class _ThirdPartyInsuranceState extends State<ThirdPartyInsurance> {
  String date = shamsiToString(Jalali.now());

  @override
  Widget build(BuildContext context) {
    final _controller = TextEditingController(text: widget.initialValue);
    return Row(
      children: [
        Expanded(
          child: Text(
            'بیمه شخص ثالث:',
            // 'Third Party Insurance:',
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
              contentPadding: EdgeInsets.symmetric(horizontal: 12),
            ),
            onTap: () async {
              var result = await showCupertinoModalPopup<String>(
                context: context,
                builder: (context) {
                  return CupertinoActionSheet(
                    actions: [
                      _buildDatePicker(),
                    ],
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
              } else {
                _controller.text = date;
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
      color: Colors.white,
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
            selectedRowStyle: const TextStyle(
              fontFamily: "IranianSans",
              fontSize: 18.0,
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
            unselectedRowStyle: const TextStyle(
              fontFamily: "IranianSans",
              fontSize: 16.0,
              fontWeight: FontWeight.normal,
              color: Colors.black45,
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
