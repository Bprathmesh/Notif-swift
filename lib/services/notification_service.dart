import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/models/user.dart' as AppUser;

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _defaultChannelId = 'default_channel_id';
  static const String _defaultChannelName = 'Default Notifications';
  static const String _personalizedChannelId = 'personalized_channel_id';
  static const String _personalizedChannelName = 'Personalized Notifications';

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

      // Create a notification channel for personalized notifications
      const AndroidNotificationChannel personalizedChannel = AndroidNotificationChannel(
        _personalizedChannelId,
        _personalizedChannelName,
        importance: Importance.high,
      );
      await _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(personalizedChannel);
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
        _defaultChannelId,
        _defaultChannelName,
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

  Future<void> sendPersonalizedNotification({required String title, required String body, required String userId}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          AppUser.User appUser = AppUser.User.fromMap(userDoc.data() as Map<String, dynamic>);

          if (appUser.receiveNotifications) {
            String title = 'Hello ${appUser.name}!';
            String body = _getPersonalizedBody(appUser);

            await _showPersonalizedNotification(title, body);
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

  String _getPersonalizedBody(AppUser.User user) {
    if (user.interests.isEmpty) {
      return "Check out our latest updates!";
    }

    String interest = user.interests[DateTime.now().microsecond % user.interests.length];
    
    Map<String, List<String>> interestMessages = {
      'Technology': [
        "New tech gadget just launched!",
        "Breaking news in AI development!",
        "Discover the latest in smart home technology.",
      ],
      'Sports': [
        "Big game alert! Don't miss the action.",
        "Your favorite team has an upcoming match!",
        "New sports gear now available.",
      ],
      'Music': [
        "Your favorite artist just dropped a new album!",
        "Tickets for an upcoming concert are now on sale.",
        "Discover this week's top charts.",
      ],
      'Travel': [
        "Dreaming of a getaway? Check out our latest travel deals!",
        "Explore new destinations with our travel guide.",
        "Last-minute vacation packages now available!",
      ],
      'Food': [
        "Hungry? Discover new recipes for your favorite cuisine.",
        "Top-rated restaurants in your area with special offers!",
        "New cooking tutorial: Learn to make gourmet dishes at home.",
      ],
    };

    List<String> messages = interestMessages[interest] ?? ["We have some exciting news for you!"];
    return messages[DateTime.now().second % messages.length];
  }

  Future<void> _showPersonalizedNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      _personalizedChannelId,
      _personalizedChannelName,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
    );

    await _saveNotificationToFirestore(title, body);
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
        print('Notification deleted successfully');
      } catch (e) {
        print('Error deleting notification: $e');
        throw e;
      }
    }
  }

  Future<void> sendBulkNotifications(String title, String body) async {
    try {
      QuerySnapshot users = await _firestore.collection('users').where('receiveNotifications', isEqualTo: true).get();

      for (var userDoc in users.docs) {
        String fcmToken = userDoc.get('fcmToken');
        await _fcm.sendMessage(
          to: fcmToken,
          data: {'title': title, 'body': body},
        );
      }
    } catch (e) {
      print('Error sending bulk notifications: $e');
    }
  }
}
