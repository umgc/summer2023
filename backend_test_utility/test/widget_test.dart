import 'package:flutter_test/flutter_test.dart';
import 'package:backend_test_utility/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('test_utility widget smoke test with environment variable',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.text(MyApp.mainTitle), findsOneWidget);
  });
}
