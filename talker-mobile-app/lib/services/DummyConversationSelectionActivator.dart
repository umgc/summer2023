import 'package:backend_services/agent.dart';
import 'package:backend_services/interfaces/recording_selection_activator.dart';
import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:talker_mobile_app/globals.dart';

class DummyConversationSelectionActivator implements RecordingSelectionActivator {
  DummyConversationSelectionActivator(this.rootContext);
  
  bool didCallSelector = false;
  BuildContext rootContext;

  @override
  RecordingSelectionActivatorCallback getSelectorCallback() {
    return () async {
      didCallSelector = true;
      
      PanaraInfoDialog.show(
          rootContext, 
          title: "Dummy Selection",
          message: "This is where the conversation selection should happen.",
          buttonText: "Okay",
          onTapDismiss: () {
              Navigator.pop(rootContext);
          },
          panaraDialogType: PanaraDialogType.normal,
          barrierDismissible: false, 
      );

      // This will call ChatGPT to extact form values from the selected conversation
      // and send the results back to the browser extension through BESie
      var recordingGuid = 'some-recording-guid'; // here would go the conversation guid
      getIt<Agent>().extractFormValues(recordingGuid);
    };
  }
}
