import 'package:flutter/material.dart';
import '/config/themes/light_theme.dart';

import 'theme_config.dart';

class DarkTheme implements IThemeConfig {
  static final DarkTheme _instance = DarkTheme._internal();

  DarkTheme._internal();

  factory DarkTheme() => _instance;

  @override
  String get key => 'default_dark_theme';

  @override
  String get name => 'Dafault Dark Theme';

  @override
  ThemeData themeData = ThemeData(
    primaryColor: kDarkPrimaryColor,
    colorScheme: ColorScheme.dark(
      primary: kDarkPrimaryColor,
      primaryVariant: kDarkPrimaryColor[800]!,
      secondary: kPrimaryColor,
      secondaryVariant: kPrimaryColor[800]!,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.black,
    ),
    brightness: Brightness.dark,
    fontFamily: 'IranianSans',
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: customButtonTheme,
    outlinedButtonTheme: customOutlinedButtonTheme,
    inputDecorationTheme: inputDecorationTheme(),
  );
}

const MaterialColor kDarkPrimaryColor = MaterialColor(
  _darkPrimaryValue,
  <int, Color>{
    50: Color(0xffd5f6f4),
    100: Color(0xffaaeee9),
    200: Color(0xff80e5de),
    300: Color(0xff56dcd3),
    400: Color(0xff2bd4c8),
    500: Color(_darkPrimaryValue),
    600: Color(0xff23a9a0),
    700: Color(0xff1e948c),
    800: Color(0xff166a64),
    900: Color(0xff0d3f3c),
  },
);

const int _darkPrimaryValue = 0Xff28c0b7;
