import 'package:backend_services/interfaces/recording_selection_activator.dart';
import 'package:flutter/material.dart';

import '../globals.dart';
import '../notifications_service.dart';

class ConversationSelectionActivator implements RecordingSelectionActivator {
  ConversationSelectionActivator(this.rootContext);

  bool didCallSelector = false;
  BuildContext rootContext;

  @override
  RecordingSelectionActivatorCallback getSelectorCallback() {
    return () async {
      didCallSelector = true;

      if (!rootContext.mounted) return;
      NotificationsService.showBigTextNotification(
          title: "Request from Form Fill-In Extension",
          body: "Select a conversation",
          fln: flutterLocalNotificationsPlugin);
    };
  }
}
