import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _channelId = 'default_channel_id';
  static const String _channelName = 'Default Notifications';

  Future<void> init() async {
    try {
      await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
      await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      String? token = await _fcm.getToken();
      await _saveTokenToFirestore(token);

      _fcm.onTokenRefresh.listen(_saveTokenToFirestore);
    } catch (e) {
      print('Error initializing NotificationService: $e');
    }
  }

  void _handleForegroundMessage(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _showNotification(notification.title ?? '', notification.body ?? '');
    }
  }

  void _handleBackgroundMessage(RemoteMessage message) {
    print("Handling a background message: ${message.messageId}");
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Handling a background message: ${message.messageId}");
  }

  Future<void> _showNotification(String title, String body) async {
    try {
      const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
        _channelId,
        _channelName,
        importance: Importance.max,
        priority: Priority.high,
      );
      const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
        0, // Notification ID
        title,
        body,
        platformChannelSpecifics,
      );

      await _saveNotificationToFirestore(title, body);
    } catch (e) {
      print('Error showing notification: $e');
    }
  }

  Future<void> _saveTokenToFirestore(String? token) async {
    if (token != null) {
      final user = _auth.currentUser;
      if (user != null) {
        try {
          await _firestore
              .collection('users')
              .doc(user.uid)
              .update({'fcmToken': token});
        } catch (e) {
          print('Error saving FCM token to Firestore: $e');
        }
      }
    }
  }

  Future<void> _saveNotificationToFirestore(String title, String body) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
            .add({
          'title': title,
          'body': body,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print('Error saving notification to Firestore: $e');
      }
    }
  }

  Future<void> sendPersonalizedNotification({String title = '', String body = ''}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          if (userData['receiveNotifications'] == true) {
            title = title.isEmpty ? 'Hello ${userData['name'] ?? 'User'}!' : title;
            body = body.isEmpty ? 'This is a personalized notification just for you.' : body;

            await _showNotification(title, body);
          } else {
            print('User has not opted in for notifications');
          }
        } else {
          print('User document does not exist');
        }
      }
    } catch (e) {
      print('Error sending personalized notification: $e');
    }
  }

  Future<void> sendPromotionalNotification() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          if (userData['receivePromotions'] == true && userData['receiveNotifications'] == true) {
            String title = 'Special Offer!';
            String body = '${userData['name'] ?? 'User'}, check out our latest promotion!';

            await _showNotification(title, body);
          } else {
            print('User has not opted in for promotional notifications');
          }
        } else {
          print('User document does not exist');
        }
      }
    } catch (e) {
      print('Error sending promotional notification: $e');
    }
  }

  Future<void> sendUpdateNotification() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          if (userData['receiveUpdates'] == true && userData['receiveNotifications'] == true) {
            String title = 'New Update Available';
            String body = '${userData['name'] ?? 'User'}, we have some exciting updates for you!';

            await _showNotification(title, body);
          } else {
            print('User has not opted in for update notifications');
          }
        } else {
          print('User document does not exist');
        }
      }
    } catch (e) {
      print('Error sending update notification: $e');
    }
  }
  Future<void> deleteNotification(String notificationId) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('notifications')
            .doc(notificationId)
            .delete();
      } catch (e) {
        print('Error deleting notification: $e');
      }
    }
  }
}