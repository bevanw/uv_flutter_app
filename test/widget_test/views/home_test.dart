// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:uv_flutter_app/views/home_view.dart';

import '../../extensions/tester_extensions.dart';

void main() {
  testWidgets('default to UV Index view', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidgetWithApp(const HomeView());

    // Expectation
    expect(find.text('UV'), findsOneWidget);
  });
}
