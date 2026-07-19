// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shorebirdpractice/main.dart';

void main() {
  testWidgets('App starts and shows no notes message', (
    WidgetTester tester,
  ) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app bar title is correct.
    expect(find.text('My Notes'), findsOneWidget);

    // Verify that the initial message for no notes is shown.
    expect(
      find.text("You have no notes. Tap '+' to create one!"),
      findsOneWidget,
    );

    // Verify that the FloatingActionButton is present.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // Wait for navigation to complete

    // Verify that we have navigated to the editor screen.
    expect(find.text('New Note'), findsOneWidget);
  });
}
