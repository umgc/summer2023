import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:backend_services/agent.dart';
import 'package:backend_services/model/reminder.dart';
import 'package:logger/logger.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final logger = Logger();





  test('Send transcript to OpenAI for summary', () async {
    var agent = Agent('browser-extension-api-unit-test');
    agent.loadSampleRecordingData();
    print(agent.recordingList.toString());
    Future<String?> result = agent.getOpenAiSummary('c74dcec0-6fb7-45a9-98da-472e13413dd8');
    logger.i(await result);
    print( await result);
  });



}
