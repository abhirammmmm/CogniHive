import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String title;
  final String route;
  final bool isLogout;

  const DrawerItem({
    Key? key,
    required this.title,
    required this.route,
    this.isLogout = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: 180,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          Navigator.pushNamed(context, route);
        },
        style: ElevatedButton.styleFrom(
          primary: isLogout ? Colors.red : Color(0xFF1E2832),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
      ),
    );
  }
}
