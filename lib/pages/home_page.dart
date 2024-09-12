import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mypushnotifications/services/auth_service.dart';
import 'package:mypushnotifications/services/notification_service.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();
  bool _receiveNotifications = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
          userId: _authService.getCurrentUser()!.uid,
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
              'receiveNotifications': false,
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
        title: Text('Home Page', style: TextStyle(fontWeight: FontWeight.bold)),
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
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Theme.of(context).primaryColor, Colors.white],
            ),
          ),
          child: AnimationLimiter(
            child: ListView(
              padding: EdgeInsets.all(20),
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: <Widget>[
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: SwitchListTile(
                      title: Text('Receive Notifications', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      value: _receiveNotifications,
                      onChanged: _toggleNotifications,
                      secondary: Icon(Icons.notifications, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: Icon(Icons.history),
                    label: Text('View Notification History'),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/notification_history');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('Send Test Notifications', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  _buildNotificationButton(
                    'Send Personalized Notification',
                    Icons.person,
                    () async {
                      await _notificationService.sendPersonalizedNotification(
                        userId: _authService.getCurrentUser()?.uid ?? '',
                        title: 'Test Title',
                        body: 'This is a test personalized notification',
                      );
                      _showSnackBar('Personalized notification sent');
                    },
                  ),
                  SizedBox(height: 10),
                  _buildNotificationButton(
                    'Send Promotional Notification',
                    Icons.local_offer,
                    () async {
                      await _notificationService.sendPromotionalNotification();
                      _showSnackBar('Promotional notification sent');
                    },
                  ),
                  SizedBox(height: 10),
                  _buildNotificationButton(
                    'Send Update Notification',
                    Icons.update,
                    () async {
                      await _notificationService.sendUpdateNotification();
                      _showSnackBar('Update notification sent');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
