import 'package:backend_services/interfaces/recording_selection_activator.dart';
import 'package:logger/logger.dart';

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
