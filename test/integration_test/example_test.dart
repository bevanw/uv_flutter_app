import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// https://github.com/flutter/flutter/tree/master/packages/integration_test
  testWidgets("integration test example", (WidgetTester tester) async {
    expect(2 + 2, equals(4));
  });
}
