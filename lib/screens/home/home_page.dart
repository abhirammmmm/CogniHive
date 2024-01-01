import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'drawer_item.dart';
import '../../widgets/event_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TextEditingController _searchController;
  late Query _eventsQuery;
  Map<String, dynamic>? userData;
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _eventsQuery = FirebaseFirestore.instance.collection('events');
    fetchUserData();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData() async {
    if (currentUser != null) {
      try {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser!.uid)
            .get();
        print(userDoc);
        setState(() {
          userData = userDoc.data() as Map<String, dynamic>?;
        });
      } catch (e) {
        print('Error fetching user data: $e');
      }
    }
  }

  void _updateSearchQuery(String query) {
  String lowerCaseQuery = query.toLowerCase();
  setState(() {
    _eventsQuery = FirebaseFirestore.instance
        .collection('events')
        .where('eventNameLower', isGreaterThanOrEqualTo: lowerCaseQuery)
        .where('eventNameLower', isLessThan: lowerCaseQuery + '\uf8ff');
  });
}

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black87,
        title: Row(
          children: [
            Text(
              'Welcome 👋, ${userData?['displayName'] ?? 'Welcome 👋'}',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.menu),
              color: Colors.white,
              onPressed: () => Scaffold.of(context).openEndDrawer(),
            ),
          ),
        ],
      ),
      endDrawer: CustomDrawer(
        onThemeChanged: (themeMode) {
          // Handle theme change if needed
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: buildSearchBar(),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Text(
              "Events",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _eventsQuery.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No events found'));
                }

                var events = snapshot.data!.docs;
                return ListView.builder(
                  padding: EdgeInsets.only(bottom: 80, top: 8),
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    var eventData =
                        events[index].data() as Map<String, dynamic>;
                    return EventCard(eventData: eventData);
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: buildAddEventButton(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          children: [
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 8.0),
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: _updateSearchQuery,
                decoration: InputDecoration(
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
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
