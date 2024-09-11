import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mypushnotifications/services/auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  bool _receiveNotifications = false;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      String? token = await _firebaseMessaging.getToken();
      print('FCM Token: $token');

      await _firebaseMessaging.subscribeToTopic('test_notifications');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Notification: ${message.notification}');
      }
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _receiveNotifications = value;
    });

    if (value) {
      await _firebaseMessaging.subscribeToTopic('test_notifications');
    } else {
      await _firebaseMessaging.unsubscribeFromTopic('test_notifications');
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/preferences');
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SwitchListTile(
              title: Text('Receive Notifications'),
              value: _receiveNotifications,
              onChanged: _toggleNotifications,
            ),
            ElevatedButton(
              child: Text('View Notification History'),
              onPressed: () {
                Navigator.of(context).pushNamed('/notification_history');
              },
            ),
          ],
        ),
      ),
    );
  }
}
