import 'package:backend_services/agent.dart';
import 'package:backend_services/interfaces/recording_selection_activator.dart';
import 'package:logger/logger.dart';

class TestSelectionAndExtractionActivator
    implements RecordingSelectionActivator {
  TestSelectionAndExtractionActivator(this._agent, this._recordingGuid);

  final Agent _agent;
  final String _recordingGuid;
  final _logger = Logger();
  bool didCallSelector = false;

  @override
  RecordingSelectionActivatorCallback getSelectorCallback() {
    return () async {
      _logger.i('Recording selector callback called.');
      didCallSelector = true;
      _agent.extractFormValues(_recordingGuid);
    };
  }
}
