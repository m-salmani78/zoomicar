import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import '/models/car_model.dart';
import '/screens/add_car/repos/interface.dart';
import 'package:provider/provider.dart';
import '/constants/app_constants.dart';
import '/screens/add_car/repos/car_change_notifier.dart';

class Page4 extends StatelessWidget implements IAddCarPage {
  final TextEditingController _controller = TextEditingController();

  final BoxShadow _boxShadow = const BoxShadow(
    color: Color.fromARGB(45, 27, 27, 27),
    blurRadius: 3,
    spreadRadius: -0.5,
    offset: Offset(-0.5, 2.0),
  );

  Page4({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final carHandler = Provider.of<CarChangeNotifier>(context);
    return Column(
      children: [
        const Text(
          'میزان استفاده از خودرو:',
          style: TextStyle(fontSize: 18),
        ),
        const SizedBox(height: 8),
        GroupButton(
          spacing: 8,
          groupingType: GroupingType.column,
          borderRadius: BorderRadius.circular(32),
          buttonWidth: MediaQuery.of(context).size.width * 0.6,
          selectedColor: Theme.of(context).colorScheme.primary,
          unselectedColor: Theme.of(context).cardColor,
          selectedTextStyle: const TextStyle(fontSize: 18),
          unselectedTextStyle: TextStyle(
              fontSize: 18,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : null),
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
        hintText: 'یک مورد را انتخاب کنید.',
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
