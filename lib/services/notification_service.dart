import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/models/user.dart' as AppUser;
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:firebase_core/firebase_core.dart';

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
          print("Notification clicked: ${response.payload}");
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
      tz.setLocalLocation(tz.getLocation('America/New_York')); // Use a default timezone

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

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(defaultChannel);

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(personalizedChannel);
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
        });
      } catch (e) {
        print('Error saving notification to Firestore: $e');
      }
    }
  }

  Future<void> sendPersonalizedNotification({required String userId, required String title, required String body}) async {
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
          String personalizedTitle = 'Hello ${appUser.name}!';
          String personalizedBody = _getPersonalizedBody(appUser);

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

  Future<void> sendPromotionalNotification() async {
    try {
      await init();
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          if (userData['receivePromotions'] == true && userData['receiveNotifications'] == true) {
            String title = 'Special Offer!';
            String body = '${userData['name'] ?? 'User'}, check out our latest promotion!';

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

  Future<void> sendUpdateNotification() async {
    try {
      await init();
      final user = _auth.currentUser;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

          if (userData['receiveUpdates'] == true) {
            String title = 'App Update';
            String body = 'We have some exciting new features for you. Update now to explore!';

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

  Future<void> scheduleNotification(String userId, DateTime scheduledTime) async {
  try {
    await init();
    final user = await _firestore.collection('users').doc(userId).get();
    if (user.exists) {
      AppUser.User appUser = AppUser.User.fromMap(user.data() as Map<String, dynamic>);
      
      String title = 'Scheduled Notification';
      String body = _getPersonalizedBody(appUser);

      // Schedule the notification
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        title,
        body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
            _personalizedChannelId,
            _personalizedChannelName,
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            sound: 'default.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );

      // Save the scheduled notification to Firestore
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('notifications')
          .add({
        'title': title,
        'body': body,
        'scheduledTime': scheduledTime,
        'status': 'scheduled',
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Notification scheduled for ${scheduledTime.toString()} and saved to Firestore');
    }
  } catch (e) {
    print('Error scheduling notification: $e');
  }
}
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> deleteNotification(String notificationId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('No user logged in.');
        return;
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .doc(notificationId)
          .delete();

      print('Notification with ID $notificationId deleted successfully.');
    } catch (e) {
      print('Error deleting notification: $e');
      rethrow; // Rethrow the error so it can be caught in the UI
    }
  }
}