// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:test_recorder/main.dart';

void main() {
  testWidgets('smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that record_voice_over button is visible, voice_over_off is not
    expect(find.byIcon(Icons.record_voice_over), findsOneWidget);
    expect(find.byIcon(Icons.voice_over_off), findsNothing);

    // Verify that play_arrow button is visible, voice_over_off is not
    expect(find.byIcon(Icons.play_arrow), findsOneWidget);
    expect(find.byIcon(Icons.stop), findsNothing);
  });
}
