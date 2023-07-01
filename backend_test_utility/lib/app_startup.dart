import 'package:get_it/get_it.dart';
import 'package:backend_services/src/agent.dart';

import 'ambients.dart';

class AppStartup {
  static void startup() {
    getIt.registerSingleton<Agent>(Agent('backend-test-utility'));
  }

  static void reset() {
    getIt.reset(dispose: true);
    getIt = GetIt.asNewInstance();
    startup();
  }
}
