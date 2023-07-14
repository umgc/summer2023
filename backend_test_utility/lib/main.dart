import 'package:backend_services/backend_services_exports.dart';
import 'package:backend_test_utility/ambients.dart';
import 'package:backend_test_utility/app_startup.dart';
import 'package:backend_test_utility/test_screens/app_instance_screen.dart';
import 'package:backend_test_utility/test_screens/gpt_summary_screen.dart';
import 'package:backend_test_utility/test_screens/websocket_screen.dart';
import 'package:flutter/material.dart';
import 'package:backend_services/agent.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStartup.startup();
  getIt<Agent>().generateInstanceCode();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Utility',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MainScreen(title: 'Test Utility Main Screen'),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.title});

  final String title;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(children: [
          Expanded(
              child: ListView(children: [
            ListTile(
              leading: const Text('Test Secret:'),
              title: Text(EnvironmentVars.testSecret),
            ),
            ScreenMenuItem(
                title: 'App Instance Tests',
                buttonKey: WidgetKeys.appInstanceCodeTestsButton,
                builder: (context) =>
                    const AppInstanceScreen(title: 'App Instance Tests')),
            ScreenMenuItem(
                title: 'WebSocket Tests',
                buttonKey: WidgetKeys.webSocketTestsButton,
                builder: (context) =>
                    const WebSocketScreen(title: 'WebSocket Tests')),
            ScreenMenuItem(
                title: 'GPT Summary Tests',
                buttonKey: WidgetKeys.gptSummaryTestsButton,
                builder: (context) =>
                    const GptSummaryScreen(title: 'GPT Summary Tests')),
          ])),
        ]));
  }
}

class ScreenMenuItem extends StatelessWidget {
  const ScreenMenuItem(
      {super.key,
      required this.title,
      required this.buttonKey,
      required this.builder});

  final Key buttonKey;
  final String title;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: ElevatedButton(
        key: buttonKey,
        child: Text(title),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: builder),
          );
        },
      ),
    );
  }
}
