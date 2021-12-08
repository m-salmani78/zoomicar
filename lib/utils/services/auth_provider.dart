import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:zoomicar/constants/api_keys.dart';
import 'package:zoomicar/screens/home/home_screen.dart';
import 'package:zoomicar/utils/helpers/show_snack_bar.dart';
import 'package:zoomicar/utils/services/account_change_handler.dart';

class AuthProvider extends ChangeNotifier {
  final formKey = GlobalKey<FormState>();
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: baseUrl + '/account',
      connectTimeout: 4000,
      receiveTimeout: 4000,
    ),
  );
  bool isLoading = false;

  void login(BuildContext context,
      {required String mobile, required void Function() onReceived}) async {
    isLoading = true;
    notifyListeners();
    try {
      log('mobile = $mobile');
      FormData formData = FormData.fromMap({"mobile": mobile});
      Response response = await dio.post('/login', data: formData);
      log('response: ' + response.toString(), name: 'login');
      log('data: ' + response.data.toString(), name: 'login');
      Map data = response.data;
      if (data[StatusResponse.key] == StatusResponse.success) {
        onReceived();
      } else {
        showWarningSnackBar(context, message: data['error']);
      }
    } on DioError catch (e, _) {
      log('error to string:  ' + e.toString());
      log('error to message:  ' + e.message);
      log('error to response:  ' + e.response.toString());
      showWarningSnackBar(context, message: 'اتصال برقرار نیست');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void register(BuildContext context,
      {required String mobile,
      required String userName,
      required void Function() onReceived}) async {
    isLoading = true;
    notifyListeners();
    try {
      log('mobile = $mobile');
      log('username = $userName');
      FormData formData =
          FormData.fromMap({"mobile": mobile, "username": userName});
      Response response = await dio.post(
        '/register',
        data: formData,
      );
      log('response: ' + response.toString(), name: 'register');
      Map data = response.data;
      if (data[StatusResponse.key] == StatusResponse.success) {
        onReceived();
      } else {
        showWarningSnackBar(context, message: data['error']);
      }
    } on DioError catch (e, _) {
      showWarningSnackBar(context, message: 'اتصال برقرار نیست');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void verifyCode(BuildContext context,
      {required String type,
      required String mobile,
      required String code}) async {
    isLoading = true;
    notifyListeners();
    try {
      FormData formData = FormData.fromMap({"mobile": mobile, "code": code});
      Response response = await dio.post(
        '/verify_${type}_code',
        data: formData,
      );
      log('sendCode statusCode : ${response.statusCode}');
      log('response:' + response.toString(), name: 'verify_code');
      Map data = response.data;
      if (data[StatusResponse.key] == StatusResponse.success) {
        await AccountChangeHandler()
            .setAccount(token: data['token'], userName: data['username']);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (route) => false,
        );
      } else {
        showWarningSnackBar(context, message: data['error']);
      }
    } on DioError catch (e, _) {
      showWarningSnackBar(context, message: 'اتصال برقرار نیست');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
