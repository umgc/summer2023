import 'package:backend_test_utility/ambients.dart';
import 'package:backend_test_utility/main.dart' as app;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  // Initialize service bindings for widget integration testing
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('app instance screen test', (WidgetTester tester) async {
    await app.main();

    // Build our app and trigger a frame.
    await tester.pumpAndSettle();

    expect(find.text('Test Utility Main Screen'), findsOneWidget);

    final foundButton = find.byKey(WidgetKeys.appInstanceCodeTestsButton);
    expect(foundButton, findsOneWidget);

    await tester.tap(foundButton);

    await tester.pumpAndSettle();

    expect(find.text('App Instance Tests'), findsOneWidget);

    // TODO: Set up internationalization and text keys to avoid hard coding text in code and tests
    expect(tester.widget<Text>(find.byKey(WidgetKeys.appCodeTextField)).data,
        contains('Instance code has not been initialized'));

    final generateAppCodeButton = find.byKey(WidgetKeys.generateAppCodeButton);
    await tester.tap(generateAppCodeButton);

    await tester.pumpAndSettle();

    final appCodeTextField = find
        .byKey(WidgetKeys.appCodeTextField)
        .evaluate()
        .single
        .widget as Text;

    // expect 4 digit number
    final regExp = RegExp(r'^\d{4}$');
    expect(regExp.hasMatch(appCodeTextField.data ?? ''), true);
  });
}
