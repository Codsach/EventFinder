// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:event_finder/main.dart';

void main() {
  testWidgets('Event Finder smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EventFinderApp());

    // Verify that our app starts at Explore page.
    expect(find.text('Explore'), findsAtLeastNWidgets(1));
    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Create'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
