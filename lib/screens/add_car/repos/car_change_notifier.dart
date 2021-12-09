import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:zoomicar/utils/helpers/show_snack_bar.dart';
import '/constants/app_constants.dart';
import '/screens/home/home_screen.dart';
import '../../../utils/services/account_change_handler.dart';
import '../../../constants/api_keys.dart';
import '/models/car_model.dart';
import '/models/account_model.dart';

class CarChangeNotifier with ChangeNotifier {
  final Dio dio = Dio(
    BaseOptions(
        baseUrl: baseUrl + '/car',
        headers: {authorization: AccountChangeHandler().token ?? ''},
        connectTimeout: 4000,
        receiveTimeout: 4000),
  );
  final int pagesCount;
  final Car car;
  final Box<Account> accountBox = Hive.box(accountBoxKey);
  final PageController pageController = PageController(initialPage: 0);
  int currentPage = 0;

  CarChangeNotifier({required this.pagesCount, required this.car});

  void _confirmCar(BuildContext context, bool isEditMode) async {
    try {
      Response response = await dio.post(
        isEditMode ? '/edit_car' : '/register_car',
        data: FormData.fromMap(car.toJson(id: isEditMode ? car.carId : null)),
      );
      log('@ StatusCode: ${response.statusCode}');
      if (response.statusCode == 200) {
        log('@ Response:' + response.toString());
        Map<String, dynamic> data = response.data;
        if (data[StatusResponse.key] == StatusResponse.success) {
          try {
            car.image = data["image"];
          } catch (e) {
            log('@ Error: image key is not exist :(');
            car.image = "";
          }
          if (!isEditMode) {
            car.carId = data["car_id"] ?? -1;
            AccountChangeHandler().carIndex = accountBox.length;
            accountBox.put(car.carId, Account(car: car));
            notifyListeners();
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
          showWarningSnackBar(context, message: 'اطلاعات وارد شده ناقص است');
        }
      }
    } on DioError catch (e, _) {
      Navigator.pop(context);
      showWarningSnackBar(context, message: 'خطا در ارسال اطلاعات');
    }
  }

  Future<void> nextPage(BuildContext context,
      {required bool Function(int) onGoNext, required bool isEditMode}) async {
    bool isCompleted = onGoNext(currentPage);
    if (!isCompleted) return;
    if (currentPage == pagesCount - 1) {
      showDialog(
        context: context,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );
      _confirmCar(context, isEditMode);
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
}
