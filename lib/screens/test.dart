import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TestUI extends StatefulWidget {
  const TestUI({super.key});

  @override
  State<TestUI> createState() => _TestUIState();
}

class _TestUIState extends State<TestUI> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Signin"),
      ),
      body:_userInfo(),
    );
  }

  Widget _userInfo() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(image: NetworkImage(_user!.photoURL!))),
          ),
          Text(_user!.email!),
          Text(_user!.displayName ?? ""),
          MaterialButton(
            onPressed: _auth.signOut,
            color: Colors.red,
            child: const Text("Sign Out"),
          )
        ],
      ),
    );
  }

  void _handleGoogleSignIn() async {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _googleAuthProvider.addScope("profile");
      _googleAuthProvider.addScope("email");
      UserCredential _usercreds =
          await _auth.signInWithProvider(_googleAuthProvider);

      if (_user != null) {
        // Update user details in Firestore
        await _firebaseUserDetails(_user!);
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
}
