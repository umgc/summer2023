import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:talker_mobile_app/screens/conversationDetailsScreen.dart';
import 'package:talker_mobile_app/screens/conversationsListScreen.dart';
import 'package:talker_mobile_app/screens/eulaScreen.dart';
import 'package:talker_mobile_app/screens/guidedTourScreen.dart';
import 'package:talker_mobile_app/screens/informationScreen.dart';
import 'package:talker_mobile_app/screens/recordingScreen.dart';
import 'package:talker_mobile_app/state/conversations_provider.dart';

import 'globals.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Globals.appDirectory = await getApplicationDocumentsDirectory();

  runApp(ChangeNotifierProvider<ConversationsProvider>(
    create: (_) => ConversationsProvider(),
    child: MaterialApp(
      initialRoute: '/conversationsList',
      routes: {
        '/conversationsList': (context) => const ConversationsListScreen(),
        '/information': (context) => const InformationScreen(),
        '/conversationDetailsScreen': (context) =>
            const ConversationDetailsScreen(),
        '/recording': (context) => const RecordingScreen(),
        '/guidedTour': (context) => const GuidedTourScreen(),
        '/eula': (context) => const EulaScreen()
      },
    ),
  ));
}
