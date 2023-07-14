import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:backend_services/agent.dart';
import 'package:logger/logger.dart';
import 'package:backend_services/src/gpt-service/GptCalls.dart';
import 'package:backend_services/src/test-data/test_conversations.dart';
import 'package:collection/collection.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  final openAIApiKey = dotenv.env['OPENAI_API_KEY']!;
  final logger = Logger();

  test('Send transcript to OpenAI for summary', () async {
    var agent = Agent('browser-extension-api-unit-test',
        conversations: TestConversations.sampleConversations);
    agent.initializeOpenAIApiKey();
    print(agent.conversationsProvider.conversations.toString());
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
    final gpt = GptCalls(openAIApiKey);
    final completion = await gpt.extractFormValuesFromTranscript(
        conversation.transcript,
        'This Profile',
        formFields); //Todo implement user profile argument if desired
    logger.i(completion);
  });
}
