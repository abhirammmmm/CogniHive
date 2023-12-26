// ignore_for_file: prefer_const_constructors

import 'package:cognihive_version1/firebase_options.dart';
import 'package:cognihive_version1/screens/Login/login_ui.dart';
import 'package:cognihive_version1/screens/home/dashboard.dart';
import 'package:cognihive_version1/screens/home/new_user_details.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // initialRoute: '/dashboard',
    routes: {
      '/' : (context) => LoginUi(),
      '/profile': (context) => NewUserDetails(),
      '/dashboard': (context) => Dashboard(),
    },
  ));
}




