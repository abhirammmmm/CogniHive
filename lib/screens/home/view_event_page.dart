// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ViewEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion on Mars Rover'),
      ),
      body: Center(
        child: Text(
          'Event created by - ,\nVenue - ,\nDate and Time - ,\nEngage in an illuminating discussion on the Mars Rover at our upcoming event...',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
