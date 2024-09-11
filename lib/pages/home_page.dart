import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mypushnotifications/services/auth_service.dart';
import 'package:mypushnotifications/services/notification_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();
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

      await _saveTokenToFirestore(token);
      await _firebaseMessaging.subscribeToTopic('test_notifications');
    } else {
      print('User declined or has not accepted permission');
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print('Notification: ${message.notification}');
        _notificationService.sendPersonalizedNotification(
          title: message.notification!.title ?? '',
          body: message.notification!.body ?? '',
        );
      }
    });

    _receiveNotifications = await _getCurrentNotificationSettings();
    setState(() {});
  }

  Future<void> _saveTokenToFirestore(String? token) async {
    if (token != null) {
      String? userId = _authService.getCurrentUser()?.uid;
      if (userId != null) {
        try {
          DocumentReference userRef = _firestore.collection('users').doc(userId);
          DocumentSnapshot userDoc = await userRef.get();
          
          if (userDoc.exists) {
            await userRef.update({
              'fcmToken': token,
            });
          } else {
            await userRef.set({
              'fcmToken': token,
              'name': 'User', // Default name
              'receivePromotions': false,
              'receiveUpdates': false,
              'receiveNotifications': false, // Add this field
            });
          }
        } catch (e) {
          print('Error saving FCM token to Firestore: $e');
        }
      }
    }
  }

  Future<bool> _getCurrentNotificationSettings() async {
    String? userId = _authService.getCurrentUser()?.uid;
    if (userId != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          // Check if the field exists, if not, return a default value
          return (userDoc.data() as Map<String, dynamic>)['receiveNotifications'] ?? false;
        }
      } catch (e) {
        print('Error getting notification settings: $e');
      }
    }
    return false;
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _receiveNotifications = value;
    });

    String? userId = _authService.getCurrentUser()?.uid;
    if (userId != null) {
      try {
        await _firestore.collection('users').doc(userId).update({
          'receiveNotifications': value,
        });
      } catch (e) {
        print('Error updating notification settings: $e');
      }
    }

    if (value) {
      await _firebaseMessaging.subscribeToTopic('test_notifications');
    } else {
      await _firebaseMessaging.unsubscribeFromTopic('test_notifications');
    }
  }

  Future<void> _signOut() async {
    await _authService.signOut();
    Navigator.pushReplacementNamed(context, '/sign_in');
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
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Send Personalized Notification'),
              onPressed: () async {
                await _notificationService.sendPersonalizedNotification(title: '', body: '');
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Personalized notification sent')),
                );
              },
            ),
            ElevatedButton(
              child: Text('Send Promotional Notification'),
              onPressed: () async {
                await _notificationService.sendPromotionalNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Promotional notification sent')),
                );
              },
            ),
            ElevatedButton(
              child: Text('Send Update Notification'),
              onPressed: () async {
                await _notificationService.sendUpdateNotification();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Update notification sent')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}