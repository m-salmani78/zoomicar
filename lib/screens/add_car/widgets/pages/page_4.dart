import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import '/models/car_model.dart';
import '/screens/add_car/repos/interface.dart';
import 'package:provider/provider.dart';
import '/constants/app_constants.dart';
import '/screens/add_car/repos/car_change_notifier.dart';

final Map<String, String> carUseItems = {
  'تمام وقت': '8 ساعت در روز',
  // 'Full time': '8 hours a day',
  'پرمصرف': 'سالیانه بیش از 50000 کیلومتر یا روزانه بیش از 300 کیلومتر پیمایش',
  // 'High consumption':'More than 50,000 km per year or more than 300 km per day',
  'متوسط': 'سالیانه مابین 10000 الی 50000 یا روزانه حدود 100 کیلومتر پیمایش',
  // 'Medium': 'Between 10,000 and 50,000 annually or about 100 km per day',
  'کم مصرف': 'سالیانه کمتر از 10000 کیلومتر یا روزانه 30 کیلومتر پیمایش',
};

class Page4 extends StatelessWidget implements IAddCarPage {
  final String hint = '0 Km';

  final TextEditingController _controller = TextEditingController();

  final BoxShadow _boxShadow = const BoxShadow(
    color: Color.fromARGB(45, 27, 27, 27),
    blurRadius: 4,
    spreadRadius: 0,
    offset: Offset(0.0, 2.0),
  );

  Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carHandler = Provider.of<CarChangeNotifier>(context);
    return Column(
      children: [
        const Text(
          'میزان استفاده از خودرو:',
          // 'The amount of car use:',
          style: TextStyle(fontSize: 22),
        ),
        const SizedBox(height: 16),
        GroupButton(
          spacing: 16,
          borderRadius: BorderRadius.circular(32),
          buttonWidth: MediaQuery.of(context).size.width * 0.6,
          selectedColor: Theme.of(context).colorScheme.primary,
          selectedTextStyle: const TextStyle(fontSize: 18),
          unselectedTextStyle:
              const TextStyle(fontSize: 18, color: Colors.black),
          buttonHeight: 50,
          selectedButton: -1,
          unselectedShadow: [_boxShadow],
          selectedShadow: [_boxShadow],
          buttons: carUseItems.keys.toList(),
          onSelected: (index, flag) {
            carHandler.car.carUseAmount = CarUseAmount.values[index];
            _controller.text = carUseItems.values.toList()[index];
          },
        ),
        const SizedBox(height: 48),
        _buildDescriptionTxt(),
      ],
    );
  }

  _buildDescriptionTxt() {
    return TextField(
      readOnly: true,
      controller: _controller,
      minLines: 1,
      maxLines: 10,
      autofocus: true,
      decoration: InputDecoration(
        labelText: 'توضیحات:',
        // labelText: 'Description:',
        hintText: 'یک مورد را انتخاب کنید.',
        // hintText: 'Choose an item.',
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(cornerRadius),
        ),
      ),
    );
  }

  @override
  bool onGoNext() {
    return _controller.text.isNotEmpty;
  }
}
