import 'dart:io';

import 'package:backend_services/agent.dart';
import 'package:backend_services/backend_services_exports.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  Directory directory = await getApplicationDocumentsDirectory();

  final logger = Logger();

  test('read existing recording JSON files and return list of files', () async {
    var agent = Agent('Recording-API-Unit-test', directory);
    expect(() => agent.conversationsProvider.conversations, returnsNormally);

    agent.conversationsProvider.removeAllConversations();
    expect(agent.conversationsProvider.conversations.length, 0);
    agent.loadSampleConversations();
    logger.i(
        "test conversations count: ${agent.conversationsProvider.conversations.length}");
    expect(agent.conversationsProvider.conversations.length, isNot(0));

    var result = agent.conversationsProvider.conversations.toString();
    expect(result, isNotNull);
    logger.i(result);
  });
}
