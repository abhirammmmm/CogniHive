import 'package:cognihive_version1/firebase_options.dart';
import 'package:cognihive_version1/screens/Login/login_ui.dart';
import 'package:cognihive_version1/screens/home/create_event_page.dart';
import 'package:cognihive_version1/screens/home/home_page.dart';
import 'package:cognihive_version1/screens/home/my-interested-events.dart';
import 'package:cognihive_version1/screens/home/new_user_details.dart';
import 'package:cognihive_version1/screens/home/profile_ui.dart';
import 'package:cognihive_version1/screens/home/search_page.dart';
import 'package:cognihive_version1/screens/home/view_event_page.dart';
import 'package:cognihive_version1/screens/home/your_events_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cognihive_version1/theme_notifier.dart';

class RunMyApp extends StatelessWidget {
  final Function(ThemeMode) onThemeChanged;

  const RunMyApp({Key? key, required this.onThemeChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeNotifier.themeMode,
      home: const LoginUi(),
      routes: {
        '/new_profile': (context) => NewUserDetails(),
        '/homepage': (context) => HomePage(),
        '/createEvent': (context) => CreateEventPage(),
        '/viewEvent': (context) => const ViewEventPage(eventData: {}),
        '/searchPage': (context) => SearchEnginePage(),
        '/editProfilePage': (context) => ProfileUI(),
        '/logoutPage': (context) => const LoginUi(),
        '/yourEventsPage': (context) => UserEventsPage(),
        '/interestedEvents': (context) => InterestedEventsPage(),
      },
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final themeNotifier = ThemeNotifier();

  runApp(
    ChangeNotifierProvider(
      create: (_) => themeNotifier,
      child: RunMyApp(
        onThemeChanged: themeNotifier.setThemeMode,
      ),
    ),
  );
}
