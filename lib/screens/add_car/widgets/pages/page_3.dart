import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/screens/add_car/repos/car_change_notifier.dart';
import '/screens/add_car/repos/interface.dart';
import 'package:provider/provider.dart';

class Page3 extends StatelessWidget implements IAddCarPage {
  const Page3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carHandler = Provider.of<CarChangeNotifier>(context);
    return Column(
      children: [
        numericTextField(
          labelText: 'آخرین تعویض روغن موتور',
          // labelText: 'Last engine oil change',
          initialValue: carHandler.car.lastEngineOilChange,
          onChanged: (value) {
            try {
              carHandler.car.lastEngineOilChange = int.parse(value);
            } catch (e) {
              carHandler.car.lastEngineOilChange = 0;
            }
          },
        ),
        numericTextField(
          labelText: 'آخرین تعویض روغن گیربکس',
          // labelText: 'Last gearbox change',
          initialValue: carHandler.car.lastGearboxOilChange,
          onChanged: (value) {
            try {
              carHandler.car.lastGearboxOilChange = int.parse(value);
            } catch (e) {
              carHandler.car.lastGearboxOilChange = 0;
            }
          },
        ),
        numericTextField(
          labelText: 'آخرین تعویض لنت ترمز',
          // labelText: 'Last BrakePad Replacement',
          initialValue: carHandler.car.lastBrakepadChange,
          onChanged: (value) {
            try {
              carHandler.car.lastBrakepadChange = int.parse(value);
            } catch (e) {
              carHandler.car.lastBrakepadChange = 0;
            }
          },
        ),
        numericTextField(
          labelText: 'آخرین تعویض تسمه تایم',
          // labelText: 'Last TimingBelt Replacement',
          initialValue: carHandler.car.lastTimingbeltChange,
          onChanged: (value) {
            try {
              carHandler.car.lastTimingbeltChange = int.parse(value);
            } catch (e) {
              carHandler.car.lastTimingbeltChange = 0;
            }
          },
        ),
        numericTextField(
          labelText: 'آخرین تعویض تایر',
          // labelText: 'Last Tire Change',
          initialValue: carHandler.car.lastTireChange,
          onChanged: (value) {
            try {
              carHandler.car.lastTireChange = int.parse(value);
            } catch (e) {
              carHandler.car.lastTireChange = 0;
            }
          },
        ),
      ],
    );
  }

  @override
  bool onGoNext() {
    return true;
  }
}

Widget numericTextField(
    {required String labelText,
    ValueChanged<String>? onChanged,
    int? initialValue = 0}) {
  return Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 18),
    child: TextFormField(
      initialValue: initialValue == 0 ? null : initialValue.toString(),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textInputAction: TextInputAction.next,
      onChanged: onChanged,
      textDirection: TextDirection.ltr,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
        label: Text(
          labelText + ':',
          style: const TextStyle(fontSize: 20, fontFamily: "IranianSans"),
        ),
        prefix: const Text(
          '(اختیاری)',
          style: TextStyle(fontSize: 14),
        ),
        hintTextDirection: TextDirection.ltr,
        hintText: '0 Km',
        labelStyle: const TextStyle(fontSize: 18),
      ),
    ),
  );
}
