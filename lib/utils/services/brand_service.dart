import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoomicar/constants/api_keys.dart';
import 'package:zoomicar/utils/helpers/show_snack_bar.dart';

import 'account_change_handler.dart';

class BrandService {
  BrandService._();

  static final dio = Dio(BaseOptions(
    baseUrl: baseUrl + '/car',
    headers: {authorization: AccountChangeHandler().token ?? ''},
  ));

  static Future<Map<String, dynamic>> getBrands(BuildContext context,
      {required String accessory}) async {
    try {
      Response response = await dio.post('/brands',
          data: FormData.fromMap({'accessory': accessory}));
      log(response.toString());
      return response.data as Map<String, dynamic>;
    } on DioError catch (e, _) {
      log(e.toString());
      showWarningSnackBar(context, message: 'اتصال برقرار نیست!');
    }
    throw Exception();
  }

  static Future<bool> rateBrand(BuildContext context,
      {required int brandId, required double rate}) async {
    if (rate <= 0) {
      showWarningSnackBar(context, message: 'ابتدا امتیاز خود را وارد کنید.');
      return false;
    }
    log('id = $brandId , rate = $rate');
    try {
      Response response = await dio.post('/rate_brand',
          data: FormData.fromMap({"brand_id": brandId, "rate": rate}));
      if (response.data["status"] == "success") {
        showSuccessSnackBar(context, message: 'امتیاز شما با موفقیت ارسال شد.');
        return true;
      }
      showWarningSnackBar(context, message: '');
    } catch (e) {
      showWarningSnackBar(context, message: 'اتصال  برقرار نیست!');
    }
    return false;
  }
}
