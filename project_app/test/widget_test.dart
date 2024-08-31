import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_app/main.dart'; // Replace with the correct import path

void main() {
  testWidgets('HospitalPage displays options and allows selection', (WidgetTester tester) async {
    // Build the HospitalPage widget
    await tester.pumpWidget(MaterialApp(home:  HousingPage()));

    // Verify that the Location and Specialization categories are displayed
    expect(find.text('Location'), findsOneWidget);
    expect(find.text('Specialization'), findsOneWidget);

    // Tap on the 'Location' category
    await tester.tap(find.text('Location'));
    await tester.pump();

    // Verify that the Location options are displayed
    expect(find.text('Tambaram'), findsOneWidget);
    expect(find.text('T.NAGAR'), findsOneWidget);
    expect(find.text('Velachery'), findsOneWidget);

    // Tap on the 'Downtown' option
    await tester.tap(find.text('Tambaram'));
    await tester.pump();

    // Verify that 'Downtown' is selected
    expect(find.byType(Radio<String>), findsOneWidget);
    expect(find.text('Tambaram'), findsOneWidget);

    // Tap on the 'Specialization' category
    await tester.tap(find.text('Specialization'));
    await tester.pump();

    // Verify that the Specialization options are displayed
    expect(find.text('Cardiology'), findsOneWidget);
    expect(find.text('Neurology'), findsOneWidget);
    expect(find.text('Orthopedics'), findsOneWidget);
    expect(find.text('Pediatrics'), findsOneWidget);

    // Tap on the 'Cardiology' option
    await tester.tap(find.text('Cardiology'));
    await tester.pump();

    // Verify that 'Cardiology' is selected
    expect(find.byType(Radio<String>), findsNWidgets(2)); // Ensure both categories have radios
    expect(find.text('Cardiology'), findsOneWidget);

    // Tap the 'Enter' button
    await tester.tap(find.text('Enter'));
    await tester.pump();

    // Verify that the confirmation dialog is shown
    expect(find.text('Confirmation'), findsOneWidget);
    expect(find.text('Location: Tambaram'), findsOneWidget);
    expect(find.text('Specialization: Cardiology'), findsOneWidget);
  });
}
