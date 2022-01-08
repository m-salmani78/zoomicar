import 'package:flutter/material.dart';
import 'package:zoomicar/constants/app_constants.dart';
import 'package:zoomicar/screens/sign_up/sign_up_screen.dart';
import 'package:zoomicar/screens/verify_phone_screen/verify_phone_screen.dart';
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
        Column(
          children: [
            Expanded(
              child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  width: double.infinity),
            ),
            Expanded(
              child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: double.infinity),
            ),
          ],
        ),
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
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
          builder: (context, child) {
            final provider = context.watch<AuthProvider>();
            return Scaffold(
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
              body: Center(
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
              ),
              bottomNavigationBar: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeAnimation(
                    delay: 0.66,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      width: double.infinity,
                      child: ElevatedButton(
                          child: const Text('ارسال کد'),
                          onPressed: provider.isLoading
                              ? null
                              : () {
                                  confirmAction(context, provider);
                                }),
                    ),
                  ),
                  FadeAnimation(
                    delay: 0.7,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("حساب کاربری ندارید؟"),
                        TextButton(
                          child: const Text('ثبت نام'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

void confirmAction(BuildContext context, AuthProvider provider) =>
    provider.login(
      context,
      onReceived: () async {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) {
            return VerifyPhoneScreen(isRegister: false, provider: provider);
          }),
        );
      },
    );
