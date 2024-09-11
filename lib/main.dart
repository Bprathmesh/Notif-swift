import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/register_page.dart';
import 'pages/notification_history_page.dart';
import 'pages/preferences_page.dart';
import 'pages/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart'; // Ensure you import the NotificationService

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Wrapper(),
        '/home': (context) => HomePage(),
        '/sign_in': (context) => SignInPage(),
        '/register': (context) => RegisterPage(),
        '/notification_history': (context) => NotificationHistoryPage(),
        '/preferences': (context) => PreferencesPage(),
      },
    );
  }
}
