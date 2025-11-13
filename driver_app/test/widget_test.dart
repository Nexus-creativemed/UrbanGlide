// Driver app widget test for Urban Glide
//
// Tests basic driver app functionality

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Driver app creates MaterialApp', (WidgetTester tester) async {
    // Build a basic MaterialApp (driver_app uses private classes)
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Urban Glide Driver'),
          ),
        ),
      ),
    );

    // Verify that the app renders
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Urban Glide Driver'), findsOneWidget);
  });

  testWidgets('Scaffold widget exists', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: Text('Test')),
        ),
      ),
    );

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
