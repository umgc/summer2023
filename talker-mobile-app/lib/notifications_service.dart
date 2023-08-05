import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsService {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
      BuildContext context,
      Function(BuildContext, int?) onSelectNotification) async {
    var androidInitialize =
        const AndroidInitializationSettings('mipmap/launcher_icon');
    var iOSInitialize = const DarwinInitializationSettings();
    var initializationsSettings =
        InitializationSettings(android: androidInitialize, iOS: iOSInitialize);
    await flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: (notificationResponse) {
      onSelectNotification(context, notificationResponse.id);
    });
  }

  static Future showBigTextNotification(
      {required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        const AndroidNotificationDetails(
      'convobuddychannel',
      'channel_name',
      playSound: true,
      color: Color(0xFF8900F8),
      icon: 'mipmap/launcher_icon',
      colorized: true,
      importance: Importance.max,
      priority: Priority.high,
    );

    final notificationId = UniqueKey().hashCode;
    /*await fln
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(notificationId, title, body,
            notificationDetails: androidPlatformChannelSpecifics,
            payload: 'item x');*/

    NotificationDetails details =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await fln.show(notificationId, title, body, details, payload: 'item x');
  }
}
