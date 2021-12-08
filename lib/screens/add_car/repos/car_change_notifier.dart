import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '/constants/app_constants.dart';
import '/screens/home/home_screen.dart';
import '../../../utils/services/account_change_handler.dart';
import '../../../constants/api_keys.dart';
import '/models/car_model.dart';
import '/models/account_model.dart';

class CarChangeNotifier with ChangeNotifier {
  final int pagesCount;
  final Car car;
  final Box<Account> accountBox = Hive.box(accountBoxKey);
  final PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;

  CarChangeNotifier({required this.pagesCount, required this.car});

  void _addCar() {
    accountBox.put(car.carId, Account(car: car));
    notifyListeners();
  }

  Future<void> nextPage(BuildContext context,
      {required bool Function(int) onGoNext, required bool isEditMode}) async {
    bool isCompleted = onGoNext(currentPage);
    if (!isCompleted) return;
    if (currentPage == pagesCount - 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      log('last page');
      final body = car.toJson(id: isEditMode ? car.carId : null);
      log('@ body: ' + body.toString());
      await http
          .post(
        Uri.parse(
            baseUrl + (isEditMode ? '/car/edit_car' : '/car/register_car')),
        headers: {authorization: AccountChangeHandler().token ?? ''},
        body: body,
      )
          .then((response) {
        log('@ StatusCode: ${response.statusCode}');
        if (response.statusCode == 200) {
          log('@ Response:' + response.body);
          Map<String, dynamic> json =
              jsonDecode(utf8.decode(response.bodyBytes));
          if (json[StatusResponse.key] == StatusResponse.success) {
            try {
              car.image = json["image"];
            } catch (e) {
              log('@ Error: image key is not exist :(');
              car.image = "";
            }
            if (!isEditMode) {
              car.carId = json["car_id"] ?? -1;
              AccountChangeHandler().carIndex = accountBox.length;
              _addCar();
              log('finished adding');
            } else {
              // int key = accountBox.keyAt(AccountChangeHandler.carIndex ?? 0);
              accountBox.delete(car.carId);
              accountBox.put(car.carId, Account(car: car));
              log('finished editing');
            }
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false);
          } else {
            Navigator.pop(context);
            showDialog(
              context: context,
              builder: (context) =>
                  _buildAlertDialog(context, 'اطلاعات وارد شده ناقص است'),
            );
          }
        }
      }).onError((error, stackTrace) {
        if (error == null) return;
        Navigator.pop(context);
        showDialog(
          context: context,
          builder: (context) =>
              _buildAlertDialog(context, 'خطا در ارسال اطلاعات'),
        );
      });
    } else {
      currentPage++;
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage(int index) {
    currentPage = index;
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildAlertDialog(BuildContext context, String title) {
    return AlertDialog(
      content: Text(title),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("تلاش مجدد")),
        TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false);
            },
            child: const Text("بازگشت")),
      ],
    );
  }
}
