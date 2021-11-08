import 'package:flutter/material.dart';
import '/screens/add_car/repos/car_change_notifier.dart';
import '/screens/add_car/repos/interface.dart';
import '/screens/add_car/widgets/pages/page_3.dart';
import 'package:provider/provider.dart';

class Page2 extends StatelessWidget implements IAddCarPage {
  final _formKey = GlobalKey<FormState>();

  Page2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carHandler = Provider.of<CarChangeNotifier>(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          numericTextField(
            labelText: 'آخرین تعویض موتور',
            // labelText: 'Last Motor Repair ',
            initialValue: carHandler.car.lastOilFilterChange,
            onChanged: (value) {
              try {
                carHandler.car.lastMotorRepair = int.parse(value);
              } catch (e) {
                carHandler.car.lastMotorRepair = 0;
              }
            },
          ),
          numericTextField(
            labelText: 'آخرین تعویض گیربکس',
            // labelText: 'Last Gearbox Repair ',
            initialValue: carHandler.car.lastOilFilterChange,
            onChanged: (value) {
              try {
                carHandler.car.lastGearboxRepair = int.parse(value);
              } catch (e) {
                carHandler.car.lastGearboxRepair = 0;
              }
            },
          ),
          numericTextField(
            labelText: 'آخرین تعویض روغن',
            // labelText: 'Last Oil Filter Replacement',
            initialValue: carHandler.car.lastOilFilterChange,
            onChanged: (value) {
              try {
                carHandler.car.lastOilFilterChange = int.parse(value);
              } catch (e) {
                carHandler.car.lastOilFilterChange = 0;
              }
            },
          ),
          numericTextField(
            labelText: 'آخرین تعویض فیلتر بنزین',
            // labelText: 'Last Gasoline Filter Replacement',
            initialValue: carHandler.car.lastGasolineFilterChange,
            onChanged: (value) {
              try {
                carHandler.car.lastGasolineFilterChange = int.parse(value);
              } catch (e) {
                carHandler.car.lastGasolineFilterChange = 0;
              }
            },
          ),
          numericTextField(
            labelText: 'آخرین تعویض فیلتر هوا',
            // labelText: 'Last Air Filter Replacement',
            initialValue: carHandler.car.lastAirFilterChange,
            onChanged: (value) {
              try {
                carHandler.car.lastAirFilterChange = int.parse(value);
              } catch (e) {
                carHandler.car.lastAirFilterChange = 0;
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  bool onGoNext() {
    return _formKey.currentState!.validate();
  }
}
