typedef RecordingSelectionActivatorCallback = void Function();

abstract class RecordingSelectionActivator {
  RecordingSelectionActivatorCallback getSelectorCallback();
}
