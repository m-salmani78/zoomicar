import 'package:flutter/material.dart';

const double cornerRadius = 10;
const double defaultElevation = 2.5;
const String requiredInputError = 'این فیلد اجباری است';
const String accountBoxKey = 'account-box';
const String notificationsKey = 'cars-box';
const String userNameKey = 'user-name-key';
const String groupNotifKey = 'com.example.khodro_check';

class NotifButtonKey {
  NotifButtonKey._();
  static String done = 'DONE';
  static String repeate = 'NOTIF_ME_AGAIN';
}

const shadowOffset = Offset(-0.2, 0.3);
const textShadow = [
  Shadow(blurRadius: 4, offset: shadowOffset, color: Colors.black45),
];

BoxDecoration customCardDecoration(BuildContext context) => BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).brightness == Brightness.light
          ? Colors.grey[100]
          : Theme.of(context).cardColor,
    );

final BoxBorder customContainerBorder =
    Border.all(color: Colors.grey.withOpacity(0.5), width: 0.5);
