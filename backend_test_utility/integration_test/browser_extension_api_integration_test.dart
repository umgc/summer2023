import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:backend_services/src/agent.dart';
import 'package:logger/logger.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  final logger = Logger();

  test('get app instance code, not initialized', () {
    var agent = Agent('browser-extension-api-unit-test');
    var code = agent.instanceCode;
    logger.i(code);
    expect(code, isNull);
  });

  test('get app instance code, initialized', () {
    var agent = Agent('browser-extension-api-unit-test');
    agent.generateInstanceCode();
    var code = agent.instanceCode;
    logger.i(code);
    expect(code, isNotNull);
    expect(code, isNotEmpty);
  });

  test('extract form values, app instance code initialized and passed in',
      () async {
    var agent = Agent('browser-extension-api-unit-test');
    agent.generateInstanceCode();
    var instanceCode = agent.getInstanceCode();
    expect(instanceCode, isNotNull);
    expect(instanceCode, isNotEmpty);

    var formFields = ["name"];
    var formValues = agent.extractFormValues(instanceCode, formFields);
    logger.i(json.encode(formValues));
    expect(formValues, isNotNull);
    expect(formValues, isNotEmpty);
  });
}
