import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

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
    print(id);
    _notifications.schedule(
        id,
        title,
        body,
        scheduledDate,
        await _notificationsDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
    );
  }

  static void reminderNotif(){
    NotificationApi.showScheduledNotification(
      title: 'Настроение',
      body: 'Привет! Как твое настроение?',
      payload: 'Suck  some dick!',
      scheduledDate: DateTime.now().add(Duration(seconds: 5)),
    );
  }
}
