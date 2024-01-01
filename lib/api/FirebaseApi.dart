import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  messaging.getToken().then((token) {
    print("FCM Token: $token");
  });
  messaging.onTokenRefresh.listen((token) {
    print("FCM Token (Refreshed): $token");
  });
}
