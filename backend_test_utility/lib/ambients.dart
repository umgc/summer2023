import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

class WidgetKeys {
  // Main screen
  static const Key appInstanceCodeTestsButton =
      Key("app-instance-code-tests-button");

  // App Instance Code Tests
  static const Key appCodeTextField = Key("app-code-text-field");
  static const Key generateAppCodeButton = Key("generate-app-code-button");
  static const Key resetAgentButton = Key("reset-agent-button");
}
