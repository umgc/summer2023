import 'package:backend_services/interfaces/recording_selection_activator.dart';
import 'package:logger/logger.dart';

class TestRecordingSelector implements RecordingSelectionActivator {
  final _logger = Logger();

  @override
  RecordingSelectionActivatorCallback getSelectorCallback() {
    return () {
      _logger.i('Recording selector callback called.'); 
    };
  }
}
