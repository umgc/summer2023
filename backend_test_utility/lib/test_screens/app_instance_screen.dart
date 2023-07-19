import 'package:backend_test_utility/ambients.dart';
import 'package:flutter/material.dart';
import 'package:backend_services/agent.dart';

class AppInstanceScreen extends StatefulWidget {
  const AppInstanceScreen({super.key, required this.title});

  final String title;

  @override
  State<AppInstanceScreen> createState() => _AppInstanceScreenState();
}

class _AppInstanceScreenState extends State<AppInstanceScreen> {
  String _appCode = '';

  void _generateAppCode() {
    getIt<Agent>().generateInstanceCodeIfNone().then((value) => setState(() {
          _appCode = value;
        }));
  }

  void _resetAppInstanceCode() {
    getIt<Agent>().resetAppInstanceCode().whenComplete(() async {
      try {
        await getIt<Agent>().getInstanceCode().then((value) => setState(() {
              _appCode = value;
            }));
      } catch (error) {
        setState(() {
          _appCode = error.toString();
        });
      }
    });
  }

  @override
  void initState() {
    _resetAppInstanceCode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
            title: Text(_appCode, key: WidgetKeys.appCodeTextField),
          ),
          ListTile(
              title: ElevatedButton(
                  key: WidgetKeys.generateAppCodeButton,
                  onPressed: () => _generateAppCode(),
                  child: const Text('Generate App Code'))),
          ListTile(
              title: ElevatedButton(
                  key: WidgetKeys.resetAppCodeButton,
                  onPressed: () => _resetAppInstanceCode(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.error,
                    backgroundColor:
                        Theme.of(context).colorScheme.errorContainer,
                  ),
                  child: const Text('Reset App Instance Code')))
        ]));
  }
}
