import 'package:flutter/material.dart';


class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

void main() {
  runApp(MaterialApp(
    routes: {
      '/' : (context)=> const Home(),
    },
  ));
}




