import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoomicar/constants/api_keys.dart';
import '/constants/app_constants.dart';
import '/screens/add_car/add_car.dart';
import '/screens/specifications/widgets/menu.dart';
import '../../utils/services/account_change_handler.dart';
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
        : accountBox.getAt(AccountChangeHandler().carIndex ?? 0)!.car;
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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Center(
                  child: Image.network(
                    baseUrl + car.image,
                    width: MediaQuery.of(context).size.width - 32,
                    height: MediaQuery.of(context).size.height * 0.2,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(height: 8),
                  ),
                ),
                const SizedBox(height: 8),
                ...items(car),
                const SizedBox(height: 16),
                Center(
                  child: Image.asset('assets/images/ringsport.png', height: 64),
                ),
                const Center(
                    child: Text(
                  'نسخه 1.0.0',
                  style: TextStyle(height: 1),
                )),
              ],
            ),
    );
  }

  List<Widget> items(Car car) => [
        _buildRow(name: 'نام', value: car.model, hasKilometer: false),
        _buildRow(
          name: 'کیلومتر خودرو',
          value: car.kilometerage.toString(),
        ),
        _buildRow(
            name: 'بیمه شخص ثالث',
            value: (car.thirdPartyInsurance == null)
                ? ''
                : '${car.thirdPartyInsurance!.year} / ${car.thirdPartyInsurance!.month} / ${car.thirdPartyInsurance!.day}',
            hasKilometer: false),
        _buildRow(
            name: 'وضعیت استفاده از خودرو',
            value: carUseItems.keys.toList()[car.carUseAmount.index],
            hasKilometer: false),
        _buildRow(
          name: 'سابقه تعمیر موتور',
          value: car.lastMotorRepair.toString(),
        ),
        _buildRow(
            name: 'سابقه تعمیر گیربکس',
            value: car.lastGearboxRepair.toString()),
        _buildRow(
            name: 'آخرین تعویض فیلتر روغن',
            value: car.lastOilFilterChange.toString()),
        _buildRow(
            name: 'آخرین تعویض فیلتر بنزین',
            value: car.lastGasolineFilterChange.toString()),
        _buildRow(
            name: 'آخرین تعویض فیلتر هوا',
            value: car.lastAirFilterChange.toString()),
        _buildRow(
            name: 'آخرین تعویض روغن موتور',
            value: car.lastEngineOilChange.toString()),
        _buildRow(
            name: 'آخرین تعویض روغن گیربکس',
            value: car.lastGearboxOilChange.toString()),
        _buildRow(
            name: 'آخرین تعویض لنت ترمز',
            value: car.lastBrakepadChange.toString()),
        _buildRow(
            name: 'آخرین تعویض تسمه تایم',
            value: car.lastTimingbeltChange.toString()),
        _buildRow(
          name: 'آخرین تعویض تایر',
          value: car.lastTireChange.toString(),
        ),
      ]
          .expand((element) =>
              [element, const Divider(height: 32, indent: 8, endIndent: 8)])
          .toList();

  Widget _buildRow(
      {required String name, required String value, bool hasKilometer = true}) {
    return Row(
      children: [
        Text(
          name,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(
          value + (hasKilometer ? ' km' : ''),
          textDirection: TextDirection.ltr,
        )
      ],
    );
  }
}
