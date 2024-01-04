import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'package:add_2_calendar/add_2_calendar.dart';

class ViewEventPage extends StatefulWidget {
  final Map<String, dynamic> eventData;

  const ViewEventPage({Key? key, required this.eventData}) : super(key: key);

  @override
  _ViewEventPageState createState() => _ViewEventPageState();
}

class _ViewEventPageState extends State<ViewEventPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  void launchGoogleCalendar() {}

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isCreatedByUser =
        FirebaseAuth.instance.currentUser?.uid == widget.eventData['createdBy'];
    var themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.black87,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EventHeader(eventData: widget.eventData),
            CreatedBy(eventData: widget.eventData),
            SizedBox(height: 10),
            EventDetails(eventData: widget.eventData),
            if (isCreatedByUser)
              DeleteEventButton(eventId: widget.eventData['eventUID']),
            if (!isCreatedByUser)
              InterestedToggleButton(
                eventId: widget.eventData['eventUID'],
                eventData: widget.eventData,
                launchGoogleCalendar: launchGoogleCalendar,
              ),
            SizedBox(height: 20),
            TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : Colors.black,
              tabs: [
                Tab(
                  text: 'Interested People',
                  icon: Icon(Icons.people),
                ),
                Tab(
                  text: 'Announcements',
                  icon: Icon(Icons.announcement),
                ),
              ],
            ),
            Container(
              height: 400, // Adjust the height as needed
              child: TabBarView(
                controller: _tabController,
                children: [
                  InterestedPeopleTab(eventId: widget.eventData['eventUID']),
                  AnnouncementsTab(
                      eventId: widget.eventData['eventUID'],
                      isCreatedByUser: isCreatedByUser),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnnouncementsTab extends StatelessWidget {
  final String eventId;
  final bool isCreatedByUser;

  const AnnouncementsTab(
      {Key? key, required this.eventId, required this.isCreatedByUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        if (isCreatedByUser) AnnouncementsSection(eventId: eventId),
        Expanded(
          child: AnnouncementsViewer(eventId: eventId),
        ),
      ],
    );
  }
}

class InterestedPeopleTab extends StatelessWidget {
  final String eventId;

  const InterestedPeopleTab({Key? key, required this.eventId})
      : super(key: key);

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return userDoc.data() as Map<String, dynamic>?;
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .collection('peopleInterested')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Error fetching data"));
        }

        if (snapshot.data?.docs.isEmpty ?? true) {
          return Center(child: Text("No one is interested yet"));
        }

        List<DocumentSnapshot> interestedPeopleDocs = snapshot.data!.docs;

        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: ListView(
            children: interestedPeopleDocs.map((doc) {
              String userId = doc['uid'];
              return FutureBuilder<Map<String, dynamic>?>(
                future: getUserData(userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return ListTile(title: null);
                  }

                  if (userSnapshot.data == null) {
                    return ListTile(title: Text("User data not found"));
                  }

                  String userName =
                      userSnapshot.data?['displayName'] ?? 'No Name';
                  String userPhoto = userSnapshot.data?['photoURL'] ??
                      'https://via.placeholder.com/150';

                  return ListTile(
                    leading: userPhoto.isNotEmpty
                        ? CircleAvatar(backgroundImage: NetworkImage(userPhoto))
                        : null,
                    title: Text(userName),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class DeleteEventButton extends StatelessWidget {
  final String? eventId;

  const DeleteEventButton({Key? key, required this.eventId}) : super(key: key);

  void _confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _deleteEvent(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .delete();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              "Event Deleted Successfully!",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 10),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            elevation: 6.0,
            backgroundColor: Colors.green[400]),
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting event: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _confirmDeletion(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: Size(double.infinity, 38),
      ),
      child: Text(
        'Delete Event',
        style: const TextStyle(fontSize: 18, color: Colors.white),
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
  final Function launchGoogleCalendar;
  final Map<String, dynamic> eventData;

  InterestedToggleButton({
    Key? key,
    required this.eventId,
    required this.launchGoogleCalendar,
    required this.eventData,
  }) : super(key: key);

  @override
  _InterestedToggleButtonState createState() => _InterestedToggleButtonState();
}

class _InterestedToggleButtonState extends State<InterestedToggleButton> {
  bool isInterested = false;
  final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    checkIfUserIsInterested();
  }

  void checkIfUserIsInterested() async {
    if (currentUserId == null) return;

    DocumentSnapshot interestedDoc = await FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .collection('peopleInterested')
        .doc(currentUserId)
        .get();

    if (interestedDoc.exists) {
      setState(() {
        isInterested = true;
      });
    }
  }

  void toggleInterested() async {
    setState(() {
      isInterested = !isInterested;
    });

    if (currentUserId == null) return;

    CollectionReference interestedRef = FirebaseFirestore.instance
        .collection('events')
        .doc(widget.eventId)
        .collection('peopleInterested');

    if (isInterested) {
      await interestedRef.doc(currentUserId).set({'uid': currentUserId});

      launchGoogleCalendar();
    } else {
      await interestedRef.doc(currentUserId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              "You are no more interested for this event. Please note, deletion of events from Google Calendar is manual for now. We are working to automate this soon!",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 10),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            elevation: 6.0,
            backgroundColor: Colors.red[400]),
      );
    }
  }

  void launchGoogleCalendar() async {
    String eventName = widget.eventData['eventName'] ?? 'Your Event Name';
    String eventDescription =
        widget.eventData['description'] ?? 'Your Event Description';
    String eventDate = widget.eventData['date'] ?? '';
    String eventTime = widget.eventData['time'] ?? '';
    String eventLocation = widget.eventData['location'] ?? ''; // Add this line

    print('Event Date: $eventDate');
    print('Event Time: $eventTime');
    print('Event Location: $eventLocation');

    if (eventDate.isEmpty || eventTime.isEmpty) {
      print('Invalid date or time format.');
      return;
    }

    DateTime eventDateTime =
        DateFormat('d/M/yyyy h:mm a').parse('$eventDate $eventTime');

    String formattedDate = DateFormat('yyyyMMddTHHmmss').format(eventDateTime);

    String googleCalendarUrl =
        'https://www.google.com/calendar/render?action=TEMPLATE&text=$eventName&details=$eventDescription&location=$eventLocation&dates=$formattedDate/$formattedDate';

    try {
      await launchUrl(Uri.parse(googleCalendarUrl));
    } catch (e) {
      print('Could not launch Google Calendar: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: toggleInterested,
      style: ElevatedButton.styleFrom(
        backgroundColor: isInterested ? Colors.orange[500] : Colors.orange[800],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        minimumSize: Size(double.infinity, 38),
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
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('events')
          .doc(widget.eventId)
          .collection('announcements')
          .add({
        'text': announcementText,
        'timestamp': FieldValue.serverTimestamp(),
      });

      _announcementController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              "Announcement Posted Successfully!",
              style: TextStyle(color: Colors.white),
            ),
            duration: Duration(seconds: 10),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            margin: EdgeInsets.all(10.0),
            padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
            elevation: 6.0,
            backgroundColor: Colors.green[400]),
      );
      print('Announcement successfully posted.');
    } catch (error) {
      print('Error posting announcement: $error');
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
