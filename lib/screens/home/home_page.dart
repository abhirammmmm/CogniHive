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

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _eventsQuery = FirebaseFirestore.instance.collection('events');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateSearchQuery(String query) {
    setState(() {
      _eventsQuery = FirebaseFirestore.instance
          .collection('events')
          .where('eventName', isGreaterThanOrEqualTo: query)
          .where('eventName', isLessThan: query + 'z'); // Assuming eventName is the field you want to search
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.black87,
        title: Row(
          children: [
            Text(
              'Welcome 👋, Linda',
              style: TextStyle(color: Colors.white, fontSize: 24),
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
      endDrawer: CustomDrawer(),
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
                color: Colors.black87,
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
                    var eventData = events[index].data() as Map<String, dynamic>;
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
