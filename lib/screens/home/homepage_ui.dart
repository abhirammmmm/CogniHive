import 'package:cognihive_version1/screens/Login/login_ui.dart';
import 'package:cognihive_version1/screens/home/profile_ui.dart';
import 'package:cognihive_version1/screens/home/create_event_page.dart';
import 'package:flutter/material.dart';

class Homepage_Ui extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CogniHive',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: HomePage(),
      routes: {
        '/createEvent': (context) => CreateEventPage(),
        '/viewEvent': (context) => ViewEventPage(),
        '/searchPage': (context) => SearchEnginePage(),
        '/profilePage': (context) => ProfileUI(),
        '/logoutPage': (context) => LoginUi(),
      },
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, Linda'),
        centerTitle: true,
        backgroundColor: Colors.black87,
        titleTextStyle: TextStyle(color: Colors.white),
        actions: [
        ],
        flexibleSpace: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pushNamed(context, '/searchPage');
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                'Events',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: Container(
          color: Color(0xFFD9D9D9),
          child: Column(
            children: [
              SizedBox(height: 30,),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(
                    Icons.close,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the drawer
                  },
                ),
              ),
              SizedBox(height: 100),
              buildDrawerItem(context, 'Profile', '/profilePage'),
              SizedBox(height: 50),
              buildDrawerItem(context, 'My Events', '/myEventsPage'),
              SizedBox(height: 380),
              buildDrawerItem(context, 'Logout', '/logoutPage'),
            ],
          ),
        ),
      ),



      body: Stack(
        children: <Widget>[
          // Your other content here
          Positioned(
            bottom: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/createEvent');
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange[800],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Add an Event',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/showInterest');
              },
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Event created by - ,\nVenue - ,\nDate and Time - ,\nEngage in an illuminating discussion on the Mars Rover at our upcoming event.....',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/');
                          },
                          child: Column(
                            children: [
                              SizedBox(width: 8),
                              Text('Show Interest'),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/viewEvent');
                          },
                          child: Column(children: [
                            SizedBox(width: 8),
                            Text('View Description'),
                          ]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItem(BuildContext context, String title, String route) {
    return SizedBox(
      height: 40,
      width: 180,// Set a fixed height for all buttons
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



}

class ViewEventPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Discussion on Mars Rover'),
      ),
      body: Center(
        child: Text(
          'Event created by - ,\nVenue - ,\nDate and Time - ,\nEngage in an illuminating discussion on the Mars Rover at our upcoming event. Explore the latest breakthroughs and share your insights.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class SearchEnginePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Center(
        child: Text(
          'Search bar is in progress.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
