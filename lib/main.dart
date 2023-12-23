import 'package:cognihive_version1/screens/Login/login_ui.dart';
import 'package:cognihive_version1/screens/home/profile_ui.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    routes: {
      '/' : (context)=> ProfileUI(),
    },
  ));
}




