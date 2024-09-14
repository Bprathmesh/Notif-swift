// ignore_for_file: deprecated_member_use

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/models/user.dart' as AppUser;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mypushnotifications/generated/l10n.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

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
  static const String _scheduledChannelId = 'scheduled_channel_id';
  static const String _scheduledChannelName = 'Scheduled Notifications';

  bool _isInitialized = false;

  Future<void> init() async {
    if (_isInitialized) return;

    try {
      await Firebase.initializeApp();
      
      await _fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
      const DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );
      final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      );

      await _flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          _handleNotificationResponse(response);
        },
      );

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      String? token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToFirestore(token);
      }

      _fcm.onTokenRefresh.listen(_saveTokenToFirestore);

      await _createNotificationChannels();

      // Initialize timezone
      tz_data.initializeTimeZones();
      tz.setLocalLocation(tz.getLocation('America/New_York')); // Use a default timezone or get it from the device

      _isInitialized = true;
    } catch (e) {
      print('Error initializing NotificationService: $e');
    }
  }

  Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel defaultChannel = AndroidNotificationChannel(
      _defaultChannelId,
      _defaultChannelName,
      importance: Importance.high,
    );

    const AndroidNotificationChannel personalizedChannel = AndroidNotificationChannel(
      _personalizedChannelId,
      _personalizedChannelName,
      importance: Importance.high,
    );

    const AndroidNotificationChannel scheduledChannel = AndroidNotificationChannel(
      _scheduledChannelId,
      _scheduledChannelName,
      importance: Importance.high,
    );

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(defaultChannel);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(personalizedChannel);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(scheduledChannel);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    print("Handling a foreground message: ${message.messageId}");
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _showLocalNotification(notification.title ?? '', notification.body ?? '');
    }

    if (message.data.isNotEmpty) {
      print("Data: ${message.data}");
      // Handle data message
    }
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    print("Handling a message that opened the app: ${message.messageId}");
    // Add navigation or action based on the message
  }

  Future<void> _showLocalNotification(String title, String body) async {
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
  }

  Future<void> _saveTokenToFirestore(String token) async {
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
          'status': 'sent',
        });
      } catch (e) {
        print('Error saving notification to Firestore: $e');
      }
    }
  }

  Future<void> sendPersonalizedNotification({
    required String userId,
    required String title,
    required String body,
    required BuildContext context,
  }) async {
    try {
      await init();
      final user = _auth.currentUser;
      if (user == null) {
        print('No user is currently logged in.');
        return;
      }

      if (userId.isEmpty) {
        print('User ID cannot be empty.');
        return;
      }

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      
      if (userDoc.exists) {
        AppUser.User appUser = AppUser.User.fromMap(userDoc.data() as Map<String, dynamic>);

        if (appUser.receiveNotifications) {
          String personalizedTitle = S.of(context).hello(appUser.name);
          String personalizedBody = _getPersonalizedBody(appUser, context);

          await _showLocalNotification(personalizedTitle, personalizedBody);
        } else {
          print('User has not opted in for notifications');
        }
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error sending personalized notification: $e');
    }
  }

  String _getPersonalizedBody(AppUser.User user, BuildContext context) {
    if (user.interests.isEmpty) {
      return S.of(context).defaultMessage;
    }

    String interest = user.interests[DateTime.now().microsecond % user.interests.length];
    
    Map<String, List<String>> interestMessages = {
      S.of(context).technology: [
        S.of(context).technologyMessage1,
        S.of(context).technologyMessage2,
        S.of(context).technologyMessage3,
      ],
      S.of(context).sports: [
        S.of(context).sportsMessage1,
        S.of(context).sportsMessage2,
        S.of(context).sportsMessage3,
      ],
      S.of(context).music: [
        S.of(context).musicMessage1,
        S.of(context).musicMessage2,
        S.of(context).musicMessage3,
      ],
      S.of(context).travel: [
        S.of(context).travelMessage1,
        S.of(context).travelMessage2,
        S.of(context).travelMessage3,
      ],
      S.of(context).food: [
        S.of(context).foodMessage1,
        S.of(context).foodMessage2,
        S.of(context).foodMessage3,
      ],
    };

    List<String> messages = interestMessages[interest] ?? [S.of(context).defaultMessage];
    return messages[DateTime.now().second % messages.length];
  }

  Future<void> sendPromotionalNotification(BuildContext context) async {
    try {
      await init();
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          if (userData['receivePromotions'] == true && userData['receiveNotifications'] == true) {
            String title = S.of(context).promotionalNotificationTitle;
            String body = S.of(context).promotionalNotificationBody(userData['name'] ?? S.of(context).user);

            await _showLocalNotification(title, body);
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

  Future<void> sendUpdateNotification(BuildContext context) async {
    try {
      await init();
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          if (userData['receiveUpdates'] == true) {
            String title = S.of(context).updateNotificationTitle;
            String body = S.of(context).updateNotificationBody;

            await _showLocalNotification(title, body);
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

  Future<void> scheduleNotification(String userId, DateTime scheduledTime, String title, String body) async {
  try {
    final int notificationId = DateTime.now().millisecondsSinceEpoch.remainder(100000);

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      NotificationDetails(
        android: AndroidNotificationDetails(
          _scheduledChannelId,
          _scheduledChannelName,
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );

    // Store the scheduled notification info in Firestore
    await _firestore.collection('users').doc(userId).collection('scheduled_notifications').add({
      'notificationId': notificationId,
      'title': title,
      'body': body,
      'scheduledTime': scheduledTime,
      'status': 'scheduled',
    });

    print('Notification scheduled successfully for $scheduledTime');
  } catch (e) {
    print('Error scheduling notification: $e');
    throw Exception('Failed to schedule notification: $e');
  }
}
 Future<void> _handleNotificationResponse(NotificationResponse response) async {
    final String? notificationIdString = response.id?.toString();
    final int? notificationId = notificationIdString != null ? int.tryParse(notificationIdString) : null;
    final user = _auth.currentUser;

    if (user != null && notificationId != null) {
      // Find the scheduled notification document
      QuerySnapshot scheduledNotifications = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('scheduled_notifications')
          .where('notificationId', isEqualTo: notificationId)
          .get();

      if (scheduledNotifications.docs.isNotEmpty) {
        DocumentSnapshot scheduledNotification = scheduledNotifications.docs.first;
        
        // Move the notification to the history
        await _firestore.collection('users').doc(user.uid).collection('notifications').add({
          'title': scheduledNotification['title'],
          'body': scheduledNotification['body'],
          'timestamp': FieldValue.serverTimestamp(),
          'status': 'sent',
        });

        // Delete the scheduled notification document
        await scheduledNotification.reference.delete();
      }
    }
  }
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

   Future<void> deleteNotification(String notificationId, String type) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('No user logged in.');
        return;
      }

      String collectionName = type == 'regular' ? 'notifications' : 'scheduled_notifications';

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection(collectionName)
          .doc(notificationId)
          .delete();

      print('Notification with ID $notificationId deleted successfully from $collectionName.');
    } catch (e) {
      print('Error deleting notification: $e');
      rethrow;
    }
  }
}