import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cognihive_version1/screens/home/profile_ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void firebaseGoogleSigninProvider(BuildContext context) async {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  try {
    GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();

    UserCredential _usercreds =
        await _auth.signInWithProvider(_googleAuthProvider);
    User? _user = _usercreds.user;
    // ignore: unnecessary_null_comparison
    if (_user != null) {
      // Update user details in Firestore
      print("Firestore call");
      await _firebaseUserDetails(_user);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfileUI()));
    }
  } catch (error) {
    print(error);
  }
}

Future<void> _firebaseUserDetails(User user) async {
  // Reference to Firestore collection
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Check if user already exists in Firestore
  DocumentSnapshot userSnapshot = await users.doc(user.uid).get();

  if (userSnapshot.exists) {
    // User exists, so do nothing for now...
    await users.doc(user.uid).update({'profile_complete': false});
  } else {
    print("**Executing**");
    print("**Executing**");
    print("**Executing**");

    // User does not exist, create a new document with the user's details

    await users.doc(user.uid).set({
      'uid': user.uid,
      'displayName': user.displayName,
      'email': user.email,
      'photoURL': user.photoURL,
      // Optional: record creation time
      'createdAt': FieldValue.serverTimestamp(),
      // 'profile_complete': false
    });
  }
}
