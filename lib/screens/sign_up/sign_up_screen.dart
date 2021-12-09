import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:zoomicar/constants/app_constants.dart';
import 'package:zoomicar/utils/services/auth_provider.dart';
import '/config/themes/theme_config.dart';
import '/widgets/fade_animation.dart';
import 'package:provider/provider.dart';

import 'widget/body.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  // static const routeName = '/sign up';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    final size = MediaQuery.of(context).size;
    return Stack(children: [
      Container(
          color: Theme.of(context).colorScheme.primary,
          width: double.infinity,
          height: double.infinity),
      SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 12, top: 16),
          child: FadeAnimation(
            delay: 0.3,
            child: Image.asset(
              'assets/images/car-drawing.png',
              color: Colors.white30,
              width: size.width,
            ),
          ),
        ),
      ),
      Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          title: viewInsets.bottom > 0
              ? const Text('ثبت نام', style: TextStyle(shadows: textShadow))
              : null,
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<ThemeChangeHandler>(context, listen: false)
                    .toggleTheme(context);
              },
              icon: Icon(Theme.of(context).brightness == Brightness.dark
                  ? Icons.light_mode_rounded
                  : Icons.dark_mode_rounded),
            )
          ],
        ),
        body: ChangeNotifierProvider(
          create: (context) => AuthProvider(),
          builder: (context, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (viewInsets.bottom <= 0)
                  const Text(
                    'ثبت نام',
                    style: TextStyle(
                      height: 1,
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      shadows: textShadow,
                    ),
                  ),
                if (viewInsets.bottom <= 0)
                  const FadeAnimation(
                    delay: 0.4,
                    child: Padding(
                      padding: EdgeInsets.only(top: 22, bottom: 16),
                      child: Text(
                        'اطلاعات خود را تکمیل کنید',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          shadows: textShadow,
                        ),
                      ),
                    ),
                  ),
                const Expanded(child: Body()),
              ],
            );
          },
        ),
      )
    ]);
  }
}
