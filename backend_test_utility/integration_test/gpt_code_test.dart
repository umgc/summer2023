@Timeout(Duration(seconds: 60))

import 'dart:convert';

import 'package:backend_services/backend_services_exports.dart';
import 'package:backend_services/backend_services_testing_exports.dart';
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

  //#region Extract form values

  test('Send transcript and form values to OpenAI for form fill', () async {
    final conversation = TestConversations.sampleConversations.firstWhereOrNull(
        (convo) => convo.id == TestConversations.umgcAdmissionsInfoGuid);

    expect(conversation, isNotNull);
    expect(conversation!.transcript, isNotEmpty);

    // send to chatgpt
    final gpt = GptCalls(EnvironmentVars.openAIApiKey);
    final completion = await gpt.extractFormValuesFromTranscript(
        conversation.transcript,
        'This Profile',
        TestFormFields
            .umgcRegistrationFormFields); //Todo implement user profile argument if desired
    var resultObject = jsonDecode(completion);
    logger.i(resultObject);
  });

  test('extract info from form field list 2', () async {
    var gpt = GptCalls(EnvironmentVars.openAIApiKey);
    var testConvos = TestConversations.sampleConversations;
    var convo = testConvos.firstWhereOrNull(
        (convo) => convo.id == TestConversations.umgcAdmissionsInfoGuid);

    expect(convo, isNotNull);

    var result =
        await gpt.extractFormValuesFromTranscript(convo!.transcript, '', {
      'FirstName': 'text',
      "LastName": "text",
      "Email": "text",
      "Address1": "text",
      "Address2": "text",
      "City": "text",
      "State": "text",
      "zip": "text"
    });

    var resultObject = jsonDecode(result);
    logger.i(resultObject);
  });

  test('extract info from HTML form', () async {
    var gpt = GptCalls(EnvironmentVars.openAIApiKey);
    var testConvos = TestConversations.sampleConversations;
    var convo = testConvos.firstWhereOrNull(
        (convo) => convo.id == TestConversations.workHistoryGuid);

    expect(convo, isNotNull);

    var result = await gpt.extractHtmlFormValuesFromTranscript(
        convo!.transcript, '', TestForms.monsterWorkExperience);

    var resultObject = jsonDecode(result);
    logger.i(resultObject);
  });

  //#endregion Extract Form Values

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

    String? result = await gpt.getReminders(
        conversation.transcript, 'User profile.', conversation.recordedDate);
    logger.i(result);
  });

  test('Send reminder text to OpenAI for conversion to JSON', () async {
    final conversation = TestConversations.sampleConversations.firstWhereOrNull(
        (convo) => convo.id == '866731c8-a9cd-408c-ae04-886f31a42493');
    final gpt = GptCalls(EnvironmentVars.openAIApiKey);
    expect(conversation, isNotNull);
    expect(conversation!.gptReminders, isNotEmpty);

    String? result = await gpt.convertRemindersToJson(
        conversation.gptReminders, conversation.id, conversation.recordedDate);
    logger.i(result);
  });
}
