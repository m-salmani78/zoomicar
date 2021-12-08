import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:zoomicar/utils/services/auth_provider.dart';
import '/config/themes/theme_config.dart';
import '/widgets/fade_animation.dart';
import 'package:provider/provider.dart';
import 'widget/body.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets;
    log(viewInsets.bottom.toString());
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: viewInsets.bottom > 0 ? const Text('ورود') : null,
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
          return Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (viewInsets.bottom <= 0)
                  const Text(
                    'ورود',
                    style:
                        TextStyle(height: 1, fontSize: 40, color: Colors.white),
                  ),
                if (viewInsets.bottom <= 0)
                  const FadeAnimation(
                    delay: 0.4,
                    child: Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 32),
                      child: Text(
                        'شماره موبایل خود را وارد نمایید',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                const Flexible(child: Body()),
              ],
            ),
          );
        },
      ),
    );
  }
}
