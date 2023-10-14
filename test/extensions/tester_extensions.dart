import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Wraps the [widget] with a Material App required for testing.
/// This should only be used for widgets other than MyApp().
extension PumpWidget on WidgetTester {
  Future<void> pumpWidgetWithApp(Widget widget) {
    return pumpWidget(
      ProviderScope(
        child: MaterialApp(home: widget),
      ),
    );
  }
}
