import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cognihive_version1/widgets/event_card.dart';
import 'package:firebase_core/firebase_core.dart';
void main() {

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('EventCard UI Test', (WidgetTester tester) async {

    final Map<String, dynamic> mockEventData = {
      'eventName': 'Test Event',
      'createdBy': 'user123',
      'location': 'Test Venue',
      'date': '2023-12-01',
      'time': '18:00',
      'description': 'Test description',
    };

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventCard(eventData: mockEventData),
        ),
      ),
    );

    expect(find.text('Test Event'), findsOneWidget);

    expect(find.text('Created by: N/A'), findsOneWidget);

    await tester.pump();

    expect(find.text('Created by: N/A'), findsNothing);

    expect(find.text('Venue: Test Venue'), findsOneWidget);

    expect(find.text('Date and Time: 2023-12-01 at 18:00'), findsOneWidget);

    expect(find.text('Test description'), findsOneWidget);
  });
}
