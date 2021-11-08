import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/config/themes/dark_theme.dart';

import 'theme_config.dart';

class LightTheme implements IThemeConfig {
  static final LightTheme _instance = LightTheme._();

  LightTheme._();

  factory LightTheme() => _instance;

  @override
  String get key => 'dafault_light_theme';

  @override
  String get name => 'Default Light Theme';

  @override
  ThemeData themeData = ThemeData(
    primarySwatch: kPrimaryColor,
    colorScheme: ColorScheme.light(
      primary: kPrimaryColor,
      primaryVariant: kPrimaryColor[800]!,
      secondary: kDarkPrimaryColor,
      secondaryVariant: kDarkPrimaryColor[800]!,
    ),
    scaffoldBackgroundColor: Colors.white,
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
    ),
    fontFamily: 'IranianSans',
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    elevatedButtonTheme: customButtonTheme,
    outlinedButtonTheme: customOutlinedButtonTheme,
    inputDecorationTheme: inputDecorationTheme(),
  );
}

const MaterialColor kPrimaryColor = MaterialColor(
  _primaryValue,
  <int, Color>{
    50: Color(0xfffff0e6),
    100: Color(0xffffd2b3),
    200: Color(0xffffb580),
    300: Color(0xFFffa666),
    400: Color(0xFFff974d),
    500: Color(0Xffff8833),
    600: Color(0xffff791a),
    700: Color(0xffff6a00),
    800: Color(0xffcc5500),
    900: Color(0xff994000),
  },
);

const int _primaryValue = 0Xffff8833;
