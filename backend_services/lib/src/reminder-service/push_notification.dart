import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:backend_services/model/reminder.dart';

class PushNotification {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //Set iOS and Android notification settings
  Future<void> setNotificationSettings() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('flutter_logo');

    var initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: (int id, String? title,
            String? description, String? payload) async {});

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  Future scheduleNotification(Reminder reminder) async {
    return flutterLocalNotificationsPlugin.zonedSchedule(
        reminder.reminderId,
        'Notification',
        reminder.reminderDescription,
        tz.TZDateTime.from(reminder.notifyTimestamp, tz.local),
        const NotificationDetails(
            android: AndroidNotificationDetails('channelId', 'channelName',
                importance: Importance.min),
            iOS: DarwinNotificationDetails()),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
