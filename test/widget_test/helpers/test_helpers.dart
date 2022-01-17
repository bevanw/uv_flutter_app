import 'package:flutter/material.dart';

/// Wraps the [widget] with a Material App required for testing.
/// This should only be used for widgets other than MyApp().
Widget createTestWidget(Widget widget){
  return MaterialApp(
    home: widget,
  );
}
