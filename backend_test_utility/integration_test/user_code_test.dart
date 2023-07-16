import 'dart:io';

import 'package:backend_services/agent.dart';
import 'package:backend_services/model/user.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

  final logger = Logger();



  test('write user to user.json', () {
    var agent = Agent('browser-extension-api-unit-test', directory);
    expect(() => agent.writeUserToFile(), returnsNormally);
    //logger.i(await json);
  });

    test('read existing user JSON file and return a string', () async {
    var agent = Agent('Reminder-API-Unit-test', directory);
    agent.setProfile('This Profile');
    expect(() => agent.writeUserToFile(), returnsNormally);
    List fileList = agent.listFilesInPath();
    print(fileList.toString());
    Future<User?> userResult = agent.readUserFromFile();
    print(await userResult);
    expect(() => userResult, isNotNull);
    logger.i(await userResult);
    //expect(() => json, isNotEmpty);
  });
}
