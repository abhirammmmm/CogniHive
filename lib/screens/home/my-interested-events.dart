import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/event_card.dart'; // Make sure this path is correct

class InterestedEventsPage extends StatefulWidget {
  @override
  _InterestedEventsPageState createState() => _InterestedEventsPageState();
}

class _InterestedEventsPageState extends State<InterestedEventsPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late List<DocumentSnapshot> interestedEvents;

  @override
  void initState() {
    super.initState();
    interestedEvents = [];
    fetchInterestedEvents();
  }

  void fetchInterestedEvents() async {
    if (currentUser == null) return;

    QuerySnapshot eventsSnapshot =
        await FirebaseFirestore.instance.collection('events').get();

    for (var eventDoc in eventsSnapshot.docs) {
      var interested = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventDoc.id)
          .collection('peopleInterested')
          .doc(currentUser!.uid)
          .get();

      if (interested.exists) {
        interestedEvents.add(eventDoc);
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interested Events'),
        backgroundColor: Colors.black87,
      ),
      body: currentUser == null
          ? Center(child: Text('You are not logged in'))
          : interestedEvents.isEmpty
              ? Center(child: Text('No interested events found'))
              : ListView.builder(
                  itemCount: interestedEvents.length,
                  itemBuilder: (context, index) {
                    var eventData =
                        interestedEvents[index].data() as Map<String, dynamic>;
                    return EventCard(eventData: eventData);
                  },
                ),
    );
  }
}
