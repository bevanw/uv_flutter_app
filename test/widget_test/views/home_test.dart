// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:uv_flutter_app/views/home_view.dart';

// TODO: Get unit/integration tests working then test APIs.

void main() {
  testWidgets('default to UV Index view', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HomeView());

    // Expectation
    expect(find.text('Index 0: UV Index'), findsOneWidget);
  });

  testWidgets('select UV Graphs tab', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HomeView());

    // Select the ASB tab.
    // Tap the add button.
    await tester.tap(find.byKey(const Key("UV Graphs")));

    // Rebuild the widget after the state has changed.
    await tester.pump();

    // Expectation
    expect(find.text('Index 1: UV Graphs'), findsOneWidget);
  });
}