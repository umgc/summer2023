import 'dart:io';

import 'package:backend_services/agent.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

  final logger = Logger();

    test('read existing reminder JSON files and return list of files', () async {
    var agent = Agent('Reminder-API-Unit-test', directory);
    expect(() => agent.conversationsProvider.reminders, returnsNormally);

    agent.conversationsProvider.removeAllReminders();
    expect(agent.conversationsProvider.reminders.length, 0);
    agent.loadSampleReminderData();
    //logger.i(
    //    "test reminders count: ${agent.conversationsProvider.reminders.length}");
    expect(agent.conversationsProvider.reminders.length, isNot(0));

    var result = agent.conversationsProvider.reminders.toString();
    expect(result, isNotNull);
    logger.i(result);
  });

//todo Requirement 12 get reminders

//todo add reminder

//todo delete reminder

/*  test('write reminders to reminders.json', () {
    var agent = Agent('browser-extension-api-unit-test', directory);
    agent.loadSampleReminderData;
    expect(() => agent.writeRemindersToFile(), returnsNormally);
  });

  test('read existing reminder JSON file and return a string', () async {
    var agent = Agent('Reminder-API-Unit-test', directory);
    agent.loadSampleReminderData();
    expect(() => agent.writeRemindersToFile(), returnsNormally);
    List fileList = agent.listFilesInPath();
    print(fileList.toString());
    Future<String?> json = agent.readRemindersFileJSON();
    print(await json);
    expect(() => json, isNotNull);
    logger.i(await json);
    //expect(() => json, isNotEmpty);
  });

  test('write a reminder JSON file and return a list of directory contents',
      () async {
    var agent = Agent('Reminder-API-Unit-test', directory);
    agent.loadSampleReminderData;
    expect(() => agent.writeRemindersToFile(), returnsNormally);
    List fileList = agent.listFilesInPath();
    print(fileList.toString());
    logger.i(fileList);
    expect(fileList.length, isNot(0));
    print(fileList[0].toString());
    print('the above is the filelist');
  });

  test('read existing reminder.json file and return a List<Reminder> array',
      () async {
    var agent = Agent('User-API-Unit-test', directory);
    agent.loadSampleReminderData;
    expect(() => agent.writeRemindersToFile(), returnsNormally);
    List<Reminder> testReminderList = await agent.readRemindersFile();
    print(testReminderList.toString());
    for (Reminder rem in testReminderList) {
      print(rem.toJson());
    }
  });
  */
}
