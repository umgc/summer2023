import 'dart:io';

import 'package:backend_services/backend_services_exports.dart';
import 'package:backend_test_utility/test_selection_and_extraction_activator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path_provider/path_provider.dart';

import 'ambients.dart';

class AppStartup {
  static Future<void> startup() async {
    await dotenv.load();
    await _intializeGetIt();
  }

  static Future<void> _intializeGetIt() async {
    Directory directory = await getApplicationDocumentsDirectory();
    getIt.registerSingleton<Agent>(Agent('backend-test-utility', directory),
        dispose: (param) => param.shutdown());
    await getIt<Agent>().loadSampleConversations();
    getIt<Agent>().initialize(TestSelectionAndExtractionActivator(
        getIt<Agent>(), TestConversations.workHistoryGuid));
  }
}
