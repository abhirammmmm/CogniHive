import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewEventPage extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const ViewEventPage({Key? key, required this.eventData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCreatedByUser =
        FirebaseAuth.instance.currentUser?.uid == eventData['createdBy'];

    return Scaffold(
      appBar: AppBar(
        title: const Text(''), // Empty text to remove the app bar text
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF1E2832)), // Menu icon color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eventData['eventName'] ?? 'Unnamed Event',
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[800]),
            ),
            SizedBox(height: 20),
            FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(eventData['createdBy'])
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                if (snapshot.hasError) {
                  return Text('Created by: Error loading user data',
                      style: TextStyle(fontSize: 16, color: Colors.red));
                }
                if (!snapshot.hasData || snapshot.data!.data() == null) {
                  return Text('Created by: User not found',
                      style: TextStyle(fontSize: 16, color: Colors.grey));
                }
                var userData = snapshot.data!.data() as Map<String, dynamic>;
                return Text('Created by: ${userData['displayName'] ?? 'N/A'}',
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.w500));
              },
            ),
            // Text(eventData['eventUID'] ?? "Null"),
            SizedBox(height: 12),
            // Event Venue and Time
            Text('Venue: ${eventData['location'] ?? 'TBD'}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 12),
            Text('Date and Time: ${eventData['date']} at ${eventData['time']}',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            // Event Description
            Text(eventData['description'] ?? 'No description provided.',
                style: TextStyle(fontSize: 18), textAlign: TextAlign.justify),
            SizedBox(height: 20),
            if (!isCreatedByUser)
              InterestedToggleButton(eventId: eventData['eventUID']),
            if (isCreatedByUser)
              AnnouncementsSection(eventId: eventData['eventUID']),
            AnnouncementsViewer(eventId: eventData['eventUID']),
          ],
        ),
      ),
    );
  }
}

class InterestedToggleButton extends StatefulWidget {
  final String? eventId;

  const InterestedToggleButton({Key? key, required this.eventId})
      : super(key: key);

  @override
  _InterestedToggleButtonState createState() => _InterestedToggleButtonState();
}

class _InterestedToggleButtonState extends State<InterestedToggleButton> {
  bool isInterested = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          isInterested = !isInterested;
          // Handle updating Firestore with the user's interest
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: isInterested ? const Color(0xFF1E2832) : const Color(0xFF1E2832),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Set border radius to 2 pixels
        ),
        minimumSize: Size(double.infinity, 38), // Set width to double.infinity and height to 48
      ),
      child: Text(
        isInterested ? 'Not Interested' : 'Interested',
        style: const TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }

}

class AnnouncementsSection extends StatefulWidget {
  final String? eventId;

  const AnnouncementsSection({Key? key, required this.eventId})
      : super(key: key);

  @override
  _AnnouncementsSectionState createState() => _AnnouncementsSectionState();
}

class _AnnouncementsSectionState extends State<AnnouncementsSection> {
  final TextEditingController _announcementController = TextEditingController();

  void _postAnnouncement() async {
    String announcementText = _announcementController.text.trim();

    if (announcementText.isEmpty) {
      // Optionally show a message to the user that the announcement text cannot be empty
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .collection('announcements')
          .add({
        'text': announcementText,
        'timestamp': FieldValue.serverTimestamp(), // Stores the current time
      });

      // Clear the text field after successfully posting the announcement
      _announcementController.clear();
      print('Announcement successfully posted.');
    } catch (error) {
      print('Error posting announcement: $error');
      // Optionally handle errors, such as showing an error message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _announcementController,
          decoration: InputDecoration(
            hintText: 'Write an announcement...',
            suffixIcon: IconButton(
              icon: Icon(Icons.send),
              onPressed: _postAnnouncement,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text('Announcements',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
      ],
    );
  }
}

class AnnouncementsViewer extends StatelessWidget {
  final String? eventId;

  const AnnouncementsViewer({Key? key, required this.eventId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .collection('announcements')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No announcements yet.');
        }

        return ListView(
          children: snapshot.data!.docs.map((doc) {
            var data = doc.data() as Map<String, dynamic>;
            return ListTile(
              title: Text(data['text']),
              subtitle: Text(data['timestamp'].toDate().toString()),
            );
          }).toList(),
        );
      },
    );
  }
}