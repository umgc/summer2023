import 'package:backend_services/backend_services_exports.dart';
import 'package:backend_test_utility/test_selection_and_extraction_activator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'ambients.dart';

class AppStartup {
  static Future<void> startup() async {
    await dotenv.load();
    _intializeGetIt();
  }

  static void _intializeGetIt() {
    getIt.registerSingleton<Agent>(
        Agent('backend-test-utility',
            conversations: TestConversations.sampleConversations),
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
