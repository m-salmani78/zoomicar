import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zoomicar/utils/helpers/show_snack_bar.dart';
import 'package:zoomicar/utils/services/auth_provider.dart';

import 'widgets/verification_code_input.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String mobile;
  final bool isRegister;
  final AuthProvider provider;
  const VerifyPhoneScreen(
      {Key? key,
      required this.mobile,
      required this.provider,
      required this.isRegister})
      : super(key: key);

  @override
  State<VerifyPhoneScreen> createState() => _VerifyPhoneScreenState();
}

const waitingTime = 120;

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  int _timeRemainder = waitingTime;
  String? _code;
  bool _isTimeEnd = false;
  late Timer _timer;

  @override
  void initState() {
    _timer = startTimer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final type = widget.isRegister ? 'register' : 'login';
    return Scaffold(
      appBar: AppBar(
        title: const Text('تایید شماره تلفن'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Spacer(),
            Text('پیامک به شماره ${widget.mobile} ارسال شد.'),
            const Spacer(),
            VerificationCodeInput(onCompleted: (value) {
              _code = value;
              widget.provider.verifyCode(context,
                  type: type, mobile: widget.mobile, code: _code!);
            }),
            const SizedBox(height: 16),
            _isTimeEnd
                ? _buildResendCode()
                : Text('کد پس از $_timeRemainder ثانیه منقضی می شود'),
            const SizedBox(height: 16),
            if (widget.provider.isLoading) const CircularProgressIndicator(),
            const Spacer(flex: 2),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_code == null) {
                    showWarningSnackBar(context,
                        message: 'کد را بصورت کامل وارد کنید.');
                    return;
                  }
                  widget.provider.verifyCode(context,
                      type: type, mobile: widget.mobile, code: _code!);
                },
                label: const Text('ادامه'),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResendCode() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('کد تایید را دریافت نکردید؟'),
        TextButton(
          onPressed: () => setState(() {
            _isTimeEnd = false;
            _timeRemainder = waitingTime;
            _timer = startTimer();
          }),
          child: const Text('دریافت مجدد'),
        )
      ],
    );
  }

  // Future<void> verifyUser(var context) async {
  //   FormData formData = FormData.fromMap({
  //     "phone": widget.mobile,
  //     "verification_code": _code,
  //   });
  //   response =
  //       await dio.post(baseURL + "/account/verify_phone", data: formData);
  //   // print(response.data.toString());
  // }

  // Future<void> resendCode(var context) async {
  //   FormData formData = FormData.fromMap({
  //     "phone": widget.mobile,
  //   });
  //   response = await dio.post(baseURL + "/account/resend_code", data: formData);
  //   // print(response.data.toString());
  // }

  Timer startTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeRemainder--;
        if (_timeRemainder <= 0) {
          timer.cancel();
          _isTimeEnd = true;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
