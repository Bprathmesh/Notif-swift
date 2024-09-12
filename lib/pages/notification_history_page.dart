import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/services/notification_service.dart';
import 'package:intl/intl.dart';

class NotificationHistoryPage extends StatefulWidget {
  @override
  _NotificationHistoryPageState createState() => _NotificationHistoryPageState();
}

class _NotificationHistoryPageState extends State<NotificationHistoryPage> {
  final NotificationService _notificationService = NotificationService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late Stream<QuerySnapshot> _notificationsStream;

  @override
  void initState() {
    super.initState();
    _initializeStream();
  }

  void _initializeStream() {
    final user = _auth.currentUser;
    if (user != null) {
      _notificationsStream = _firestore
          .collection('users')
          .doc(user.uid)
          .collection('notifications')
          .orderBy('timestamp', descending: true)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification History'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No notifications'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final notification = snapshot.data!.docs[index];
              return Dismissible(
                key: Key(notification.id),
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteNotification(notification.id);
                },
                child: ListTile(
                  title: Text(notification['title'] ?? 'No title'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification['body'] ?? 'No body'),
                      Text(
                        _getFormattedDate(notification),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    _getNotificationIcon(notification),
                    color: _getNotificationColor(notification),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _getFormattedDate(DocumentSnapshot notification) {
    if (notification['status'] == 'scheduled' && notification['scheduledTime'] != null) {
      return 'Scheduled for: ${DateFormat('yyyy-MM-dd HH:mm').format(notification['scheduledTime'].toDate())}';
    } else if (notification['timestamp'] != null) {
      return 'Sent: ${DateFormat('yyyy-MM-dd HH:mm').format(notification['timestamp'].toDate())}';
    }
    return 'No date';
  }

  IconData _getNotificationIcon(DocumentSnapshot notification) {
    return notification['status'] == 'scheduled' ? Icons.schedule : Icons.notifications;
  }

  Color _getNotificationColor(DocumentSnapshot notification) {
    return notification['status'] == 'scheduled' ? Colors.orange : Colors.blue;
  }

  void _deleteNotification(String notificationId) {
    _notificationService.deleteNotification(notificationId).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Notification deleted')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete notification')),
      );
    });
  }
}