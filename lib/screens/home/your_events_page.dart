// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/event_card.dart'; // Ensure this path is correct

class UserEventsPage extends StatefulWidget {
  @override
  _UserEventsPageState createState() => _UserEventsPageState();
}

class _UserEventsPageState extends State<UserEventsPage> {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  late Query _userEventsQuery;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      _userEventsQuery = FirebaseFirestore.instance
          .collection('events')
          .where('createdBy', isEqualTo: currentUser!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Events'),
        backgroundColor: Colors.black87,
      ),
      body: currentUser == null
          ? Center(child: Text('You are not logged in'))
          : StreamBuilder<QuerySnapshot>(
              stream: _userEventsQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No events found'));
                }

                var events = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    var eventData =
                        events[index].data() as Map<String, dynamic>;
                    return EventCard(eventData: eventData);
                  },
                );
              },
            ),
    );
  }
}
