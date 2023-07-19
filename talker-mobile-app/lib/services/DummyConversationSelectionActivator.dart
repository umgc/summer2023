import 'package:backend_services/interfaces/recording_selection_activator.dart';
import 'package:flutter/material.dart';

class DummyConversationSelectionActivator
    implements RecordingSelectionActivator {
  DummyConversationSelectionActivator(this.rootContext);

  bool didCallSelector = false;
  BuildContext rootContext;

  @override
  RecordingSelectionActivatorCallback getSelectorCallback() {
    return () async {
      didCallSelector = true;

      if (!rootContext.mounted) return;
      Navigator.pushNamed(rootContext, '/conversationSelection');
    };
  }
}
