import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomDrawer extends StatefulWidget {
  final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool isDarkThemeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/editProfilePage');
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Your Events'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/yourEventsPage');
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
          ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Light'),
                Switch(
                  value: isDarkThemeEnabled,
                  onChanged: (value) {
                    // Handle toggling between light and dark theme
                    setState(() {
                      isDarkThemeEnabled = value;
                      ThemeSwitcher.of(context).switchTheme();
                    });
                  },
                ),
                Text('Dark'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(widget.currentUserUid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.data != null) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return UserAccountsDrawerHeader(
            accountName: Text(userData['displayName'] ?? 'Your Name'),
            accountEmail: Text(FirebaseAuth.instance.currentUser?.email ?? 'youremail@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(userData['photoURL'] ?? 'https://via.placeholder.com/150'),
            ),
            decoration: BoxDecoration(
              color: Colors.orange[800],
            ),
          );
        }
        return CircularProgressIndicator();
      },
    );
  }
}

class ThemeSwitcher extends InheritedWidget {
  final Function switchTheme;
  final bool isDarkThemeEnabled;

  ThemeSwitcher({
    required Widget child,
    required this.switchTheme,
    required this.isDarkThemeEnabled,
  }) : super(child: child);

  static ThemeSwitcher of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeSwitcher>()!;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}
