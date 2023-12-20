import 'package:cognihive_version1/widgets/googleSignInButtonWidget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

import 'package:flutter/material.dart';
// Import additional necessary packages for GoogleSignInButtonWidget if required.

import 'package:flutter/material.dart';
// Import additional necessary packages for GoogleSignInButtonWidget if required.

class LoginUi extends StatelessWidget {
  const LoginUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Login/Register',
                    style: TextStyle(fontSize: 30),
                  ),
                  SizedBox(height: 40), // Space between text and button
                  GoogleSignInButtonWidget(
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icon.jpeg',
                    width: 60,
                    height: 60,
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'CogniHive',
                    style: TextStyle(fontSize: 24, fontFamily: 'Kalam'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
