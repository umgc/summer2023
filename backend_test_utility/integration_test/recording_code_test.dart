import 'dart:io';

import 'package:backend_services/agent.dart';
import 'package:backend_services/backend_services_exports.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

  final logger = Logger();

//todo

//todo load recordings from files

//todo save recordingList to files

//todo create recording

//todo delete recording

  // test('write recordings to multiple reminder JSON files', () {
  //   var agent = Agent('Recording-extension-api-unit-test');
  //   expect(() => agent.writeRecordingsToFile(), returnsNormally);
  // });

  // test('write recording JSON files and return a list of directory contents',
  //     () async {
  //   var agent = Agent('Recording-API-Unit-test');
  //   agent.loadSampleRecordingData();
  //   logger.i(await agent.writeRecordingsToFile());
  //   List fileList = await agent.listFilesInPath();
  //   print(await fileList.toString());
  //   logger.i(await fileList);
  //   expect(await fileList.length, equals(5));
  // });

  test('read existing recording JSON files and return list of files', () async {
    var agent = Agent('Recording-API-Unit-test', directory);
    expect(() => agent.conversationsProvider.conversations, returnsNormally);
    // expect(() => agent.writeRecordingsToFile(), returnsNormally);
    var result = agent.conversationsProvider.conversations.toString();
    expect(result, isNotNull);
    logger.i(result);
  });
}
