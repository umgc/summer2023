import 'package:flutter/material.dart';

import '../globals.dart';

onSelectNotification(BuildContext context, int? id) async {
  Navigator.pushNamed(context, '/conversationSelection');
  await flutterLocalNotificationsPlugin.cancel(id!);
}
