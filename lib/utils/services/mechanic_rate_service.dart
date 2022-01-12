import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoomicar/constants/api_keys.dart';
import 'package:zoomicar/models/mechanic.dart';
import 'package:zoomicar/models/rate.dart';
import 'package:zoomicar/utils/helpers/show_snack_bar.dart';

import 'account_change_handler.dart';

class MechanicRateService with ChangeNotifier {
  MechanicRateService({required this.mechanic, this.rate = 0, this.text = ''});
  final Mechanic mechanic;
  final baseOptions = BaseOptions(
    baseUrl: baseUrl + '/car',
    headers: {authorization: AccountChangeHandler().token ?? ''},
  );
  int rate;
  String text;
  bool isLoading = false;
  List<Rate>? ratesList;

  Future<List<Rate>> getCenterRates(BuildContext context) async {
    if (ratesList != null) return ratesList!;
    try {
      // final formData = FormData.fromMap({'center_id': '${mechanic.id}'});
      final dio = Dio(baseOptions);
      Response response = await dio.get(
        '/center_rates',
        queryParameters: {'center_id': '${mechanic.id}'},
      );
      log(response.data.toString(), name: 'getCenterRates');
      if (response.data['status'] == 'success') {
        ratesList = ratesFromMap(response.data['data']);
        return ratesList!;
      } else if (response.data['status'] == 'failed') {
        showWarningSnackBar(context, message: response.data['error']);
      }
    } on DioError catch (e, _) {
      log(e.toString(), name: 'error');
    }
    throw Exception();
  }

  Future<bool> sendComment(BuildContext context) async {
    isLoading = true;
    notifyListeners();
    try {
      final formData = FormData.fromMap(
          {"center_id": '${mechanic.id}', "rate": '$rate', "text": text});
      final dio = Dio(baseOptions);
      Response response = await dio.post(
        '/rate_center',
        data: formData,
      );
      log(response.toString(), name: 'sendComment');
      if (response.data['status'] == 'success') {
        showSuccessSnackBar(context, message: 'نظر شما با موفقیت ثبت شد.');
        mechanic.userRate = rate;
        mechanic.userComment = text;
        return true;
      } else {
        showWarningSnackBar(context, message: response.data['error']);
      }
    } on DioError catch (e, _) {
      showWarningSnackBar(context, message: 'اتصال برقرار نیست!');
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return false;
  }
}
