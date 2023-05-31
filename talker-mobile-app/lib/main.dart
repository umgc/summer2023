import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:talker_mobile_app/screens/conversationsListScreen.dart';
import 'package:talker_mobile_app/screens/homeScreen.dart';
import 'package:talker_mobile_app/screens/recordingScreen.dart';
import 'package:talker_mobile_app/state/conversations_provider.dart';

Future main() async {
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

  runApp(ChangeNotifierProvider<ConversationsProvider>(
    create: (_) => ConversationsProvider(),
    child: MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomeScreen(),
        '/recording': (context) => const RecordingScreen(),
        '/conversationsList': (context) => const ConversationsListScreen(),
      },
    ),
  ));
}
