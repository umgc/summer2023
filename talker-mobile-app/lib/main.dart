import 'package:backend_services/backend_services_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:talker_mobile_app/screens/conversationDetailsScreen.dart';
import 'package:talker_mobile_app/screens/conversationsListScreen.dart';
import 'package:talker_mobile_app/screens/eulaScreen.dart';
import 'package:talker_mobile_app/screens/guidedTourScreen.dart';
import 'package:talker_mobile_app/screens/informationScreen.dart';
import 'package:talker_mobile_app/screens/recordingScreen.dart';
import 'package:talker_mobile_app/services/fileHelpers.dart';

import 'globals.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Globals.appDirectory = await getApplicationDocumentsDirectory();
  List<Conversation> conversations = getConversationsFromJsonFile(
      "${Globals.appDirectory?.path}/conversations.json");
  await dotenv.load();
  getIt.registerSingleton<Agent>(
      Agent('convobuddy-app', conversations: conversations),
      dispose: (agent) => agent.shutdown());
  getIt<Agent>().generateInstanceCode();

  runApp(ChangeNotifierProvider<ConversationsProvider>(
    create: (_) => getIt<Agent>().conversationsProvider,
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
