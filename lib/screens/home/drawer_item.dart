import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognihive_version1/theme_notifier.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatefulWidget {
  final String currentUserUid = FirebaseAuth.instance.currentUser?.uid ?? '';
  final Function(ThemeMode) onThemeChanged;

  CustomDrawer({Key? key, required this.onThemeChanged}) : super(key: key);
  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  bool switchValue = false;
  bool isDarkThemeEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _createHeader(context),
          ListTile(
            title: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text('Theme',
                    style: TextStyle(
                        fontSize:
                            16)),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .setThemeMode(ThemeMode.light);
                      },
                      icon: Icon(Icons.wb_sunny),
                      tooltip: 'Light theme',
                    ),
                    IconButton(
                      onPressed: () {
                        Provider.of<ThemeNotifier>(context, listen: false)
                            .setThemeMode(ThemeMode.dark);
                      },
                      icon: Icon(Icons.nightlight_round),
                      tooltip: 'Dark theme',
                    ),
                  ],
                ),
              ],
            ),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Edit Profile'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/editProfilePage');
            },
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Interested Events'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/interestedEvents');
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
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  Widget _createHeader(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(widget.currentUserUid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          var userData = snapshot.data!.data() as Map<String, dynamic>;
          return UserAccountsDrawerHeader(
            accountName: Text(userData['displayName'] ?? 'Your Name'),
            accountEmail: Text(FirebaseAuth.instance.currentUser?.email ??
                'youremail@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(
                  userData['photoURL'] ?? 'https://via.placeholder.com/150'),
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
