import 'package:flutter/material.dart';
import '/config/themes/theme_config.dart';
import '/screens/about_us/about_us.dart';
import '/screens/specifications/specifications_screen.dart';
import '/screens/splash/splash_screen.dart';
import '../../utils/services/account_change_handler.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeConfig = Provider.of<ThemeChangeHandler>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('تنظیمات')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.directions_car_filled),
            title: const Text('مشخصات ماشین'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SpecificationsScreen()),
              );
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.brightness_high),
            title: const Text('حالت شب'),
            onTap: () => themeConfig.toggleTheme(context),
            trailing: Switch(
                value: Theme.of(context).brightness == Brightness.dark,
                onChanged: (_) => themeConfig.toggleTheme(context)),
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.person_add),
            title: const Text('دعوت از دوستان'),
            onTap: () {
              String appUrl = 'https://cafebazaar.ir/app/com.mobiliha.badesaba';
              Share.share(
                'اگه سلامت ماشینت برات مهمه حتما زومیکارو رو گوشیت نصب کن. \n$appUrl',
                subject: 'Zoomicar',
              );
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.info_outline_rounded),
            title: const Text('درباره ما'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutUs()));
            },
          ),
          const Divider(height: 0),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('خروج', style: TextStyle(color: Colors.red)),
            onTap: () async {
              SharedPreferences.getInstance().then((prefs) {
                AccountChangeHandler.logout(prefs);
              });
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                  (route) => false);
            },
          ),
          const Divider(height: 0),
          const Spacer(),
          Image.asset('assets/images/ringsport.png', height: 64),
          const Text('نسخه 1.0.0'),
        ],
      ),
    );
  }
}
