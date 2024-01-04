import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cognihive_version1/widgets/event_card.dart';
import 'package:firebase_core/firebase_core.dart';
void main() {

  setUpAll(() async {
    await Firebase.initializeApp();
  });
  testWidgets('EventCard UI Test', (WidgetTester tester) async {
    // Define a mock event data
    final Map<String, dynamic> mockEventData = {
      'eventName': 'Test Event',
      'createdBy': 'user123',
      'location': 'Test Venue',
      'date': '2023-12-01',
      'time': '18:00',
      'description': 'Test description',
    };

    // Build our widget and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: EventCard(eventData: mockEventData),
        ),
      ),
    );

    // Verify that the event name is displayed
    expect(find.text('Test Event'), findsOneWidget);

    // Verify that the "Created by" text is displayed
    expect(find.text('Created by: N/A'), findsOneWidget);

    // Trigger the FutureBuilder to complete the Future
    await tester.pump();

    // Verify that the "Created by" text is updated after FutureBuilder completes
    expect(find.text('Created by: N/A'), findsNothing);

    // Verify that the venue is displayed
    expect(find.text('Venue: Test Venue'), findsOneWidget);

    // Verify that the date and time are displayed
    expect(find.text('Date and Time: 2023-12-01 at 18:00'), findsOneWidget);

    // Verify that the description is displayed
    expect(find.text('Test description'), findsOneWidget);
  });
}
