import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:talker_mobile_app/screens/conversationsListScreen.dart';
import 'package:talker_mobile_app/screens/homeScreen.dart';
import 'package:talker_mobile_app/screens/recordingScreen.dart';

Future main() async {
  await Future.delayed(const Duration(seconds: 1));
  FlutterNativeSplash.remove();

  runApp(MaterialApp(
    initialRoute: '/home',
    routes: {
      '/home': (context) => const HomeScreen(),
      '/recording': (context) => const RecordingScreen(),
      '/conversationsList': (context) => const ConversationsListScreen(),
    },
  ));
}
