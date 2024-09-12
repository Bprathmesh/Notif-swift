import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mypushnotifications/services/auth_service.dart';
import 'package:mypushnotifications/services/notification_service.dart';
import 'package:mypushnotifications/services/firebase_service.dart';
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
  final FirebaseService _firebaseService = FirebaseService();
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
    try {
      await _notificationService.init();
      String? userId = _authService.getCurrentUser()?.uid;
      if (userId != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists) {
          setState(() {
            _receiveNotifications = userDoc.get('receiveNotifications') ?? false;
          });
        }
      }
    } catch (e) {
      print('Error initializing notifications: $e');
      _showSnackBar('Error initializing notifications. Please try again later.');
    }
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

        if (value) {
          await _firebaseMessaging.subscribeToTopic('test_notifications');
        } else {
          await _firebaseMessaging.unsubscribeFromTopic('test_notifications');
        }
      } catch (e) {
        print('Error updating notification settings: $e');
        _showSnackBar('Error updating notification settings. Please try again.');
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      Navigator.pushReplacementNamed(context, '/sign_in');
    } catch (e) {
      print('Error signing out: $e');
      _showSnackBar('Error signing out. Please try again.');
    }
  }

  Future<void> _sendPersonalizedNotification() async {
    try {
      String? userId = _authService.getCurrentUser()?.uid;
      if (userId != null) {
        await _notificationService.sendPersonalizedNotification(
          userId: userId,
          title: 'Personalized Notification',
          body: 'This is a test personalized notification',
        );
        _showSnackBar('Personalized notification sent');
      } else {
        _showSnackBar('User not logged in. Cannot send notification.');
      }
    } catch (e) {
      print('Error sending personalized notification: $e');
      _showSnackBar('Error sending personalized notification. Please try again.');
    }
  }

  Future<void> _sendPromotionalNotification() async {
    try {
      await _notificationService.sendPromotionalNotification();
      _showSnackBar('Promotional notification sent');
    } catch (e) {
      print('Error sending promotional notification: $e');
      _showSnackBar('Error sending promotional notification. Please try again.');
    }
  }

  Future<void> _sendUpdateNotification() async {
    try {
      await _notificationService.sendUpdateNotification();
      _showSnackBar('Update notification sent');
    } catch (e) {
      print('Error sending update notification: $e');
      _showSnackBar('Error sending update notification. Please try again.');
    }
  }

  Future<void> _scheduleNotification() async {
    try {
      await _notificationService.init(); // Ensure initialization
      DateTime scheduledTime = DateTime.now().add(Duration(minutes: 1));
      String? userId = _authService.getCurrentUser()?.uid;
      if (userId != null) {
        await _notificationService.scheduleNotification(userId, scheduledTime);
        _showSnackBar('Notification scheduled for 1 minute from now');
      } else {
        _showSnackBar('User not logged in. Cannot schedule notification.');
      }
    } catch (e) {
      print('Error scheduling notification: $e');
      _showSnackBar('Error scheduling notification. Please try again.');
    }
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
                    _sendPersonalizedNotification,
                  ),
                  SizedBox(height: 10),
                  _buildNotificationButton(
                    'Send Promotional Notification',
                    Icons.local_offer,
                    _sendPromotionalNotification,
                  ),
                  SizedBox(height: 10),
                  _buildNotificationButton(
                    'Send Update Notification',
                    Icons.update,
                    _sendUpdateNotification,
                  ),
                  SizedBox(height: 10),
                  _buildNotificationButton(
                    'Schedule Notification',
                    Icons.schedule,
                    _scheduleNotification,
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