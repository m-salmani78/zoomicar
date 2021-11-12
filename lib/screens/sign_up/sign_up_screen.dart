import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/rendering.dart';
import '/config/themes/theme_config.dart';
import '/constants/app_constants.dart';
import '/widgets/fade_animation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/screens/home/home_screen.dart';
import '../../utils/services/account_change_handler.dart';
import '../../constants/api_keys.dart';
import '/widgets/form_error.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  // static const routeName = '/sign up';
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final List<String> errors = [];
  final _key = GlobalKey<FormState>();

  String userName = '';
  String password = '';
  String confirmPassword = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              // context.watch<ThemeChangeHandler>().toggleTheme(context);
              Provider.of<ThemeChangeHandler>(context, listen: false)
                  .toggleTheme(context);
            },
            icon: Icon(Theme.of(context).brightness == Brightness.dark
                ? Icons.light_mode
                : Icons.dark_mode),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'ثبت نام',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              FadeAnimation(
                delay: 0.4,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenSize.width * 0.6),
                  child: const Text(
                    'اطلاعات خود را تکمیل کنید',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.08),
              FadeAnimation(delay: 0.5, child: _buildUserName()),
              const SizedBox(height: 24),
              FadeAnimation(delay: 0.6, child: _buildPassword()),
              const SizedBox(height: 24),
              FadeAnimation(delay: 0.7, child: _buildConfirmPassword()),
              SizedBox(height: screenSize.height * 0.04),
              _isLoading
                  ? const CircularProgressIndicator()
                  : FormError(errors: errors),
              SizedBox(height: screenSize.height * 0.04),
              FadeAnimation(
                delay: 0.8,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: screenSize.width),
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _onPressButton,
                    // child: Text('Sign up'),
                    child: const Text('ثبت نام'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return TextFormField(
      onChanged: (value) => userName = value,
      maxLength: 20,
      decoration: const InputDecoration(
        labelText: 'نام کاربری',
        // labelText: 'UserName',
        hintText: 'نام کاربری خود را وارد کنید',
        // hintText: 'Enter your UserName',
        suffixIcon: Icon(Icons.person_rounded),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return requiredInputError;
          // return 'Please enter your user name';
        }
      },
    );
  }

  Widget _buildPassword() {
    return TextFormField(
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      onChanged: (value) => password = value,
      decoration: const InputDecoration(
        labelText: 'رمز عبور',
        // labelText: 'Password',
        hintText: 'رمز عبور خود را وارد کنید',
        // hintText: 'Enter your password',
        suffixIcon: Icon(Icons.lock_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return requiredInputError;
          // return 'PLease enter your password';
        } else if (value.length < 4) {
          return "رمز عبور باید از چهار حرف بیشتر باشد";
          // return "Password is too short.";
        }
      },
    );
  }

  Widget _buildConfirmPassword() {
    return TextFormField(
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      onChanged: (value) => confirmPassword = value,
      decoration: const InputDecoration(
        labelText: 'تایید رمز عیور',
        // labelText: 'Confirm Password',
        hintText: 'رمز عبور را مجدادا وارد کنید',
        // hintText: 'Re-enter your password',
        suffixIcon: Icon(Icons.lock_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return requiredInputError;
          // return "Please confirm your password.";
        } else if (value != password) {
          return "رمزهای وارد شده باهم تطابق ندارند";
          // return "Passwords don't match.";
        }
      },
    );
  }

  void _onPressButton() {
    if (!_key.currentState!.validate()) return;
    setState(() => _isLoading = true);
    errors.clear();
    try {
      http.post(
        Uri.parse(baseUrl + '/account/register'),
        body: {
          "username": userName,
          "password": password,
        },
      ).then((response) async {
        if (response.statusCode == 200) {
          log('@ Response: ${response.body}');
          Map<String, dynamic> json = jsonDecode(response.body);
          if (json[StatusResponse.key] == StatusResponse.success) {
            final prefs = await SharedPreferences.getInstance();
            AccountChangeHandler.setToken(
              prefs: prefs,
              value: json["token"],
            );
            AccountChangeHandler.setUserName(userName, prefs: prefs);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (route) => false,
            );
          } else if (json[StatusResponse.key] == StatusResponse.failed) {
            errors.add('نام کاربری موجود است.');
            // errors.add('this username is exist.');
          }
        }
        setState(() => _isLoading = false);
      }).onError((error, stackTrace) {
        log('@ Error: ${error.toString()}');
        errors.add('اتصال برقرار نیست.');
        // errors.add('Connection failed.');
        setState(() => _isLoading = false);
      });
    } catch (e) {
      log('@ Exception: ${e.toString()}');
      errors.add('Connection failed please check your network');
      setState(() => _isLoading = false);
    }
  }
}
