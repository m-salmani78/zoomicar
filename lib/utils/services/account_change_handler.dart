import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '/constants/app_constants.dart';
import '../../constants/api_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/account_model.dart';

class AccountChangeHandler {
  int? _carIndex;
  String? _token;
  String _userName = "";

  String? get token => _token;
  String get userName => _userName;

  static final _instance = AccountChangeHandler._getInstance();

  AccountChangeHandler._getInstance();

  factory AccountChangeHandler() => _instance;

  static Future<bool> initialize(
      SharedPreferences prefs, Box<Account> accountBox) async {
    try {
      _instance._initialCar(prefs: prefs, accountBox: accountBox);
      _instance._initialUserName(prefs);
      final token = _instance.initialToken(prefs);
      return token.isNotEmpty;
    } catch (e) {
      log('Initial Exception: ${e.toString()}', name: 'AccountChangeHandler');
      return false;
    }
  }

  // Future setToken(String? value) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   if (value == null || value.isEmpty) {
  //     prefs.remove(SharedPrefsKeys.token_key);
  //     _token = null;
  //     log('@ I: delete token');
  //   } else {
  //     prefs.setString(SharedPrefsKeys.token_key, value);
  //     _token = value;
  //   }
  // }

  // void setUserName(String value, {SharedPreferences? prefs}) {
  //   _userName = value;
  //   if (prefs == null) {
  //     SharedPreferences.getInstance().then((prefs) {
  //       setUserName(value, prefs: prefs);
  //     });
  //   } else {
  //     prefs.setString(userNameKey, value);
  //   }
  // }

  Future setAccount({required String token, required String userName}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefsKeys.token_key, token);
    _token = token;
    log('@ I: set token = $token');
    await prefs.setString(userNameKey, userName);
    _userName = userName;
    log('@ I: set userName = $userName');
  }

  Future<void> deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(SharedPrefsKeys.token_key);
    _token = null;
    log('@ I: delete token');
    await prefs.remove(userNameKey);
    _userName = '';
    log('@ I: delete userName');
  }

  String initialToken(SharedPreferences prefs) {
    String token = prefs.getString(SharedPrefsKeys.token_key)!;
    _token = token;
    log('@ I: initial token = $_token');
    return token;
  }

  _initialCar(
      {required SharedPreferences prefs, required Box<Account> accountBox}) {
    int index = prefs.getInt(SharedPrefsKeys.current_car_index) ?? 0;
    if (accountBox.isEmpty || index >= accountBox.length || index < 0) {
      log('@ I: initial current car. (index = null)');
      _carIndex = null;
      return;
    }
    _carIndex = index;
    log('@ I: initial current car. (index = $index)');
  }

  _initialUserName(SharedPreferences prefs) {
    _userName = prefs.getString(userNameKey)!;
    log('@ I: initial userName = $_userName');
  }

  int? get carIndex => _carIndex;

  set carIndex(int? index) {
    _carIndex = (index != null && index < 0) ? null : index;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(SharedPrefsKeys.current_car_index, index ?? -1);
      log('@ I: car index changed.');
    });
  }

  logout(SharedPreferences prefs) {
    final accountBox = Hive.box<Account>(accountBoxKey);
    accountBox.clear();
    carIndex = null;
    deleteAccount();
  }

  Future<String?> deleteCurrentCar(int id) async {
    final accountBox = Hive.box<Account>(accountBoxKey);
    if (accountBox.isEmpty) return 'خودروی مورد نظر یافت نشد';
    try {
      final response = await http.post(
        Uri.parse(baseUrl + '/car/remove_car'),
        headers: {authorization: _token ?? ''},
        body: {"car_id": id.toString()},
      );
      if (response.statusCode == 200) {
        log('@ Delete Response: ' + response.body);
        var json = jsonDecode(utf8.decode(response.bodyBytes));
        if (json[StatusResponse.key] == StatusResponse.success) {
          accountBox.deleteAt(carIndex ?? 0);
          carIndex = accountBox.isEmpty ? null : 0;
          return null;
        }
        return "خطا در ارسال اطلاعات";
      }
    } catch (_) {}
    return "اتصال برقرار نیست";
  }
}
