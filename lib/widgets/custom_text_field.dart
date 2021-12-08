import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zoomicar/constants/app_constants.dart';

Widget buildPhoneNumber(BuildContext context,
    {required void Function(String value) onChanged}) {
  return TextFormField(
    onChanged: onChanged,
    keyboardType: TextInputType.number,
    inputFormatters: <TextInputFormatter>[
      FilteringTextInputFormatter.digitsOnly
    ],
    decoration: customInputDecoration(
      context,
      hint: 'شماره موبایل',
      icon: const Icon(Icons.phone_android_rounded),
    ),
    validator: (value) {
      if (value == null || value.isEmpty) {
        return requiredInputError;
      }
    },
  );
}

customInputDecoration(BuildContext context,
    {required String hint, required Widget icon}) {
  return InputDecoration(
    hintText: hint,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    prefixIcon: icon,
    border: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(cornerRadius)),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(cornerRadius)),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red[700]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(cornerRadius)),
    filled: true,
  );
}

customBoxDecoration(BuildContext context) {
  return BoxDecoration(
    color: Theme.of(context).scaffoldBackgroundColor,
    borderRadius: const BorderRadius.only(topRight: Radius.circular(36)),
    // boxShadow: [
    //   BoxShadow(
    //     blurRadius: 8,
    //     spreadRadius: -1,
    //     offset: const Offset(4, 1),
    //     color: Theme.of(context).brightness == Brightness.light
    //         ? Colors.black45
    //         : Colors.white54,
    //   )
    // ],
  );
}
