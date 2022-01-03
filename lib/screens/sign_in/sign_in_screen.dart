import 'package:flutter/material.dart';
import 'package:zoomicar/constants/app_constants.dart';
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
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
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
                ? const Text(
                    'ورود',
                    style: TextStyle(shadows: textShadow),
                  )
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
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (viewInsets.bottom <= 0)
                      const Text(
                        'ورود',
                        style: TextStyle(
                          height: 1,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                blurRadius: 4,
                                offset: Offset(-0.2, 0.4),
                                color: Colors.black45),
                          ],
                        ),
                      ),
                    if (viewInsets.bottom <= 0)
                      const FadeAnimation(
                        delay: 0.4,
                        child: Padding(
                          padding: EdgeInsets.only(top: 22, bottom: 16),
                          child: Text(
                            'شماره موبایل خود را وارد نمایید',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              shadows: textShadow,
                            ),
                          ),
                        ),
                      ),
                    const Flexible(child: Body()),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
