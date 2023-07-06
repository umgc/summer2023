import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:backend_services/agent.dart';
import 'package:backend_services/model/recording.dart';
import 'package:logger/logger.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final logger = Logger();





//todo 

//todo load recordings from files

//todo save recordingList to files

//todo create recording

//todo delete recording

  test('write recordings to multiple reminder JSON files', () {
    var agent = Agent('Recording-extension-api-unit-test');
    agent.loadSampleRecordingData;
    expect(() => agent.writeRecordingsToFile(), returnsNormally);
  });

    test('write recording JSON files and return a list of directory contents', () async {
    var agent = Agent('Recording-API-Unit-test');
    agent.loadSampleRecordingData();
    logger.i(await agent.writeRecordingsToFile());    
    List fileList = await agent.listFilesInPath();
    print(await fileList.toString());
    logger.i(await fileList);
    expect( await fileList.length, equals(5));



  });

  test('read existing recording JSON files and return list of files', () async {
    var agent = Agent('Recording-API-Unit-test');
    expect(() => agent.loadSampleRecordingData(), returnsNormally);
    expect(() => agent.writeRecordingsToFile(), returnsNormally);
    Future<String?> result = agent.readRecordingsFile();
    expect(() => result, isNotNull);
    logger.i(await result);
    print(await result);


  });


}
