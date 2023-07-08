import 'package:backend_test_utility/test_recording_selection_activator.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';
import 'package:backend_services/agent.dart';
import 'ambients.dart';

class AppStartup {
  static Future<void> startup() async {
    getIt.registerSingleton<Agent>(Agent('backend-test-utility'), dispose: (param) => param.shutdown());
    await dotenv.load();
    getIt<Agent>().initialize(TestRecordingSelectionActivator(getIt<Agent>()));
  }

  static void reset() {
    getIt.reset(dispose: true);
    getIt = GetIt.asNewInstance();
    startup();
  }
}
