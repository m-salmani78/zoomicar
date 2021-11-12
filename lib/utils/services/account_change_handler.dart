import 'dart:convert';
import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '/constants/app_constants.dart';
import '../../constants/api_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/account_model.dart';

class AccountChangeHandler {
  static int? _carIndex;
  static String? _token;
  static String _userName = "";

  static String? get token => _token;
  static String get userName => _userName;

  static setToken(
      {required SharedPreferences prefs,
      String? value,
      Box<Account>? accountBox}) {
    if (value == null || value.isEmpty) {
      prefs.remove(SharedPrefsKeys.token_key);
      AccountChangeHandler._token = null;
      var box = accountBox ?? Hive.box<Account>(accountBoxKey);
      box.clear();
      log('@ I: delete token');
    } else {
      prefs.setString(SharedPrefsKeys.token_key, value);
      log('@ I: set token');
      AccountChangeHandler._token = value;
    }
  }

  static void setUserName(String value, {SharedPreferences? prefs}) {
    _userName = value;
    if (prefs == null) {
      SharedPreferences.getInstance().then((prefs) {
        setUserName(value, prefs: prefs);
      });
    } else {
      prefs.setString(userNameKey, value);
      log('@ I: set userName');
    }
  }

  static String? initialToken(SharedPreferences prefs) {
    try {
      String? token = prefs.getString(SharedPrefsKeys.token_key);
      AccountChangeHandler._token = token;
      log('@ I: initial token');
      return token;
    } catch (e) {
      log('@ Exception: ${e.toString()}');
    }
  }

  static int? initialCar(
      {required SharedPreferences prefs, required Box<Account> accountBox}) {
    int index = prefs.getInt(SharedPrefsKeys.current_car_index) ?? 0;
    if (accountBox.isEmpty || index >= accountBox.length || index < 0) {
      log('@ I: initial current car. (index = null)');
      return _carIndex = null;
    }
    _carIndex = index;
    log('@ I: initial current car. (index = $index)');
    return index;
  }

  static initialUserName({SharedPreferences? prefs}) {
    if (prefs == null) {
      SharedPreferences.getInstance().then((prefs) {
        initialUserName(prefs: prefs);
      });
    } else {
      _userName = prefs.getString(userNameKey) ?? '';
      log('@ I: initial userName');
    }
  }

  static int? get carIndex => _carIndex;

  static set carIndex(int? index) {
    _carIndex = (index != null && index < 0) ? null : index;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt(SharedPrefsKeys.current_car_index, index ?? -1);
      log('@ I: car index changed.');
    });
  }

  static logout(SharedPreferences prefs) {
    var accountBox = Hive.box<Account>(accountBoxKey);
    accountBox.clear();
    carIndex = null;
    setToken(prefs: prefs, accountBox: accountBox);
  }

  static Future<String?> deleteCurrentCar(int id) async {
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
