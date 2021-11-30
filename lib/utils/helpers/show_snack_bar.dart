import 'package:flutter/material.dart';

void showWarningSnackBar(BuildContext context,
    {required String message, SnackBarAction? action}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.warning_rounded,
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            message,
            style:
                const TextStyle(fontFamily: 'IranianSans', color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    ),
    backgroundColor: Colors.red[600],
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    action: action,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

void showSuccessSnackBar(BuildContext context, {required String message}) {
  final snackBar = SnackBar(
    content: Row(
      children: [
        const Icon(
          Icons.check_circle_rounded,
          color: Colors.white,
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            message,
            style:
                const TextStyle(fontFamily: 'IranianSans', color: Colors.white),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.green[600],
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    // action: SnackBarAction(
    //     label: 'Done', textColor: Colors.white, onPressed: () {}),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
