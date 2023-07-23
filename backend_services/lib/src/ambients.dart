import 'package:backend_services/src/backend_logging.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

GetIt backendGetit = GetIt.instance;

Logger get log {
  if (backendGetit.isRegistered<Logger>()) {
    return backendGetit<Logger>();
  }
  return Logger(level: Level.info, printer: BackendLogging.defaultPrinter);
}
