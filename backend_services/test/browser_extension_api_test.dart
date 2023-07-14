import 'package:backend_services/interfaces/recording_selection_activator.dart';
import 'package:backend_services/model/be_request.dart';
import 'package:backend_services/src/gpt-service/GptCalls.dart';
import 'package:backend_services/src/test-data/test_conversations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:backend_services/agent.dart';
import 'package:logger/logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'browser_extension_api_test.mocks.dart';

class TestRecordingSelectionActivator implements RecordingSelectionActivator {
  TestRecordingSelectionActivator();

  final _logger = Logger();
  bool didCallSelector = false;

  @override
  RecordingSelectionActivatorCallback getSelectorCallback() {
    return () async {
      _logger.i('Recording selector callback called.');
      didCallSelector = true;
    };
  }
}

// Run "dart run build_runner build" from the command line to regenerate RecordingSelectionActivator
@GenerateNiceMocks([MockSpec<RecordingSelectionActivator>()])
void main() {
  var logger = Logger();

  test('get app instance code, not initialized', () {
    var agent = Agent('browser-extension-api-unit-test');
    expect(() => agent.getInstanceCode(), throwsA(anything));
  });

  test('get app instance code, initialized', () {
    var agent = Agent('browser-extension-api-unit-test');
    agent.generateInstanceCode();
    var code = agent.getInstanceCode();
    logger.i(code);
    expect(code, '8736');
  });

  test('receive form fill request', () async {
    var agent = Agent('browser-extension-api-unit-test');
    var mockSelector = MockRecordingSelectionActivator();
    var didCallSelector = false;
    when(mockSelector.getSelectorCallback())
        .thenAnswer(((realInvocation) => () async {
              didCallSelector = true;
            }));

    agent.setRecordingSelector(mockSelector);

    agent.generateInstanceCode();
    var instanceCode = agent.getInstanceCode();
    expect(instanceCode, isNotNull);
    expect(instanceCode, isNotEmpty);

    var formFields = ["name"];
    var request = BERequest(instanceCode, formFields);
    await agent.receiveFormValuesRequest(request);
    verify(mockSelector.getSelectorCallback()).called(1);

    expect(didCallSelector, true);
  });

  test('Send transcript and form values to OpenAI for form fill', () async {
    final agent = Agent('browser-extension-api-unit-test',
        conversations: TestConversations.sampleConversations);
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
    final gpt = GptCalls('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');
    final completion = await gpt.extractFormValuesFromTranscript(
        recordingTranscript,
        'This Profile',
        formFields); //Todo implement user profile argument if desired
    logger.i(completion);
  });
}
