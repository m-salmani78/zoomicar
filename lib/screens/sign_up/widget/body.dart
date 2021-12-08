import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zoomicar/constants/app_constants.dart';
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

  String userName = '';

  String mobile = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final provider = context.watch<AuthProvider>();
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: customBoxDecoration(context),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: screenSize.height * 0.12),
              FadeAnimation(delay: 0.5, child: _buildUserName(context)),
              const SizedBox(height: 24),
              FadeAnimation(
                  delay: 0.6,
                  child: buildPhoneNumber(context,
                      onChanged: (value) => mobile = value)),
              SizedBox(height: screenSize.height * 0.06),
              if (provider.isLoading) const CircularProgressIndicator(),
              SizedBox(height: screenSize.height * 0.06),
              FadeAnimation(
                delay: 0.7,
                child: SizedBox(
                  width: double.infinity,
                  child: _buildConfirmButton(provider),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserName(BuildContext context) {
    return TextFormField(
      onChanged: (value) => userName = value,
      maxLength: 20,
      decoration: customInputDecoration(
        context,
        hint: 'نام کاربری',
        icon: const Icon(Icons.person_rounded),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return requiredInputError;
        }
      },
    );
  }

  Widget _buildConfirmButton(AuthProvider provider) {
    return ElevatedButton(
      onPressed: provider.isLoading
          ? null
          : () {
              if (_formKey.currentState == null) {
                log('currentState == null');
                return;
              }
              if (_formKey.currentState!.validate()) {
                provider.register(
                  context,
                  mobile: mobile,
                  userName: userName,
                  onReceived: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerifyPhoneScreen(
                          isRegister: true,
                          mobile: mobile,
                          provider: provider,
                        ),
                      ),
                    );
                  },
                );
              }
            },
      child: const Text('ثبت نام'),
    );
  }
}
