import 'package:backend_services/src/websocket-client/websocket_client.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

import '../environment_vars.dart';

class WebSocketLogOutput extends LogOutput {
  WebSocketLogOutput({required this.wsUrl, required this.wsConnectTimeout});

  final String wsUrl;
  final Duration wsConnectTimeout;
  WebSocketClient? websocketClient;

  final List<OutputEvent> _eventsQueue = [];

  @override
  void init() {
    websocketClient = WebSocketClient(wsUrl, wsConnectTimeout, []);
    websocketClient!.connect();
  }

  @override
  void output(OutputEvent event) {
    _eventsQueue.add(event);
    try {
      while (_eventsQueue.isNotEmpty) {
        var queueEvent = _eventsQueue[0];
        for (var line in queueEvent.lines) {
          if (websocketClient != null && websocketClient!.isConnected) {
            websocketClient!.send(EnvironmentVars.besieLogTopic, line);
            _eventsQueue.remove(queueEvent);
          }
        }
      }
    } catch (error) {
      if (!kReleaseMode) {
        print('Error writing to websocket logger.');
      }
    }
  }
}
