import 'package:backend_services/backend_services_exports.dart';
import 'package:backend_services/src/gpt-service/GptCalls.dart';
import 'package:collection/collection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logger/logger.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  final logger = Logger();

  test('Send transcript to OpenAI for summary', () async {
    final conversation = TestConversations.sampleConversations.firstWhereOrNull(
        (convo) => convo.id == 'c74dcec0-6fb7-45a9-98da-472e13413dd8');
    final gpt = GptCalls(EnvironmentVars.openAIApiKey);
    expect(conversation, isNotNull);
    expect(conversation!.transcript, isNotEmpty);

    String? result =
        await gpt.getOpenAiSummary(conversation.transcript, 'User profile.');
    logger.i(result);
  });

  test('Send transcript and form values to OpenAI for form fill', () async {
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

    test('Send transcript to OpenAI for Restaurant Order', () async {
    final conversation = TestConversations.sampleConversations.firstWhereOrNull(
        (convo) => convo.id == '0a60bf00-a057-4ad7-87fd-534c7d407160');
    final gpt = GptCalls(EnvironmentVars.openAIApiKey);
    expect(conversation, isNotNull);
    expect(conversation!.transcript, isNotEmpty);

    String? result =
        await gpt.getRestaurantOrder(conversation.transcript, 'User profile.');
    logger.i(result);
  });

      test('Send transcript to OpenAI for Reminders', () async {
    final conversation = TestConversations.sampleConversations.firstWhereOrNull(
        (convo) => convo.id == 'e3bc7acc-3b20-4056-94b6-6199fdba5870');
    final gpt = GptCalls(EnvironmentVars.openAIApiKey);
    expect(conversation, isNotNull);
    expect(conversation!.transcript, isNotEmpty);

    String? result =
        await gpt.getReminders(conversation.transcript, 'User profile.', conversation.recordedDate);
    logger.i(result);
  });
}
