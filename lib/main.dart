// ignore_for_file: prefer_const_constructors

import 'package:cognihive_version1/firebase_options.dart';
import 'package:cognihive_version1/screens/Login/login_ui.dart';
import 'package:cognihive_version1/screens/home/create_event_page.dart';
import 'package:cognihive_version1/screens/home/home_page.dart';
import 'package:cognihive_version1/screens/home/new_user_details.dart';
import 'package:cognihive_version1/screens/home/profile_ui.dart';
import 'package:cognihive_version1/screens/home/your_events_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'screens/home/search_page.dart';
import 'screens/home/view_event_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/homepage',
    routes: {
      '/': (context) => LoginUi(),
      '/new_profile': (context) => NewUserDetails(),
      '/homepage': (context) => HomePage(),
      '/createEvent': (context) => CreateEventPage(),
      '/viewEvent': (context) => ViewEventPage(),
      '/searchPage': (context) => SearchEnginePage(),
      '/profilePage': (context) => ProfileUI(),
      '/logoutPage': (context) => LoginUi(),
      '/yourEventsPage': (context) => YourEventsPage(),
    },
  ));
}
