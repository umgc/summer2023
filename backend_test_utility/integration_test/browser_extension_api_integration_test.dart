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

  test('get app instance code, not initialized', () {
    var agent = Agent('browser-extension-api-unit-test', directory);
    expect(() => agent.getInstanceCode(), throwsA(anything));
  });

  test('get app instance code, initialized', () {
    var agent = Agent('browser-extension-api-unit-test', directory);
    agent.generateInstanceCode();
    var code = agent.getInstanceCode();
    logger.i(code);
    expect(code, '8736');
  });

  test('extract form values, app instance code initialized and passed in',
      () async {
    var agent = Agent('browser-extension-api-unit-test', directory);
    var selectionActivator = TestRecordingSelectionActivator();
    agent.setRecordingSelector(selectionActivator);

    agent.generateInstanceCode();
    var instanceCode = agent.getInstanceCode();
    expect(instanceCode, isNotNull);
    expect(instanceCode, isNotEmpty);

    var formFields = ["name"];
    await agent.receiveFormValuesRequest(BERequest(instanceCode, formFields));
    expect(selectionActivator.didCallSelector, true);
  });
}
