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
import '/screens/sign_up/sign_up_screen.dart';
import '../../utils/services/account_change_handler.dart';
import '../../constants/api_keys.dart';
import '/widgets/form_error.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  // static const routeName = '/sign in';
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final List<String> errors = [];
  final _key = GlobalKey<FormState>();
  String userName = '';
  String password = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'ورود',
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              FadeAnimation(
                delay: 0.4,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenSize.width * 0.6),
                  child: const Text(
                    'با نام کاربری و رمز عبور خود وارد شوید. ',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              SizedBox(height: screenSize.height * 0.11),
              FadeAnimation(delay: 0.5, child: _buildUserName()),
              const SizedBox(height: 32),
              FadeAnimation(delay: 0.6, child: _buildPassword()),
              SizedBox(height: screenSize.height * 0.06),
              _isLoading
                  ? const CircularProgressIndicator()
                  : FormError(errors: errors),
              SizedBox(height: screenSize.height * 0.05),
              FadeAnimation(
                delay: 0.7,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minWidth: screenSize.width),
                  child: ElevatedButton(
                    child: const Text('ورود'),
                    onPressed: _isLoading ? null : _onPressButton,
                  ),
                ),
              ),
              FadeAnimation(
                delay: 0.8,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("حساب کاربری ندارید؟"),
                    // Text("Don't have an account?"),
                    TextButton(
                      child: const Text('ثبت نام'),
                      // child: Text('Sign Up'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SignUpScreen(),
                            ));
                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserName() {
    return TextFormField(
      onChanged: (value) => userName = value,
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
        hintText: 'رمزعبور خود را وارد کنید',
        // hintText: 'Enter your password',
        suffixIcon: Icon(Icons.lock_outline),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return requiredInputError;
          // return 'PLease enter your password';
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
        Uri.parse(baseUrl + '/account/login'),
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
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            );
          } else if (json[StatusResponse.key] == StatusResponse.failed) {
            errors.add('نام کاربری یا رمز عبور اشتباه است.');
            // errors.add('Invalid UserName or Password');
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
