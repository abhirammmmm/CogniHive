import 'package:flutter/material.dart';

import 'drawer_item.dart';

class YourEventsPage extends StatefulWidget {
  @override
  _YourEventsPageState createState() => _YourEventsPageState();
}

class _YourEventsPageState extends State<YourEventsPage> {
  List<String> announcements = [];
  String newAnnouncement = '';

  @override
  Widget build(BuildContext context) {
    List<Event> events = getEventData();

    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // Empty text to remove the app bar text
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : const Color(0xFF1E2832), // Menu icon color for light mode
        ),// Menu icon color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'My Events',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 25),
            // Event details
            for (Event event in events)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Event By: ${event.organizer}'),
                    Text('Venue: ${event.venue}'),
                    Text('Date & Time: ${event.date}  ${event.time}'),
                    const SizedBox(height: 8),
                    Text(event.description),
                  ],
                ),
              ),
            const Divider(),
            // Announcements
            const Text(
              'Announcements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // Display user's announcements
            for (String announcement in announcements)
              Text(
                announcement,
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            // Post Announcement
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    onChanged: (value) {
                      newAnnouncement = value;
                    },
                    decoration: const InputDecoration(
                      hintText: 'Type your announcement here...',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendAnnouncement();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE46821),
                  ),
                  child: const Text('Send', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const Divider(),
            // People interested
            const Text(
              'People Interested',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            // You may need to manage interested people state and update UI accordingly
            const Text(
              'Sai Dharam Pillay, Olivia Lopez, Erick Johansson, Astrid Lindström, and 8 others are interested.',
            ),
          ],
        ),
      ),
      endDrawer: CustomDrawer(onThemeChanged: (themeMode) {
      },), // Drawer on the right side
    );
  }



  List<Event> getEventData() {
    return [
      Event(
        name: 'Discussion on Artificial Intelligence',
        organizer: 'Krishna Sahay',
        venue: 'Discussion Hall No 102',
        date: '10-12-2023',
        time: '9:30 AM',
        description:
        'Get indulged in a discussion on Artificial Intelligence where your opinions and ideas would be greatly appreciated throughout this session. If you are someone who is looking to gain knowledge in AI, this is the right place.',
      ),
    ];
  }

  void sendAnnouncement() {
    if (newAnnouncement.isNotEmpty) {
      // Update the announcements list
      setState(() {
        announcements.add(newAnnouncement);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Announcement sent successfully!'),
          backgroundColor: Color(0xFF1E2832),
          duration: Duration(seconds: 3),
        ),
      );

      // Clear the text field after sending
      setState(() {
        newAnnouncement = '';
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter an announcement.'),
          backgroundColor: Color(0xFF1E2832),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}

class Event {
  final String name;
  final String organizer;
  final String venue;
  final String date;
  final String time;
  final String description;

  Event({
    required this.name,
    required this.organizer,
    required this.venue,
    required this.date,
    required this.time,
    required this.description,
  });
}
