import 'package:backend_services/agent.dart';
import 'package:backend_services/interfaces/recording_selection_activator.dart';
import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:talker_mobile_app/globals.dart';

class DummyConversationSelectionActivator
    implements RecordingSelectionActivator {
  DummyConversationSelectionActivator(this.rootContext);

  bool didCallSelector = false;
  BuildContext rootContext;

  @override
  RecordingSelectionActivatorCallback getSelectorCallback() {
    return () async {
      didCallSelector = true;

      // Ensure context is still mounted before displaying dialog
      if (!rootContext.mounted) return;
      PanaraInfoDialog.show(
        rootContext,
        title: "Dummy Selection",
        message: "This is where the conversation selection should happen.",
        buttonText: "Okay",
        onTapDismiss: () async {
          // Backend services needs to finish integrating with the recordings store managed
          // by ConvoBuddy and applying transcripts back to the recording metadata. Once that
          // is done, this call will take a recording guid and call ChatGPT with the transcript
          // and forward the results to the browser extension via BESie.
          // var recordingGuid = 'some-recording-guid';
          // await getIt<Agent>().extractFormValues(recordingGuid);
          Navigator.pop(rootContext);
        },
        panaraDialogType: PanaraDialogType.normal,
        barrierDismissible: false,
      );
    };
  }
}
