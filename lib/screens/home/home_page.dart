// ignore_for_file: prefer_const_constructors, prefer_final_fields, library_private_types_in_public_api, avoid_print, prefer_const_constructors_in_immutables, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'drawer_item.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, Linda'),
        centerTitle: true,
        backgroundColor: Colors.black87,
        titleTextStyle: TextStyle(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.search),
          color: Colors.white,
          onPressed: () => Navigator.pushNamed(context, '/searchPage'),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: Drawer(
        child: Container(
          color: Color(0xFFD9D9D9),
          child: Column(
            children: [
              SizedBox(height: 30),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.orange),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              SizedBox(height: 100),
              DrawerItem(title: 'Profile', route: '/profilePage'),
              SizedBox(height: 50),
              DrawerItem(title: 'Your Events', route: '/yourEventsPage'),
              Spacer(),
              DrawerItem(title: 'Logout', route: '/logoutPage', isLogout: true),
            ],
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView(
            padding: EdgeInsets.only(bottom: 80), // Space for the sticky button
            children: [
              Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'Events',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              ...List.generate(10, (index) => buildEventCard(context)), // Example list
            ],
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: buildAddEventButton(context),
          ),
        ],
      ),
    );
  }

  Widget buildEventCard(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, '/showInterest'),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discussion on Mars Rover',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Event created by - ,\nVenue - ,\nDate and Time - ,\nEngage in an illuminating discussion...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/viewEvent'),
                child: Text('View Description'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAddEventButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/createEvent'),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.orange[800],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 8),
            Text('Add an Event', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
