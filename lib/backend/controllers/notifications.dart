import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

import '../models/ReminderModel.dart';
import '../services/db.dart';

class NotificationApi{
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future _notificationsDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        'channel description',
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init({bool initScheduled = false}) async{
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotifications.add(payload);
      },
    );
  }

  static Future showNotification({
    int id = 1,
    String? title,
    String? body,
    String? payload,
  }) async {
    _notifications.show(
        id,
        title,
        body,
        await _notificationsDetails(),
    payload: payload);
  }

  static Future showScheduledNotification({
    int id = 1,
    String? title,
    String? body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    _notifications.schedule(
        id,
        title,
        body,
        scheduledDate,
        await _notificationsDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
    );
    print(id);
  }


  static Future<void> reminderNotif() async {
    var notifs = await getReminderTimes();
    for (var elem in notifs){
      var array = elem['time'].toString().split(":");
      int id = elem['id'];
      int hours = int.parse(array[0]);
      int minutes = int.parse(array[1]);
      DateTime now = DateTime.now();
      DateTime needsTime = DateTime(now.year, now.month, now.day, hours, minutes);
      if (now.compareTo(needsTime) != -1){
        needsTime = needsTime.add(Duration(days: 1));
      }
      print(needsTime);
      await NotificationApi.showScheduledNotification(
        id: id,
        title: 'Настроение',
        body: 'Привет! Как твое настроение?',
        payload: 'Suck  some dick!',
        scheduledDate: needsTime,
      );
    }
  }
}

getReminderTimes()
async {
  List ReminderMaps = await DB.rawQuery("SELECT id, time FROM ${ReminderModel.table} WHERE (is_use == 1) ORDER BY time");
  return ReminderMaps;
}
