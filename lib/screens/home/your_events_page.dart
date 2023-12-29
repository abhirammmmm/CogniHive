import 'package:flutter/material.dart';

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
        title: Text(''), // Empty text to remove the app bar text
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF1E2832)), // Menu icon color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'My Events',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 25),
            // Event details
            for (Event event in events)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Event By: ${event.organizer}'),
                    Text('Venue: ${event.venue}'),
                    Text('Date & Time: ${event.date}  ${event.time}'),
                    SizedBox(height: 8),
                    Text(event.description),
                  ],
                ),
              ),
            Divider(),
            // Announcements
            Text(
              'Announcements',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
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
                    decoration: InputDecoration(
                      hintText: 'Type your announcement here...',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    sendAnnouncement();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE46821),
                  ),
                  child: Text('Send'),
                ),
              ],
            ),
            Divider(),
            // People interested
            Text(
              'People Interested',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // You may need to manage interested people state and update UI accordingly
            Text(
              'Sai Dharam Pillay, Olivia Lopez, Erick Johansson, Astrid Lindström, and 8 others are interested.',
            ),
          ],
        ),
      ),
      endDrawer: buildDrawer(context), // Drawer on the right side
    );
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFFD9D9D9),
        child: Column(
          children: [
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the drawer
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.transparent, // Transparent to create space
                  ),
                  onPressed: () {}, // Dummy onPressed
                ),
              ],
            ),
            SizedBox(height: 100),
            buildDrawerItem(context, 'Profile', '/profilePage'),
            SizedBox(height: 50),
            buildDrawerItem(context, 'Your Events', '/yourEventsPage'),
            SizedBox(height: 380),
            buildDrawerItem(context, 'Logout', '/logoutPage'),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem(BuildContext context, String title, String route) {
    return SizedBox(
      height: 40,
      width: 180, // Set a fixed height for all buttons
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        style: ElevatedButton.styleFrom(
          primary: title == 'Logout' ? Colors.red : Color(0xFF1E2832),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
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
        SnackBar(
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
        SnackBar(
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
