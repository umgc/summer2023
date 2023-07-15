import 'dart:io';

import 'package:backend_services/backend_services_exports.dart';
import 'package:backend_services/src/gpt-service/GptCalls.dart';
import 'package:collection/collection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

  await dotenv.load();
  final logger = Logger();

  test('Send transcript to OpenAI for summary', () async {
    var agent = Agent('browser-extension-api-unit-test', directory);
    print(agent.conversationsProvider.conversations.toString());
    // TODO: Call GptCalls instead of agent and pass in transcript.
    String? result =
        await agent.getOpenAiSummary('c74dcec0-6fb7-45a9-98da-472e13413dd8');
    logger.i(result);
  });

  test('Send transcript and form values to OpenAI for form fill', () async {
    // final agent = Agent('browser-extension-api-unit-test', conversations: TestConversations.sampleConversations);
    // final recordingTranscript =
    //     agent.getRecordingTranscript('173d6dc0-fb47-4284-bd09-9465177f8eea');
    final conversation = TestConversations.sampleConversations.firstWhereOrNull(
        (convo) => convo.id == '173d6dc0-fb47-4284-bd09-9465177f8eea');

    expect(conversation, isNotNull);
    expect(conversation!.transcript, isNotEmpty);

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
    final gpt = GptCalls(EnvironmentVars.openAIApiKey);
    final completion = await gpt.extractFormValuesFromTranscript(
        conversation.transcript,
        'This Profile',
        formFields); //Todo implement user profile argument if desired
    logger.i(completion);
  });
}
