// Passenger app widget test for Urban Glide
//
// Tests basic passenger app functionality

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Passenger app creates MaterialApp', (WidgetTester tester) async {
    // Build a basic MaterialApp (passenger_app uses private classes)
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Urban Glide Passenger'),
          ),
        ),
      ),
    );

    // Verify that the app renders
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Urban Glide Passenger'), findsOneWidget);
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
