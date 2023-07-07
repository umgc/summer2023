import 'package:backend_services/agent.dart';
import 'package:backend_services/interfaces/recording_selection_activator.dart';
import 'package:backend_test_utility/ambients.dart';
import 'package:logger/logger.dart';

class TestRecordingSelectionActivator implements RecordingSelectionActivator {
  final _logger = Logger();
  bool didCallSelector = false;

  @override
  RecordingSelectionActivatorCallback getSelectorCallback() {
    return () async {
      _logger.i('Recording selector callback called.'); 
      didCallSelector = true;
      var recordingGuid = 'some-recording-guid';
      getIt<Agent>().extractFormValues(recordingGuid);
    };
  }
}
