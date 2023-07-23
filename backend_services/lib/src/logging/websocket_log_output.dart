import 'package:backend_services/src/websocket-client/websocket_client.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../environment_vars.dart';

class WebSocketLogOutput extends LogOutput {
  WebSocketLogOutput({required this.wsUrl, required this.wsConnectTimeout});

  final String wsUrl;
  final Duration wsConnectTimeout;
  WebSocketClient? websocketClient;

  @override
  void init() {
    websocketClient = WebSocketClient(wsUrl, wsConnectTimeout, []);
    websocketClient!.connect();
  }

  @override
  void output(OutputEvent event) {
    for (var line in event.lines) {
      try {
        if (websocketClient != null && websocketClient!.isConnected) {
          websocketClient!.send(EnvironmentVars.besieLogTopic, line);
        }
      } catch (error) {
        if (!kReleaseMode) {
          print('Error writing to websocket logger.');
        }
      }
    }
  }
}
