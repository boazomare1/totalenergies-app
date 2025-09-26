import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:totalenergies/screens/splash_screen.dart';

void main() {
  testWidgets('Splash screen shows TotalEnergies branding', (
    WidgetTester tester,
  ) async {
    // Build splash screen directly
    await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

    // Wait for initial frame
    await tester.pump();

    // Verify TotalEnergies text is displayed
    expect(find.text('TotalEnergies'), findsOneWidget);
    expect(find.text('Energy for Life'), findsOneWidget);
  });
}
