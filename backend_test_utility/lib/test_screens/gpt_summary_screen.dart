import 'package:backend_services/backend_services_exports.dart';
import 'package:backend_test_utility/ambients.dart';
import 'package:flutter/material.dart';

class GptSummaryScreen extends StatefulWidget {
  const GptSummaryScreen({super.key, required this.title});

  final String title;

  @override
  State<GptSummaryScreen> createState() => _GptSummaryScreenState();
}

class _GptSummaryScreenState extends State<GptSummaryScreen> {
  String _statusMessage = '';

  void _requestSummaryPrompt() async {
    try {
      var summary = await getIt<Agent>()
          .getOpenAiSummary('c74dcec0-6fb7-45a9-98da-472e13413dd8');
      if (!mounted) return;
      setState(() {
        _statusMessage = summary ?? 'null';
      });
    } catch (error) {
      setState(() {
        _statusMessage = error.toString();
      });
    }
  }

  @override
  void initState() {
    try {
      final apiKey = EnvironmentVars.openAIApiKey;
      const maxDisplayLength = 7;
      _statusMessage =
          "OpenAI Key: ${apiKey.length > maxDisplayLength ? '${apiKey.substring(0, maxDisplayLength)}...' : apiKey}";
    } catch (error) {
      _statusMessage = error.toString();
    }
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
            title:
                Text(_statusMessage, key: WidgetKeys.gptSummaryStatusTextField),
          ),
          ListTile(
              title: ElevatedButton(
                  key: WidgetKeys.requestSummaryButton,
                  onPressed: () => _requestSummaryPrompt(),
                  child: const Text('Request Summary'))),
        ]));
  }
}
