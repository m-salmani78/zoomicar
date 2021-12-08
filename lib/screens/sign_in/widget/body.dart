import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomicar/screens/sign_up/sign_up_screen.dart';
import 'package:zoomicar/screens/verify_phone_screen/verify_phone_screen.dart';
import 'package:zoomicar/utils/services/auth_provider.dart';
import 'package:zoomicar/widgets/custom_text_field.dart';
import 'package:zoomicar/widgets/fade_animation.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _formKey = GlobalKey<FormState>();

  String mobile = '';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AuthProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      clipBehavior: Clip.antiAlias,
      decoration: customBoxDecoration(context),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Spacer(flex: 2),
            FadeAnimation(
              delay: 0.5,
              child: buildPhoneNumber(context,
                  onChanged: (value) => mobile = value),
            ),
            const Spacer(),
            if (provider.isLoading) const CircularProgressIndicator(),
            const Spacer(),
            FadeAnimation(
              delay: 0.6,
              child: SizedBox(
                width: double.infinity,
                child: _buildConfirmButton(provider),
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
      ),
    );
  }

  Widget _buildConfirmButton(AuthProvider provider) {
    return ElevatedButton(
      child: const Text('ارسال کد'),
      onPressed: provider.isLoading
          ? null
          : () {
              if (_formKey.currentState == null) {
                log('currentState == null');
                return;
              }
              if (_formKey.currentState!.validate()) {
                provider.login(
                  context,
                  mobile: mobile,
                  onReceived: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return VerifyPhoneScreen(
                            isRegister: false,
                            mobile: mobile,
                            provider: provider);
                      }),
                    );
                  },
                );
              }
            },
    );
  }
}
