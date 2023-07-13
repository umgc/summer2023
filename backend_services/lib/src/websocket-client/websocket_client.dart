import 'package:backend_services/src/websocket-client/websocket_listener.dart';
import 'package:logger/logger.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';

class WebSocketClient {
  final String _wsUrl;
  final int _wsConnectTimeoutMs;
  final List<WebSocketListener> _listeners;
  final Logger _logger = Logger();
  StompClient? _webSocketClient;
  bool _isConnected = false;

  WebSocketClient(this._wsUrl, this._wsConnectTimeoutMs, this._listeners);

  void connect() {
    _logger.i("Opening connection to websocket server at '$_wsUrl'.");
    _webSocketClient = StompClient(
        config: StompConfig.SockJS(
            url: _wsUrl,
            connectionTimeout: Duration(milliseconds: _wsConnectTimeoutMs),
            onConnect: _onConnectCallback,
            onDisconnect: _onDisconnectCallback,
            onStompError: _onStompError,
            onDebugMessage: _onStompDebugMessage,
            onWebSocketError: _onWebSocketError));
    _logger.d('Activating STOMP over WebSocket...');
    _webSocketClient!.activate();
  }

  void _onConnectCallback(StompFrame connectFrame) {
    // client is connected and ready
    _isConnected = true;
    _logger.i('STOMP over WebSocket connected');
    if (_webSocketClient != null) {
      for (var listener in _listeners) {
        _webSocketClient!.subscribe(
            destination: listener.topic,
            headers: {},
            callback: listener.callback);
        _logger.i('Listening for ${listener.topic}...');
      }
    }
  }

  void _onDisconnectCallback(StompFrame disconnectFrame) {
    _logger.i('STOMP over WebSocket disconnected unexpectedly.');
  }

  send(String topic, String json) {
    if (!_isConnected || _webSocketClient == null) {
      throw "WebSocket not connected";
    }
    _webSocketClient!.send(
      destination: topic,
      headers: {},
      body: json,
    );
  }

  disconnect() {
    if (_webSocketClient != null) {
      _isConnected = false;
      _webSocketClient!.deactivate();
      _webSocketClient = null;
    }
    _logger.i('WebSocket client disconnected');
  }

  void _onStompError(StompFrame frame) {
    _logger.e("stomp error: ${frame.toString()}");
  }

  void _onWebSocketError(dynamic error) {
    _logger.e("web socket error: ${error.toString()}");
  }

  void _onStompDebugMessage(String message) {
    _logger.d("stomp debug message: $message");
  }
}
