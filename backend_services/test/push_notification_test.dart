import 'package:flutter_test/flutter_test.dart';
import 'package:backend_services/model/reminder.dart';
import 'package:backend_services/src/reminder-service/push_notification.dart';

void main() async {
  test('push reminder notification', () async {
    var testReminder = Reminder(
        0,
        DateTime.parse('2023-07-25 20:18:04Z'),
        DateTime.parse('2023-07-25 20:18:04Z'),
        'Time to take medication',
        'S123');
    PushNotification().setNotificationSettings();
    var result = PushNotification().scheduleNotification(testReminder);
    expect(result, isNotNull);
  });
}
