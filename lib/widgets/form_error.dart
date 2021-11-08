import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children:
          List.generate(errors.length, (index) => formErrorText(errors[index])),
    );
  }

  Widget formErrorText(String error) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            "assets/icons/Error.svg",
            height: (14),
            width: (14),
          ),
          const SizedBox(
            width: (8),
          ),
          Text(error, style: const TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
