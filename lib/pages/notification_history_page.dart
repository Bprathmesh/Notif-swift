import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:mypushnotifications/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:mypushnotifications/providers/theme_provider.dart';
import 'dart:async';

class NotificationHistoryPage extends StatefulWidget {
  const NotificationHistoryPage({Key? key}) : super(key: key);

  @override
  _NotificationHistoryPageState createState() => _NotificationHistoryPageState();
}

class _NotificationHistoryPageState extends State<NotificationHistoryPage> {
  final NotificationService _notificationService = NotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late StreamController<List<Map<String, dynamic>>> _streamController;
  late Stream<List<Map<String, dynamic>>> _combinedNotificationsStream;
  List<StreamSubscription> _subscriptions = [];
  Timer? _periodicTimer;

  @override
  void initState() {
    super.initState();
    _streamController = StreamController<List<Map<String, dynamic>>>();
    _combinedNotificationsStream = _streamController.stream;
    _initializeStream();
    // Set up a periodic timer to update the list every minute
    _periodicTimer = Timer.periodic(Duration(minutes: 1), (_) => _updateCombinedList());
  }

  @override
  void dispose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    _streamController.close();
    _periodicTimer?.cancel();
    super.dispose();
  }

  void _initializeStream() {
    final user = _auth.currentUser;
    if (user != null) {
      var notificationsSubscription = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((snapshot) => _updateCombinedList());

      var scheduledNotificationsSubscription = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('scheduled_notifications')
          .orderBy('scheduledTime', descending: true)
          .snapshots()
          .listen((snapshot) => _updateCombinedList());

      _subscriptions.add(notificationsSubscription);
      _subscriptions.add(scheduledNotificationsSubscription);
    }
  }

 void _updateCombinedList() async {
  final user = _auth.currentUser;
  if (user != null) {
    var notificationsSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .get();

    var scheduledNotificationsSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('scheduled_notifications')
        .orderBy('scheduledTime', descending: true)
        .get();

    List<Map<String, dynamic>> combinedList = [];

    DateTime now = DateTime.now();

    for (var doc in notificationsSnapshot.docs) {
      combinedList.add({
        ...doc.data(),
        'id': doc.id,
        'type': 'regular',
      });
    }

    for (var doc in scheduledNotificationsSnapshot.docs) {
      DateTime scheduledTime = (doc['scheduledTime'] as Timestamp).toDate();
      if (scheduledTime.isBefore(now)) {
        combinedList.add({
          ...doc.data(),
          'id': doc.id,
          'type': 'scheduled',
        });
      }
    }

    combinedList.sort((a, b) {
      DateTime aTime = a['type'] == 'regular' 
          ? (a['timestamp'] as Timestamp).toDate() 
          : (a['scheduledTime'] as Timestamp).toDate();
      DateTime bTime = b['type'] == 'regular' 
          ? (b['timestamp'] as Timestamp).toDate() 
          : (b['scheduledTime'] as Timestamp).toDate();
      return bTime.compareTo(aTime);
    });

    _streamController.add(combinedList);
  }
}
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).notificationHistoryPage),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
            tooltip: S.of(context).changeTheme,
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _combinedNotificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(S.of(context).errorFetchingNotifications));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(S.of(context).noNotifications));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final notification = snapshot.data![index];
              return Dismissible(
                key: Key(notification['id']),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteNotification(notification['id'], notification['type']);
                },
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(
                      notification['title'] ?? S.of(context).noTitle,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.titleLarge?.color,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          notification['body'] ?? S.of(context).noBody,
                          style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color),
                        ),
                        Text(
                          _getFormattedDate(notification),
                          style: TextStyle(
                            fontSize: 12,
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      _getNotificationIcon(notification),
                      color: _getNotificationColor(notification),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getFormattedDate(Map<String, dynamic> notification) {
    try {
      if (notification['type'] == 'regular') {
        return S.of(context).sent(DateFormat('yyyy-MM-dd HH:mm').format((notification['timestamp'] as Timestamp).toDate()));
      } else {
        return S.of(context).scheduledFor(DateFormat('yyyy-MM-dd HH:mm').format((notification['scheduledTime'] as Timestamp).toDate()));
      }
    } catch (e) {
      print('Error formatting date: $e');
      return S.of(context).noDate;
    }
  }

  IconData _getNotificationIcon(Map<String, dynamic> notification) {
    return notification['type'] == 'regular' ? Icons.notifications : Icons.schedule;
  }

  Color _getNotificationColor(Map<String, dynamic> notification) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    return notification['type'] == 'regular'
        ? (themeProvider.isDarkMode ? Colors.lightBlueAccent : Colors.blue)
        : (themeProvider.isDarkMode ? Colors.orangeAccent : Colors.orange);
  }

  void _deleteNotification(String notificationId, String type) {
    _notificationService.deleteNotification(notificationId, type).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).notificationDeleted)),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).failedToDeleteNotification)),
      );
    });
  }

  void _toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }
}