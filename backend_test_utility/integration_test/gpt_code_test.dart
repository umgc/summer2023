import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:backend_services/agent.dart';
import 'package:backend_services/model/reminder.dart';
import 'package:logger/logger.dart';
import 'package:backend_services/src/recording-service/GptCalls.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  final openAIApiKey = dotenv.env['OPENAI_API_KEY']!;
  final logger = Logger();

  test('Send transcript to OpenAI for summary', () async {
    var agent = Agent('browser-extension-api-unit-test');
    agent.loadSampleRecordingData();
    print(agent.recordingList.toString());
    Future<String?> result =
        agent.getOpenAiSummary('c74dcec0-6fb7-45a9-98da-472e13413dd8');
    logger.i(await result);
    print(await result);
  });

  test('Send transcript and form values to OpenAI for form fill', () async {
    final agent = Agent('browser-extension-api-unit-test');
    agent.loadSampleRecordingData();
    final recordingTranscript =
        agent.getRecordingTranscript('173d6dc0-fb47-4284-bd09-9465177f8eea');

    final formFields = [
      "firstName",
      "lastName",
      "email",
      "address",
      "city",
      "state",
      "zip"
    ];

    // send to chatgpt
    final gpt = GptCalls(openAIApiKey);
    final completion = await gpt.extractFormValues(
        recordingTranscript,
        'This Profile',
        formFields); //Todo implement user profile argument if desired
    logger.i(completion);
  });
}
