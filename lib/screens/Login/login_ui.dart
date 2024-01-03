import 'dart:async';

import 'package:cognihive_version1/providers/firebaseGoogleSigninProvider.dart';
import 'package:cognihive_version1/widgets/googleSignInButtonWidget.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({Key? key}) : super(key: key);

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();
  SnackBar? _offlineSnackBar;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (!mounted) {
      return;
    }

    _updateConnectionStatus(connectivityResult);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    if (result == ConnectivityResult.none && _offlineSnackBar == null) {
      // Show a persistent snackbar when offline
      _offlineSnackBar = SnackBar(
        content:
            Text('You are offline! Please check your internet connection.'),
        duration: Duration(days: 365), // Long duration to keep it visible
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.none,
        showCloseIcon: true,
        closeIconColor: Colors.black,
      );
      _scaffoldMessengerKey.currentState?.showSnackBar(_offlineSnackBar!);
    } else if (result != ConnectivityResult.none && _offlineSnackBar != null) {
      // Dismiss the snackbar when the connection is restored
      _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
      _offlineSnackBar = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
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
                      onPressed: () => firebaseGoogleSigninProvider(context),
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
      ),
    );
  }
}
