import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '/constants/app_constants.dart';
import '/screens/home/home_screen.dart';
import '/screens/splash/splash_screen.dart';
import 'utils/services/account_change_handler.dart';
import '/utils/services/notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/themes/theme_config.dart';
import 'models/car_model.dart';
import 'models/problem_model.dart';
import 'models/account_model.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await NotificationService.initialSettings();
  await Hive.initFlutter();
  Hive.registerAdapter(CarAdapter());
  Hive.registerAdapter(ProblemAdapter());
  Hive.registerAdapter(AccountAdapter());
  var accountBox = await Hive.openBox<Account>(accountBoxKey);
  AccountChangeHandler.initialCar(prefs: prefs, accountBox: accountBox);
  AccountChangeHandler.initialUserName(prefs: prefs);
  final token = AccountChangeHandler.initialToken(prefs);
  final IThemeConfig appTheme = ThemeChangeHandler.initialTheme(prefs);
  runApp(MyApp(token: token, appTheme: appTheme));
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  final String? token;
  final IThemeConfig appTheme;
  // ignore: use_key_in_widget_constructors
  const MyApp({required this.token, required this.appTheme});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (context) => ThemeChangeHandler(appTheme),
      child: Consumer<ThemeChangeHandler>(
        builder: (context, state, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            supportedLocales: const [Locale('fa')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            debugShowCheckedModeBanner: false,
            title: 'ZoomiCar',
            theme: state.appTheme.themeData,
            home: (token == null || token!.isEmpty)
                ? const SplashScreen()
                : const HomeScreen(),
          );
        },
      ),
    );
  }
}
