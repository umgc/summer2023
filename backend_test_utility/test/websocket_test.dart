import 'dart:convert';

import 'package:backend_services/backend_services_testing_exports.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'websocket_test.mocks.dart';

// Run "dart run build_runner build" from the command line to regenerate WebSocketClient
@GenerateNiceMocks([MockSpec<WebSocketClient>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('verify we can call methods on our mock WebSocketClient',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    var mockClient = MockWebSocketClient();

    mockClient.connect();
    verify(mockClient.connect());

    mockClient.send('topic', jsonEncode({"some": "json"}));
    verify(mockClient.send(any, any));
  });
}
