import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import intl package

class ViewEventPage extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const ViewEventPage({Key? key, required this.eventData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCreatedByUser =
        FirebaseAuth.instance.currentUser?.uid == eventData['createdBy'];

    var themeData = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeData.appBarTheme.backgroundColor,
        iconTheme: themeData.appBarTheme.iconTheme,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventHeader(eventData: eventData),
            CreatedBy(eventData: eventData),
            SizedBox(height: 10),
            EventDetails(eventData: eventData),
            if (!isCreatedByUser)
              InterestedToggleButton(eventId: eventData['eventUID']),
            if (isCreatedByUser)
              AnnouncementsSection(eventId: eventData['eventUID']),
            Divider(),
            SizedBox(height: 10),
            Text('Announcements',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            AnnouncementsViewer(eventId: eventData['eventUID']),
          ],
        ),
      ),
    );
  }
}

class EventHeader extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const EventHeader({Key? key, required this.eventData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Text(
        eventData['eventName'] ?? 'Unnamed Event',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.orange[800],
        ),
      ),
    );
  }
}

class EventDetails extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const EventDetails({Key? key, required this.eventData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Venue: ${eventData['location'] ?? 'TBD'}',
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 12),
        Text('Date and Time: ${eventData['date']} at ${eventData['time']}',
            style: TextStyle(fontSize: 18)),
        SizedBox(height: 20),
        Text(
          "Description",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(eventData['description'] ?? 'No description provided.',
            style: TextStyle(fontSize: 18), textAlign: TextAlign.justify),
        SizedBox(height: 20),
      ],
    );
  }
}

class CreatedBy extends StatelessWidget {
  const CreatedBy({
    super.key,
    required this.eventData,
  });

  final Map<String, dynamic> eventData;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
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
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500));
      },
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
        backgroundColor:
            isInterested ? Colors.orange[500] : Colors.orange[800],
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(8.0), // Set border radius to 2 pixels
        ),
        minimumSize: Size(double.infinity,
            38), // Set width to double.infinity and height to 48
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

        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.4,
          ),
          child: ListView(
            shrinkWrap: true,
            children: snapshot.data!.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              var formattedTimestamp = '';
              if (data['timestamp'] != null) {
                DateTime timestamp = data['timestamp'].toDate();
                formattedTimestamp =
                    DateFormat('HH:mm, MMM d, yyyy').format(timestamp);
              }
              return ListTile(
                title: Text(data['text']),
                subtitle: Text(formattedTimestamp),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
