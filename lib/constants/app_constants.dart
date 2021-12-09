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

const textShadow = [
  Shadow(blurRadius: 4, offset: Offset(-0.2, 0.3), color: Colors.black45),
];
