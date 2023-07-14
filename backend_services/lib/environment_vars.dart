import 'package:flutter_dotenv/flutter_dotenv.dart';

// This is not great... for String.fromEnvironment to work on all platforms, it
// needs to store to a const.  That means you can't pass a key in and make a general
// function. You have to add String.FromEnvironment() with string literal for every
// variable you want to get from --dart-define commandline flutter argument.
// See this (currently) open issue against flutter: https://github.com/flutter/flutter/issues/55870
//
// If you want a variable that is always pulled from the .env file, use:
//  return getFromEnv('VARIABLE_NAME');
// If you want a variable that can be overridden by the build via --dart-define
// flutter command argument, use the following sequence:
//  const name = 'VARIABLE_NAME';
//  const valueFromEnv = String.fromEnvironment(name);
//  if (valueFromEnv.isNotEmpty) return valueFromEnv;
//  return getFromEnv(name);
class EnvironmentVars {
  static String get openAIApiKey {
    const name = 'OPENAI_API_KEY';
    const valueFromEnv = String.fromEnvironment(name);
    if (valueFromEnv.isNotEmpty) return valueFromEnv;
    return _getFromEnv(name);
  }

  static String get testSecret {
    try {
      const name = 'TEST_SECRET';
      const valueFromEnv = String.fromEnvironment(name);
      if (valueFromEnv.isNotEmpty) return valueFromEnv;
      return _getFromEnv(name);
    } catch (error) {
      return error.toString();
    }
  }

  static String get wsUrl => _getFromEnv('WS_URL');

  static String get wsConnectionTimeoutMs =>
      _getFromEnv('WS_CONNECTION_TIMEOUT_MS');

  static String get formFillRequestTopic =>
      _getFromEnv('FORM_FILL_REQUEST_TOPIC');

  static String get formFillResponseTopic =>
      _getFromEnv('FORM_FILL_RESPONSE_TOPIC');

  static String _getFromEnv(String name) {
    final envValue = dotenv.env[name];
    if (envValue == null) throw "Missing environment variable '$name'.";
    if (envValue.isEmpty) throw "Environment variable '$name' is empty.";
    return envValue;
  }
}
