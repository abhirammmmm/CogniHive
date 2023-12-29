// ignore_for_file: use_build_context_synchronously, no_leading_underscores_for_local_identifiers, avoid_print, file_names, prefer_const_constructors


// import 'package:cognihive_version1/screens/home/homepage_ui.dart';
import 'package:cognihive_version1/screens/home/home_page.dart';
import 'package:cognihive_version1/screens/home/new_user_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void firebaseGoogleSigninProvider(BuildContext context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
    UserCredential _usercreds = await _auth.signInWithProvider(_googleAuthProvider);
    User? _user = _usercreds.user;

    if (_user != null) {
      // Check the user's profile completion status
      DocumentSnapshot userDetails = await FirebaseFirestore.instance.collection('users').doc(_user.uid).get();
      
      if (userDetails.exists) {
        // If profile is complete, navigate to Dashboard
        if (userDetails['profile_complete'] == true) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          // If profile is not complete, navigate to NewUserDetails
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewUserDetails()));
        }
      } else {
        // If user does not exist in Firestore, create a new document and navigate to NewUserDetails
        await _createNewFirestoreUser(_user);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewUserDetails()));
      }
    }
  } catch (error) {
    print(error);
  }
}

Future<void> _createNewFirestoreUser(User user) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  await users.doc(user.uid).set({
    'uid': user.uid,
    'displayName': user.displayName,
    'email': user.email,
    'photoURL': user.photoURL,
    'createdAt': FieldValue.serverTimestamp(),
    'profile_complete': false
  });
}


