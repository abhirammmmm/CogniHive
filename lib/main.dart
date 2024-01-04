// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognihive_version1/firebase_options.dart';
import 'package:cognihive_version1/screens/Login/login_ui.dart';
import 'package:cognihive_version1/screens/home/create_event_page.dart';
import 'package:cognihive_version1/screens/home/home_page.dart';
import 'package:cognihive_version1/screens/home/my-interested-events.dart';
import 'package:cognihive_version1/screens/home/new_user_details.dart';
import 'package:cognihive_version1/screens/home/profile_ui.dart';
import 'package:cognihive_version1/screens/home/search_page.dart';
import 'package:cognihive_version1/screens/home/view_event_page.dart';
import 'package:cognihive_version1/screens/home/your_events_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cognihive_version1/theme_notifier.dart';

import 'api/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationService().initialize();
  final themeNotifier = ThemeNotifier();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeNotifier,
      child: const RunMyApp(),
    ),
  );
}

class RunMyApp extends StatelessWidget {
  const RunMyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.themeMode,
      home: LandingPage(),
      routes: {
        '/new_profile': (context) =>  NewUserDetails(),
        '/homepage': (context) =>  HomePage(),
        '/createEvent': (context) =>  CreateEventPage(),
        '/viewEvent': (context) =>  ViewEventPage(eventData: {}),
        '/searchPage': (context) =>  SearchEnginePage(),
        '/editProfilePage': (context) =>  ProfileUI(),
        '/logoutPage': (context) =>  LoginUi(),
        '/yourEventsPage': (context) =>  UserEventsPage(),
        '/interestedEvents': (context) =>  InterestedEventsPage(),
      },
    );
  }
}



//This class represents the landing page of the application, If the User instance is present then - HomePage, else LoginUI
class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(); 
        }

        final User? user = snapshot.data;
        if (user == null) {
          return const LoginUi();
        } else {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (!snapshot.hasData || snapshot.data == null) {
                return Container();
              }

              return snapshot.data!.exists &&
                      snapshot.data!.get('profile_complete') == true
                  ? HomePage()
                  : NewUserDetails();
            },
          );
        }
      },
    );
  }
}
