import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: viewInsets.bottom > 0 ? const Text('ثبت نام') : null,
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
                  style:
                      TextStyle(fontSize: 40, color: Colors.white, height: 1),
                ),
              if (viewInsets.bottom <= 0)
                const FadeAnimation(
                  delay: 0.4,
                  child: Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 32),
                    child: Text(
                      'اطلاعات خود را تکمیل کنید',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              const Expanded(child: Body()),
            ],
          );
        },
      ),
    );
  }

  // Widget _buildPhoneNumber() {
  //   return TextFormField(
  //     onChanged: (value) => mobile = value,
  //     keyboardType: TextInputType.number,
  //     inputFormatters: <TextInputFormatter>[
  //       FilteringTextInputFormatter.digitsOnly
  //     ],
  //     decoration: const InputDecoration(
  //       labelText: 'شماره موبایل',
  //       floatingLabelBehavior: FloatingLabelBehavior.auto,
  //       prefixIcon: Icon(Icons.phone_android_rounded),
  //     ),
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return requiredInputError;
  //       }
  //     },
  //   );
  // }

  // Widget _buildPassword() {
  //   return TextFormField(
  //     obscureText: true,
  //     keyboardType: TextInputType.visiblePassword,
  //     onChanged: (value) => password = value,
  //     decoration: const InputDecoration(
  //       labelText: 'رمز عبور',
  //       // labelText: 'Password',
  //       hintText: 'رمز عبور خود را وارد کنید',
  //       // hintText: 'Enter your password',
  //       suffixIcon: Icon(Icons.lock_outline),
  //     ),
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return requiredInputError;
  //         // return 'PLease enter your password';
  //       } else if (value.length < 4) {
  //         return "رمز عبور باید از چهار حرف بیشتر باشد";
  //         // return "Password is too short.";
  //       }
  //     },
  //   );
  // }

  // Widget _buildConfirmPassword() {
  //   return TextFormField(
  //     obscureText: true,
  //     keyboardType: TextInputType.visiblePassword,
  //     onChanged: (value) => confirmPassword = value,
  //     decoration: const InputDecoration(
  //       labelText: 'تایید رمز عیور',
  //       // labelText: 'Confirm Password',
  //       hintText: 'رمز عبور را مجدادا وارد کنید',
  //       // hintText: 'Re-enter your password',
  //       suffixIcon: Icon(Icons.lock_outline),
  //     ),
  //     validator: (value) {
  //       if (value == null || value.isEmpty) {
  //         return requiredInputError;
  //         // return "Please confirm your password.";
  //       } else if (value != password) {
  //         return "رمزهای وارد شده باهم تطابق ندارند";
  //         // return "Passwords don't match.";
  //       }
  //     },
  //   );
  // }

  // void _onPressButton() {
  //   if (!_key.currentState!.validate()) return;
  //   setState(() => _isLoading = true);
  //   errors.clear();
  //   try {
  //     http.post(
  //       Uri.parse(baseUrl + '/account/register'),
  //       body: {
  //         "username": userName,
  //         "password": password,
  //       },
  //     ).then((response) async {
  //       if (response.statusCode == 200) {
  //         log('@ Response: ${response.body}');
  //         Map<String, dynamic> json = jsonDecode(response.body);
  //         if (json[StatusResponse.key] == StatusResponse.success) {
  //           AccountChangeHandler().setToken(json["token"]);
  //           AccountChangeHandler().setUserName(userName);
  //           Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(builder: (context) => const HomeScreen()),
  //             (route) => false,
  //           );
  //         } else if (json[StatusResponse.key] == StatusResponse.failed) {
  //           errors.add('نام کاربری موجود است.');
  //           // errors.add('this username is exist.');
  //         }
  //       }
  //       setState(() => _isLoading = false);
  //     }).onError((error, stackTrace) {
  //       log('@ Error: ${error.toString()}');
  //       errors.add('اتصال برقرار نیست.');
  //       // errors.add('Connection failed.');
  //       setState(() => _isLoading = false);
  //     });
  //   } catch (e) {
  //     log('@ Exception: ${e.toString()}');
  //     errors.add('Connection failed please check your network');
  //     setState(() => _isLoading = false);
  //   }
  // }
}
