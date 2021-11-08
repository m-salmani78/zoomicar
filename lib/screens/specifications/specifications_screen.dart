import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '/constants/app_constants.dart';
import '/screens/add_car/add_car.dart';
import '/screens/specifications/widgets/menu.dart';
import '/utils/helpers/account_change_handler.dart';
import '/models/car_model.dart';
import '/models/account_model.dart';

class SpecificationsScreen extends StatefulWidget {
  const SpecificationsScreen({Key? key}) : super(key: key);

  @override
  _SpecificationsScreenState createState() => _SpecificationsScreenState();
}

class _SpecificationsScreenState extends State<SpecificationsScreen> {
  final accountBox = Hive.box<Account>(accountBoxKey);

  @override
  Widget build(BuildContext context) {
    final Car? car = accountBox.isEmpty
        ? null
        : accountBox.getAt(AccountChangeHandler.carIndex ?? 0)!.car;
    return Scaffold(
      appBar: AppBar(
        title: const Text('مشخصات خودرو'),
        actions: car == null
            ? null
            : [
                IconButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      builder: (context) => MenuItems(car: car),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
      ),
      body: car == null
          ? Center(
              child: OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddCarScreen(),
                        ));
                  },
                  child: const Text('افزودن خودرو')))
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                ...items(car),
                const SizedBox(height: 16),
                Image.asset('assets/images/ringsport.png', height: 64),
                const Center(child: Text('نسخه 1.0.0')),
              ],
            ),
    );
  }

  List<Widget> items(Car car) => [
        _buildRow(
          name: 'نام',
          value: car.model,
        ),
        _buildRow(
          name: 'کیلومتر خودرو',
          value: car.kilometerage.toString(),
        ),
        _buildRow(
            name: 'بیمه شخص ثالث',
            // name: 'ThirdPartyInsurance',
            value: (car.thirdPartyInsurance == null)
                ? ''
                : '${car.thirdPartyInsurance!.year} / ${car.thirdPartyInsurance!.month} / ${car.thirdPartyInsurance!.month}'),
        _buildRow(
            name: 'آخرین تعویض فیلتر هوا',
            // name: 'Last Air Filter Replacement',
            value: car.lastAirFilterChange.toString()),
        _buildRow(
            name: 'آخرین تعویض لنت ترمز',
            // name: 'Last Brake Pad Replacement',
            value: car.lastBrakepadChange.toString()),
        _buildRow(
            name: 'آخرین تعویض گیربکس',
            // name: 'Last Engine Gearbox Change',
            value: car.lastGearboxOilChange.toString()),
        _buildRow(
            name: 'آخرین تعویض روغن موتور',
            // name: 'Last Engine Oil Change',
            value: car.lastEngineOilChange.toString()),
        _buildRow(
            name: 'آخرین تعویض فیلتر روغن',
            value: car.lastGasolineFilterChange.toString()),
        _buildRow(
            name: 'آخرین دفعه تعمیر گیربکس',
            // name: 'Last Gearbox Repair',
            value: car.lastGearboxRepair.toString()),
        _buildRow(
          name: 'آخرین دفعه تعمیر موتور',
          // name: 'Last Motor Repair',
          value: car.lastMotorRepair.toString(),
        ),
        _buildRow(
            name: 'آخرین تعویض فیلتر روغن',
            // name: 'Last Oil Filter Replacement',
            value: car.lastOilFilterChange.toString()),
        _buildRow(
            name: 'آخرین تعویض تسمه تایم',
            // name: 'Last Timing Belt Replacement',
            value: car.lastTimingbeltChange.toString()),
        _buildRow(
          name: 'آخرین تعویض تایر',
          // name: 'Last Tire Change',
          value: car.lastTireChange.toString(),
        ),
        _buildRow(
            name: 'میزان استفاده از خودرو',
            value: car.carUseAmount.toString().split('.')[1]),
      ].expand((element) => [element, const Divider(height: 32)]).toList();

  Widget _buildRow({required String name, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          Text(value, textDirection: TextDirection.ltr)
        ],
      ),
    );
  }
}
