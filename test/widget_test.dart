// MengSpark Widget Test

import 'package:flutter_test/flutter_test.dart';
import 'package:mengspark_simulator/main.dart';

void main() {
  testWidgets('MengSpark app launches', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MengSparkApp());

    // Verify that the home screen is displayed
    expect(find.text('MengSpark'), findsOneWidget);
  });
}
