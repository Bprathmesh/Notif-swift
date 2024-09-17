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
import 'package:flutter/foundation.dart' show kIsWeb;

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
      
      if (!kIsWeb) {
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

        await _createNotificationChannels();

        // Initialize timezone
        tz_data.initializeTimeZones();
        tz.setLocalLocation(tz.getLocation('America/New_York'));
      } else {
        // Web-specific initialization
        NotificationSettings settings = await _fcm.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        
        print('User granted permission: ${settings.authorizationStatus}');
      }

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

      String? token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToFirestore(token);
      }

      _fcm.onTokenRefresh.listen(_saveTokenToFirestore);

      _isInitialized = true;
    } catch (e) {
      print('Error initializing NotificationService: $e');
    }
  }
  Future<bool> areNotificationsEnabled(String userId) async {
  try {
    DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.get('receiveNotifications') ?? false;
    }
    return false;
  } catch (e) {
    print('Error checking notification settings: $e');
    return false;
  }
}
 Future<void> toggleNotifications(bool value, String userId) async {
  try {
    if (kIsWeb) {
      // Web-specific handling
      if (value) {
        // Request permission for web notifications
        NotificationSettings settings = await _fcm.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
        
        if (settings.authorizationStatus != AuthorizationStatus.authorized) {
          throw Exception('Notification permission not granted');
        }
      }
      await _updateWebNotificationPreferences(userId, value);
    } else {
      // Mobile-specific handling
      if (value) {
        await FirebaseMessaging.instance.subscribeToTopic('test_notifications');
      } else {
        await FirebaseMessaging.instance.unsubscribeFromTopic('test_notifications');
      }
    }

    // Update Firestore
    await _firestore.collection('users').doc(userId).update({
      'receiveNotifications': value,
    });

    if (value) {
      // Get and save the FCM token
      String? token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToFirestore(token);
      }
    }

  } catch (e) {
    print('Error toggling notifications: $e');
    rethrow;
  }
}
Future<void> _updateWebNotificationPreferences(String userId, bool receiveNotifications) async {
  try {
    // Update user preferences in Firestore
    await _firestore.collection('users').doc(userId).update({
      'receiveNotifications': receiveNotifications,
    });

    if (receiveNotifications) {
      // Request permission for web push notifications
      await _fcm.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      // Get the FCM token for this device
      String? token = await _fcm.getToken();
      if (token != null) {
        await _saveTokenToFirestore(token);
      }
    }

    print('Web notification preferences updated successfully');
  } catch (e) {
    print('Error updating web notification preferences: $e');
    rethrow;
  }
}
 
  Future<void> sendNotificationToTopic(String topic, String title, String body) async {
    if (kIsWeb) {
      print('Sending notifications to topics is not directly supported on web.');
      // You might want to implement a custom solution here, such as:
      // - Calling a Cloud Function that sends the notification
      // - Updating a Firestore document that triggers a Cloud Function
    } else {
      // This part remains the same for mobile platforms
      try {
        await FirebaseMessaging.instance.sendMessage(
          to: '/topics/$topic',
          data: {
            'title': title,
            'body': body,
          },
        );
        print('Notification sent to topic: $topic');
      } catch (e) {
        print('Error sending notification to topic: $e');
        rethrow;
      }
    }
  }

  Future<void> _createNotificationChannels() async {
    if (!kIsWeb) {
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
    if (!kIsWeb) {
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
    }

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
    if (!await areNotificationsEnabled(userId)) {
    print('Notifications are disabled for this user');
    return;
  }
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
        AppUser.User appUser = AppUser.User.fromMap(userDoc.data() as Map<String, dynamic>, userDoc.id);

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
      bool notificationsEnabled = await areNotificationsEnabled(user.uid);
      if (!notificationsEnabled) {
        print('Notifications are disabled for this user');
        return;
      }

      DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
      
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

        if (userData['receivePromotions'] == true) {
          String title = S.of(context).promotionalNotificationTitle;
          String body = S.of(context).promotionalNotificationBody(userData['name'] ?? S.of(context).user);

          await _showLocalNotification(title, body);
        } else {
          print('User has not opted in for promotional notifications');
        }
      } else {
        print('User document does not exist');
      }
    } else {
      print('No user is currently logged in');
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
      bool notificationsEnabled = await areNotificationsEnabled(user.uid);
      if (!notificationsEnabled) {
        print('Notifications are disabled for this user');
        return;
      }

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
    } else {
      print('No user is currently logged in');
    }
  } catch (e) {
    print('Error sending update notification: $e');
  }
}
  Future<void> scheduleNotification(String userId, DateTime scheduledTime, String title, String body) async {
    try {
      if (!kIsWeb) {
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
          payload: '$userId|$title|$body',
        );
      }

      // Store the scheduled notification info in Firestore
      await _firestore.collection('users').doc(userId).collection('scheduled_notifications').add({
        'notificationId': DateTime.now().millisecondsSinceEpoch.remainder(100000),
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
    final String? payload = response.payload;
    if (payload != null) {
      List<String> parts = payload.split('|');
      if (parts.length == 3) {
        String userId = parts[0];
        String title = parts[1];
        String body = parts[2];
        await _moveScheduledNotificationToHistory(userId, title, body);
      }
    }
  }

  Future<void> _moveScheduledNotificationToHistory(String userId, String title, String body) async {
    try {
      // Add to notifications collection
      await _firestore.collection('users').doc(userId).collection('notifications').add({
        'title': title,
        'body': body,
        'timestamp': FieldValue.serverTimestamp(),
        'status': 'sent',
      });

      // Remove from scheduled_notifications collection
      QuerySnapshot scheduledNotifications = await _firestore
          .collection('users')
          .doc(userId)
          .collection('scheduled_notifications')
          .where('title', isEqualTo: title)
          .where('body', isEqualTo: body)
          .get();

      if (scheduledNotifications.docs.isNotEmpty) {
        await scheduledNotifications.docs.first.reference.delete();
      }

      print('Scheduled notification moved to history');
    } catch (e) {
      print('Error moving scheduled notification to history: $e');
    }
  }

  Future<void> cancelNotification(int id) async {
    if (!kIsWeb) {
      await _flutterLocalNotificationsPlugin.cancel(id);
    }
    // For web, you might want to implement a different cancellation logic
    // using Firestore to mark the notification as cancelled
  }

  Future<void> cancelAllNotifications() async {
    if (!kIsWeb) {
      await _flutterLocalNotificationsPlugin.cancelAll();
    }
    // For web, you might want to implement a different cancellation logic
    // using Firestore to mark all notifications as cancelled
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

      if (type == 'scheduled' && !kIsWeb) {
        // Cancel the scheduled notification
        DocumentSnapshot notificationDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection(collectionName)
            .doc(notificationId)
            .get();
        
        if (notificationDoc.exists) {
          int? notificationId = notificationDoc.get('notificationId') as int?;
          if (notificationId != null) {
            await cancelNotification(notificationId);
          }
        }
      }

      print('Notification with ID $notificationId deleted successfully from $collectionName.');
    } catch (e) {
      print('Error deleting notification: $e');
      rethrow;
    }
  }

  // You might want to add more methods here for web-specific functionality
  // For example, a method to display notifications on web using browser APIs

  Future<void> displayWebNotification(String title, String body) async {
    if (kIsWeb) {
      // This is a basic example and might need adjustments based on your web setup
      try {
        await _fcm.requestPermission();
        await FirebaseMessaging.instance.sendMessage(
          data: {
            'title': title,
            'body': body,
          },
        );
      } catch (e) {
        print('Error displaying web notification: $e');
      }
    }
  }
}