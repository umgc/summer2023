import 'package:flutter_test/flutter_test.dart';
import 'package:backend_test_utility/main.dart';

void main() {
  testWidgets('test_utility smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
  });
}
