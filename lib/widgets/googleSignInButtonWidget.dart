import 'package:flutter/material.dart';

class GoogleSignInButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButtonWidget({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      color: Colors.white,
      elevation: 2.0,
      height: 40.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0)
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/google_icon.png',
            height: 18.0,
          ),
          const SizedBox(width: 12.0),
          const Text(
            'Sign in with Google',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
