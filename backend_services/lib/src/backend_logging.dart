import 'dart:io';
import 'package:backend_services/src/environment_vars.dart';
import 'package:logger/logger.dart';
import 'logging/websocket_log_output.dart';
import 'package:path/path.dart' as path;
import 'ambients.dart';

class BackendLogging {
  /// Initializes logging for the full platform, relies on file IO and .env variables.
  static void initializeForPlatform(
      String wsUrl, Duration wsTimeout, Directory appDirectory) {
    final logFile = File(path.join(appDirectory.path, 'application.log'));
    final fileLogger = FileOutput(file: logFile, overrideExisting: true);
    final logOutputs = [
      ConsoleOutput(),
      WebSocketLogOutput(wsUrl: wsUrl, wsConnectTimeout: wsTimeout),
      fileLogger
    ];

    if (backendGetit.isRegistered<Logger>()) {
      backendGetit.unregister<Logger>();
    }
    backendGetit.registerSingleton(Logger(
        output: MultiOutput(logOutputs),
        printer: defaultPrinter,
        level: EnvironmentVars.logLevel));
  }

  static LogPrinter get defaultPrinter =>
      SimplePrinter(printTime: true, colors: false);
}
