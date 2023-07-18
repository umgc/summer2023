import 'dart:io';

import 'package:backend_services/agent.dart';
import 'package:backend_services/model/be_request.dart';
import 'package:backend_test_utility/test_recording_selection_activator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

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
    var agent = Agent('browser-extension-api-unit-test', directory);
    var selectionActivator = TestRecordingSelectionActivator();
    agent.setRecordingSelector(selectionActivator);

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

  test('extract form values, app instance code initialized and passed in',
      () async {
    var agent = Agent('browser-extension-api-unit-test', directory);
    var selectionActivator = TestRecordingSelectionActivator();
    agent.setRecordingSelector(selectionActivator);

    await agent.generateInstanceCodeIfNone();
    var instanceCode = await agent.getInstanceCode();
    expect(instanceCode, isNotNull);
    expect(instanceCode, isNotEmpty);
    logger.i('instanceCode: $instanceCode');

    var formFields = ["name"];
    await agent.receiveFormValuesRequest(BERequest(instanceCode, formFields));
    expect(selectionActivator.didCallSelector, true);
  });
}
