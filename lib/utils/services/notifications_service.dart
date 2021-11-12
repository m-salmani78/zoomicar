import 'dart:async';
import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import '/config/themes/light_theme.dart';
import '/constants/app_constants.dart';
import '/models/problem_model.dart';
import '/models/car_model.dart';
import 'account_change_handler.dart';

class NotificationService {
  static bool listenerIsInitialized = false;
  static AwesomeNotifications flutterNotification = AwesomeNotifications();

  static Future<bool> initialSettings() async {
    var result = await AwesomeNotifications().initialize(
      'resource://drawable/ringsport',
      [
        NotificationChannel(
            channelKey: groupNotifKey,
            groupKey: groupNotifKey,
            channelName: 'اطلاع رسانی ها',
            channelDescription: 'نمایش آگهی های تعویض قطعات',
            channelShowBadge: true,
            defaultPrivacy: NotificationPrivacy.Private,
            importance: NotificationImportance.High,
            defaultColor: kPrimaryColor,
            ledColor: Colors.white)
      ],
    );
    log('@ initialize notifs');
    return result;
  }

  static Future<bool> requestPermission(BuildContext context) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      // Insert here your friendly dialog box before call the request method
      // This is very important to not harm the user experience
      isAllowed =
          await AwesomeNotifications().requestPermissionToSendNotifications();
    }
    return isAllowed;
  }

  static void notifListeners(
      {required void Function(ReceivedAction) onData, Function? onError}) {
    if (listenerIsInitialized) return;
    log('@ notif listeners');
    AwesomeNotifications().actionStream.listen(onData, onError: onError);
    listenerIsInitialized = true;
  }

  static Future<bool> showNotification(
      {required Problem problem, required Car car, DateTime? notifDate}) async {
    var date = notifDate ?? problem.date;
    if (date == null) {
      log('@ notification ${problem.tag} date is expired');
    } else {
      log('@ show notification ${problem.tag}');
    }
    return AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: problem.hashCode,
        channelKey: groupNotifKey,
        title: problem.title,
        body:
            '${AccountChangeHandler.userName} عزیز ${problem.title} شما نیازمند تعویض است. برای مشاهده نزدیکترین مراکز کلیک کنید.',
        summary: car.name,
        payload: {
          "car_id": car.carId.toString(),
          "problem_tag": problem.tag,
        },
      ),
      schedule: date == null ? null : NotificationCalendar.fromDate(date: date),
      actionButtons: [
        NotificationActionButton(
          key: NotifButtonKey.done,
          label: 'انجام شد',
          buttonType: ActionButtonType.Default,
        ),
        NotificationActionButton(
            key: NotifButtonKey.repeate,
            label: 'مجدد یادآوری کن',
            buttonType: ActionButtonType.KeepOnTop),
      ],
    );
  }
}
