import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talker_mobile_app/screens/conversationDetailsScreen.dart';
import 'package:talker_mobile_app/screens/conversationsListScreen.dart';
import 'package:talker_mobile_app/screens/recordingScreen.dart';
import 'package:talker_mobile_app/state/conversations_provider.dart';

Future main() async {
  await Future.delayed(const Duration(seconds: 1));

  runApp(ChangeNotifierProvider<ConversationsProvider>(
    create: (_) => ConversationsProvider(),
    child: MaterialApp(
      initialRoute: '/conversationsList',
      routes: {
        '/conversationsList': (context) => const ConversationsListScreen(),
        '/conversationDetailsScreen': (context) =>
            const ConversationDetailsScreen(),
        '/recording': (context) => const RecordingScreen(),
      },
    ),
  ));
}
