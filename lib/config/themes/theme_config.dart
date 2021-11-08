import 'dart:developer';

import 'package:flutter/material.dart';
import '/constants/app_constants.dart';
import '/utils/services/local_storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dark_theme.dart';
import 'light_theme.dart';

abstract class IThemeConfig {
  String get key;
  String get name;
  ThemeData get themeData;
}

class ThemeChangeHandler with ChangeNotifier {
  IThemeConfig appTheme;

  ThemeChangeHandler(this.appTheme);

  void changeTheme(String themeKey) async {
    try {
      appTheme = themes.firstWhere((item) => item.key == themeKey);
      log('@ I: change theme.');
    } catch (e) {
      log('@ E: invalid theme key.');
      return;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(SharedPrefsKeys.app_theme_key, themeKey);
    notifyListeners();
  }

  static IThemeConfig initialTheme(SharedPreferences prefs) {
    String key;
    try {
      key = prefs.getString(SharedPrefsKeys.app_theme_key) ?? '';
      log('@ I: initial theme.');
    } catch (e) {
      key = LightTheme().key;
    }
    IThemeConfig themeConfig = themes.firstWhere((item) => item.key == key,
        orElse: () => LightTheme());

    return themeConfig;
  }

  void toggleTheme(BuildContext context) async {
    var turnIntoDark = Theme.of(context).brightness == Brightness.light;
    appTheme = themes[turnIntoDark ? 1 : 0];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        SharedPrefsKeys.app_theme_key, themes[turnIntoDark ? 1 : 0].key);
    notifyListeners();
  }
}

List<IThemeConfig> themes = [
  LightTheme(),
  DarkTheme(),
];

InputDecorationTheme inputDecorationTheme() {
  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(cornerRadius),
    ),
  );
}

final customButtonTheme = ElevatedButtonThemeData(
  style: ButtonStyle(
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
      textStyle: MaterialStateProperty.all<TextStyle>(
          const TextStyle(fontSize: 16, fontFamily: 'IranianSans')),
      shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cornerRadius))),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
);

final customOutlinedButtonTheme = OutlinedButtonThemeData(
  style: ButtonStyle(
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
        const EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
    textStyle: MaterialStateProperty.all<TextStyle>(
        const TextStyle(fontSize: 16, fontFamily: 'IranianSans')),
    shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(cornerRadius))),
  ),
);
