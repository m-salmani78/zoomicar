import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sms_autofill/sms_autofill.dart';

class AutoFillTextField extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  const AutoFillTextField({Key? key, required this.onCompleted})
      : super(key: key);

  @override
  _AutoFillTextFieldState createState() => _AutoFillTextFieldState();
}

class _AutoFillTextFieldState extends State<AutoFillTextField> {
  String? _code;

  @override
  void initState() {
    SmsAutoFill().listenForCode();
    super.initState();
  }

  @override
  void dispose() {
    log('unregisterListener', name: 'AutoFillTextField');
    SmsAutoFill().unregisterListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    return PinFieldAutoFill(
      currentCode: _code,
      autoFocus: true,
      codeLength: 5,
      smsCodeRegexPattern: '\\d{5}',
      enableInteractiveSelection: false,
      keyboardType: TextInputType.number,
      textInputAction: TextInputAction.go,
      cursor: Cursor(color: primaryColor),
      decoration: UnderlineDecoration(
        colorBuilder: PinListenColorBuilder(primaryColor, Colors.grey),
        textStyle: TextStyle(
            fontSize: 18,
            color: Theme.of(context).brightness == Brightness.light
                ? Colors.black
                : Colors.white,
            fontFamily: 'IranianSans'),
        lineHeight: 3,
        lineStrokeCap: StrokeCap.round,
      ),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onCodeSubmitted: widget.onCompleted,
      onCodeChanged: (code) {
        log('value:  $code', name: 'onCodeChanged');
        _code = code;
        if (code != null && code.length == 5) {
          FocusScope.of(context).requestFocus(FocusNode());
          widget.onCompleted(code);
        }
      },
    );
  }
}
