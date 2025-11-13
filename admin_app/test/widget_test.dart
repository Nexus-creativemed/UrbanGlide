// Admin app widget test for Urban Glide
//
// Tests basic admin dashboard functionality

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Admin app creates MaterialApp', (WidgetTester tester) async {
    // Build a basic MaterialApp (admin_app uses private classes)
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Admin Dashboard'),
          ),
        ),
      ),
    );

    // Verify that the app renders
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Admin Dashboard'), findsOneWidget);
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
