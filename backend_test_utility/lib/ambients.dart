import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class WidgetKeys {
  // Main screen
  static const Key appInstanceCodeTestsButton =
      Key("app-instance-code-tests-button");
  static const Key webSocketTestsButton = Key("websocket-tests-button");
  static const Key gptSummaryTestsButton = Key("gpt-summary-tests-button");

  // App Instance Code Tests
  static const Key appCodeTextField = Key("app-code-text-field");
  static const Key generateAppCodeButton = Key("generate-app-code-button");
  static const Key resetAgentButton = Key("reset-agent-button");

  // WebSocket Tests
  static const Key webSocketStatusTextField =
      Key("websocket-status-text-field");
  static const Key sendResponseButton = Key("send-response-button");
  static const Key receiveRequestButton = Key("receive-request-button");

  // WebSocket Tests
  static const Key gptSummaryStatusTextField = Key("gpt-summary-text-field");
  static const Key requestSummaryButton = Key("request-summary-button");
}
