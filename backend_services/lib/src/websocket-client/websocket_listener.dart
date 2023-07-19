import 'package:stomp_dart_client/stomp_config.dart';

class WebSocketListener {
  WebSocketListener(this.topic, this.callback);

  final String topic;
  final StompFrameCallback callback;
}
