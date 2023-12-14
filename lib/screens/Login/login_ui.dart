import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginUi extends StatelessWidget {
  const LoginUi({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            bottom: 25,
            left: MediaQuery.of(context).size.width * 0.5 - 90,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image
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

          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.60,
            left: MediaQuery.of(context).size.width * 0.5 - 95,
            child: const Text(
              'Login/Register',
              style: TextStyle(fontSize: 30),
            ),
          ),

          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.5,
            left: MediaQuery.of(context).size.width * 0.5 - 90,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: Colors.white, side: const BorderSide(color: Colors.black45),
              ),
              child: const Text('Sign in with Google', style: TextStyle(fontSize: 18, color: Colors.black)),
              onPressed: () async {
                const url = 'https://www.google.com';
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
