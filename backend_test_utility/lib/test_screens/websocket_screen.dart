import 'package:backend_services/model/be_request.dart';
import 'package:backend_services/model/be_response.dart';
import 'package:backend_test_utility/ambients.dart';
import 'package:flutter/material.dart';
import 'package:backend_services/agent.dart';

class WebSocketScreen extends StatefulWidget {
  const WebSocketScreen({super.key, required this.title});

  final String title;

  @override
  State<WebSocketScreen> createState() => _WebSocketScreenState();
}

class _WebSocketScreenState extends State<WebSocketScreen> {
  String _statusMessage = '';
  String _appCode = '';

  void _simulateRequest() async {
    try {
      var code = await getIt<Agent>().getInstanceCode();
      var fields = ['name'];
      await getIt<Agent>().receiveFormValuesRequest(BERequest(code, fields));
      setState(() {
        _statusMessage = 'request received';
      });
    } catch (error) {
      setState(() {
        _statusMessage = error.toString();
      });
    }
  }

  void _sendResponse() {
    Map<String, String> fieldValues = {"name": "Nobody"};
    getIt<Agent>().sendFormValueResponse(BEResponse(fieldValues));
    setState(() {
      _statusMessage = 'response sent';
    });
  }

  @override
  void initState() {
    super.initState();
    getIt<Agent>().generateInstanceCodeIfNone().then((str) => setState(() {
          _appCode = str;
        }));
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
            title:
                Text(_statusMessage, key: WidgetKeys.webSocketStatusTextField),
          ),
          ListTile(
              title: ElevatedButton(
                  key: WidgetKeys.receiveRequestButton,
                  onPressed: () => _simulateRequest(),
                  child: const Text('Simulate Request'))),
          ListTile(
              title: ElevatedButton(
                  key: WidgetKeys.sendResponseButton,
                  onPressed: () => _sendResponse(),
                  child: const Text('Send Response'))),
        ]));
  }
}
