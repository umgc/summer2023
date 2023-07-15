import 'dart:io';

import 'package:backend_services/agent.dart';
import 'package:backend_services/backend_services_exports.dart';
import 'package:backend_test_utility/test_selection_and_extraction_activator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

import 'ambients.dart';

class AppStartup {
  static Future<void> startup() async {
    await dotenv.load();
    _intializeGetIt();
  }

  static Future<void> _intializeGetIt() async {
    Directory directory = await getApplicationDocumentsDirectory();
    // TODO: populate Agent with test conversations
    getIt.registerSingleton<Agent>(Agent('backend-test-utility', directory),
        dispose: (param) => param.shutdown());
    getIt<Agent>().initialize(TestSelectionAndExtractionActivator(
        getIt<Agent>(), '173d6dc0-fb47-4284-bd09-9465177f8eea'));
  }

  static void reset() {
    getIt.reset(dispose: true);
    getIt = GetIt.asNewInstance();
    _intializeGetIt();
  }
}
