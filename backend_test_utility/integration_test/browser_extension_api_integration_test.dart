import 'dart:convert';
import 'dart:io';

import 'package:backend_services/backend_services_exports.dart';
import 'package:backend_services/backend_services_testing_exports.dart';
import 'package:backend_services/model/be_request.dart';
import 'package:backend_test_utility/test_recording_selection_activator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logger/logger.dart';
import 'package:mockito/mockito.dart';
import 'package:path_provider/path_provider.dart';

import '../test/websocket_test.mocks.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

  await dotenv.load();
  final logger = Logger();

  test('get app instance code, not initialized', () async {
    var agent = Agent('browser-extension-api-unit-test', directory);
    expectLater(agent.getInstanceCode(), throwsA(anything));
  });

  test('get app instance code, initialized', () async {
    var agent = Agent('browser-extension-api-unit-test', directory);
    await agent.generateInstanceCodeIfNone();
    var code = await agent.getInstanceCode();
    logger.i(code);
    // expect 4 digit number
    final regExp = RegExp(r'^\d{4}$');
    expect(regExp.hasMatch(code), true);
  });

  test('get app instance code, initialized twice and unchanged', () async {
    var agent = Agent('browser-extension-api-unit-test', directory,
        recordingSelectionActivator: TestRecordingSelectionActivator());

    await agent.generateInstanceCodeIfNone();
    var instanceCode = await agent.getInstanceCode();
    expect(instanceCode, isNotNull);
    expect(instanceCode, isNotEmpty);
    logger.i('instanceCode: $instanceCode');

    await agent.generateInstanceCodeIfNone();
    var secondInstanceCode = await agent.getInstanceCode();
    expect(secondInstanceCode, isNotNull);
    expect(secondInstanceCode, isNotEmpty);
    logger.i('secondInstanceCode: $secondInstanceCode');

    expect(secondInstanceCode, instanceCode);
  });

  test(
      'receive form values extracton request with form fields list, app instance code initialized and passed in, verify selector called',
      () async {
    var selectionActivator = TestRecordingSelectionActivator();
    var agent = Agent('browser-extension-api-unit-test', directory,
        recordingSelectionActivator: selectionActivator);

    await agent.generateInstanceCodeIfNone();
    var instanceCode = await agent.getInstanceCode();
    expect(instanceCode, isNotNull);
    expect(instanceCode, isNotEmpty);
    logger.i('instanceCode: $instanceCode');

    var formFields = ["name"];
    await agent.receiveFormValuesRequest(BERequest(instanceCode, formFields));
    expect(selectionActivator.didCallSelector, true);
  });

  test(
      'receive form values extracton request with form html, app instance code initialized and passed in, verify selector called',
      () async {
    var selectionActivator = TestRecordingSelectionActivator();
    var agent = Agent('browser-extension-api-unit-test', directory,
        recordingSelectionActivator: selectionActivator);

    await agent.generateInstanceCodeIfNone();
    var instanceCode = await agent.getInstanceCode();
    expect(instanceCode, isNotNull);
    expect(instanceCode, isNotEmpty);
    logger.i('instanceCode: $instanceCode');

    var formHtml = TestForms.petCoRegistration;
    await agent.receiveFormValuesRequest(
        BERequest.withFormHtml(instanceCode, formHtml));
    expect(selectionActivator.didCallSelector, true);
  });

  test(
      'extract form values with field list, app instance code initialized and passed in, verify field values extracted',
      () async {
    var mockClient = MockWebSocketClient();
    String topic = '';
    dynamic formValues;
    when(mockClient.send(any, any)).thenAnswer((realInvocation) {
      topic = realInvocation.positionalArguments[0] as String;
      formValues = realInvocation.positionalArguments[1];
    });
    var selectionActivator = TestRecordingSelectionActivator();
    var agent = Agent('browser-extension-api-unit-test', directory,
        recordingSelectionActivator: selectionActivator,
        webSocketClient: mockClient);
    await agent.loadSampleConversations();

    await agent.generateInstanceCodeIfNone();
    var instanceCode = await agent.getInstanceCode();
    expect(instanceCode, isNotNull);
    expect(instanceCode, isNotEmpty);
    logger.i('instanceCode: $instanceCode');

    await agent.receiveFormValuesRequest(
        BERequest(instanceCode, TestFormFields.umgcRegistrationFormFields));

    await agent.extractFormValues(TestConversations.umgcAdmissionsInfoGuid);
    verify(mockClient.send(
        captureThat(equals(EnvironmentVars.formFillResponseTopic)), any));
    logger.i("topic: $topic");
    logger.i("formValues: $formValues");
  });

  test(
      'extract form values from form html, app instance code initialized and passed in, verify field values extracted',
      () async {
    var mockClient = MockWebSocketClient();
    String topic = '';
    dynamic formValues;
    when(mockClient.send(any, any)).thenAnswer((realInvocation) {
      topic = realInvocation.positionalArguments[0] as String;
      formValues = realInvocation.positionalArguments[1];
    });
    var selectionActivator = TestRecordingSelectionActivator();
    var agent = Agent('browser-extension-api-unit-test', directory,
        recordingSelectionActivator: selectionActivator,
        webSocketClient: mockClient);
    await agent.loadSampleConversations();

    await agent.generateInstanceCodeIfNone();
    var instanceCode = await agent.getInstanceCode();
    expect(instanceCode, isNotNull);
    expect(instanceCode, isNotEmpty);
    logger.i('instanceCode: $instanceCode');

    await agent.receiveFormValuesRequest(
        BERequest.withFormHtml(instanceCode, TestForms.monsterWorkExperience));

    await agent.extractFormValues(TestConversations.workHistoryGuid);
    verify(mockClient.send(
        captureThat(equals(EnvironmentVars.formFillResponseTopic)), any));
    logger.i("topic: $topic");
    logger.i("formValues: $formValues");
    var formValuesJson = jsonEncode(formValues);
    logger.i("formValuesJson: $formValuesJson");
  });
}
