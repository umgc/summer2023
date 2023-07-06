import 'package:backend_test_utility/ambients.dart';
import 'package:backend_test_utility/app_startup.dart';
import 'package:flutter/material.dart';
import 'package:backend_test_utility/ambients.dart';
import 'package:backend_services/agent.dart';

class AppInstanceScreen extends StatefulWidget {
  const AppInstanceScreen({super.key, required this.title});

  final String title;

  @override
  State<AppInstanceScreen> createState() => _AppInstanceScreenState();
}

class _AppInstanceScreenState extends State<AppInstanceScreen> {
  void _generateAppCode() {
    setState(() {
      getIt<Agent>().generateInstanceCode();
    });
  }

  void _resetAgent() {
    setState(() {
      AppStartup.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    var appCode = (() {
      try {
        return getIt<Agent>().getInstanceCode();
      } catch (error) {
        return error.toString();
      }
    })();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(widget.title),
        ),
        body: Column(children: [
          ListTile(
            leading: Text(
              'App Instance Code:',
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.bodyMedium?.fontSize),
            ),
            title: Text(appCode, key: WidgetKeys.appCodeTextField),
          ),
          ListTile(
              title: ElevatedButton(
                  key: WidgetKeys.generateAppCodeButton,
                  onPressed: () => _generateAppCode(),
                  child: const Text('Generate App Code'))),
          ListTile(
              title: ElevatedButton(
                  key: WidgetKeys.resetAgentButton,
                  onPressed: () => _resetAgent(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                  ),
                  child: const Text('Reset Agent')))
        ]));
  }
}
