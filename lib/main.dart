import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'services/firebase_service.dart';
import 'services/notification_service.dart';
import 'pages/notification_history_page.dart';
import 'pages/preferences_page.dart';
import 'pages/register_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  
  final notificationService = NotificationService();
  await notificationService.initialize();
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/register',
      routes: {
        '/register': (context) => RegisterPage(),
        '/preferences': (context) => PreferencesPage(),
        '/notification_history': (context) => NotificationHistoryPage(),
      },
    );
  }
}
