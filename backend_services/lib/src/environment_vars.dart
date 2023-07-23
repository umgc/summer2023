import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:logger/logger.dart';

// This is not great... for String.fromEnvironment to work on all platforms, it
// needs to store to a const.  That means you can't pass a key in and make a general
// function. You have to add String.FromEnvironment() with string literal for every
// variable you want to get from --dart-define commandline flutter argument.
// See this (currently) open issue against flutter: https://github.com/flutter/flutter/issues/55870
//
// If you want a variable that is always pulled from the .env file, use:
//   return getFromEnv('VARIABLE_NAME');
//
// If you want a variable that can be overridden by the build via --dart-define
// flutter command argument, use the following sequence:
//   const name = 'VARIABLE_NAME';
//   const valueFromEnv = String.fromEnvironment(name);
//   if (valueFromEnv.isNotEmpty) return valueFromEnv;
//   return getFromEnv(name);
class EnvironmentVars {
  static String get openAIApiKey {
    const name = 'OPENAI_API_KEY';
    const valueFromEnv = String.fromEnvironment(name);
    if (valueFromEnv.isNotEmpty) return valueFromEnv;
    return _getFromEnv(name);
  }

  static String get wsUrl => _getFromEnv('WS_URL');

  static String get wsConnectionTimeoutMs =>
      _getFromEnv('WS_CONNECTION_TIMEOUT_MS');

  static String get formFillRequestTopic =>
      _getFromEnv('FORM_FILL_REQUEST_TOPIC');

  static String get formFillResponseTopic =>
      _getFromEnv('FORM_FILL_RESPONSE_TOPIC');

  static String get transcriptResponseTopic =>
      _getFromEnv('TRANSCRIPT_RESPONSE_TOPIC');

  static Level get logLevel {
    return _getLogLevelFromEnv('LOG_LEVEL');
  }

  static Level get webSocketLogLevel {
    return _getLogLevelFromEnv('WEBSOCKET_LOG_LEVEL');
  }

  static Level _getLogLevelFromEnv(String name) {
    final level = _getFromEnv(name);
    switch (level) {
      case 'info':
        return Level.info;
      case 'debug':
        return Level.debug;
      case 'error':
        return Level.error;
      case 'nothing':
        return Level.nothing;
      case 'verbose':
        return Level.verbose;
      case 'wtf':
        return Level.wtf;
      case 'warning':
        return Level.warning;
      default:
        throw "Invalid log level '$level' for .env variable $name.";
    }
  }

  static String get besieLogTopic => _getFromEnv('BESIE_LOG_TOPIC');

  static String _getFromEnv(String name) {
    final envValue = dotenv.env[name];
    if (envValue == null) throw "Missing environment variable '$name'.";
    if (envValue.isEmpty) throw "Environment variable '$name' is empty.";
    return envValue;
  }
}
