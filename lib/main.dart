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
  final accountBox = await Hive.openBox<Account>(accountBoxKey);
  final isSignedIn = await AccountChangeHandler.initialize(prefs, accountBox);
  final IThemeConfig appTheme = ThemeChangeHandler.initialTheme(prefs);
  runApp(MyApp(isSignedIn: isSignedIn, appTheme: appTheme));
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();
  final bool isSignedIn;
  final IThemeConfig appTheme;
  const MyApp({Key? key, required this.isSignedIn, required this.appTheme})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ChangeNotifierProvider(
      create: (context) => ThemeChangeHandler(appTheme),
      builder: (context, child) {
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
          theme: context.watch<ThemeChangeHandler>().appTheme.themeData,
          home: isSignedIn ? const HomeScreen() : const SplashScreen(),
        );
      },
    );
  }
}
