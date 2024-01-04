import 'package:flutter/material.dart';

class SearchEnginePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Center(
        child: Text(
          'Search bar is in progress.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
