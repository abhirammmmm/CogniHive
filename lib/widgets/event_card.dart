// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognihive_version1/screens/home/view_event_page.dart';
import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final Map<String, dynamic> eventData;

  const EventCard({Key? key, required this.eventData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewEventPage(eventData: eventData),
            ),
          );
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 5,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  eventData['eventName'] ?? 'Unnamed Event',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[800],
                  ),
                ),
                SizedBox(height: 8),
                FutureBuilder<DocumentSnapshot>(
                  future: FirebaseFirestore.instance
                      .collection('users')
                      .doc(eventData['createdBy'])
                      .get(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData && snapshot.data != null) {
                        var userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Text(
                          'Created by: ${userData['displayName'] ?? 'N/A'}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        );
                      } else {
                        return Text(
                          'Created by: N/A',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54,
                          ),
                        );
                      }
                    }
                    return CircularProgressIndicator();
                  },
                ),
                SizedBox(height: 4),
                Text(
                  'Venue: ${eventData['location'] ?? 'TBD'}',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(height: 4),
                Text(
                  'Date and Time: ${eventData['date']} at ${eventData['time']}',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                SizedBox(height: 8),
                Text(
                  eventData['description'] ?? 'No description provided.',
                  style: TextStyle(fontSize: 16),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
