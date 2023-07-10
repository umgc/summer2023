import 'package:backend_services/agent.dart';
import 'package:backend_services/interfaces/recording_selection_activator.dart';
import 'package:logger/logger.dart';

class TestRecordingSelectionActivator implements RecordingSelectionActivator {
  TestRecordingSelectionActivator(this._agent);

  final Agent _agent;
  final _logger = Logger();
  bool didCallSelector = false;

  @override
  RecordingSelectionActivatorCallback getSelectorCallback() {
    return () async {
      _logger.i('Recording selector callback called.');
      didCallSelector = true;
      _agent.loadSampleRecordingData();
      var recordingGuid = '173d6dc0-fb47-4284-bd09-9465177f8eea';
      _agent.extractFormValues(recordingGuid);
    };
  }
}
