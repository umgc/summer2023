typedef RecordingSelectionActivatorCallback = Future<void> Function();

abstract class RecordingSelectionActivator {
  RecordingSelectionActivatorCallback getSelectorCallback();
}
