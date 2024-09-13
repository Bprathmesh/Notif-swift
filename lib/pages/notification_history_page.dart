import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:mypushnotifications/generated/l10n.dart';

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
        title: Text(S.of(context).notificationHistoryPage),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(S.of(context).error(snapshot.error.toString())));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text(S.of(context).noNotifications));
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
                  title: Text(notification['title'] ?? S.of(context).noTitle),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notification['body'] ?? S.of(context).noBody),
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
    try {
      if (notification.data() is Map<String, dynamic>) {
        final data = notification.data() as Map<String, dynamic>;
        if (data['status'] == 'scheduled' && data['scheduledTime'] != null) {
          return S.of(context).scheduledFor(DateFormat('yyyy-MM-dd HH:mm').format(data['scheduledTime'].toDate()));
        } else if (data['timestamp'] != null) {
          return S.of(context).sent(DateFormat('yyyy-MM-dd HH:mm').format(data['timestamp'].toDate()));
        }
      }
    } catch (e) {
      print('Error formatting date: $e');
    }
    return S.of(context).noDate;
  }

  IconData _getNotificationIcon(DocumentSnapshot notification) {
    try {
      if (notification.data() is Map<String, dynamic>) {
        final data = notification.data() as Map<String, dynamic>;
        return data['status'] == 'scheduled' ? Icons.schedule : Icons.notifications;
      }
    } catch (e) {
      print('Error getting notification icon: $e');
    }
    return Icons.notifications;
  }

  Color _getNotificationColor(DocumentSnapshot notification) {
    try {
      if (notification.data() is Map<String, dynamic>) {
        final data = notification.data() as Map<String, dynamic>;
        return data['status'] == 'scheduled' ? Colors.orange : Colors.blue;
      }
    } catch (e) {
      print('Error getting notification color: $e');
    }
    return Colors.blue;
  }

  void _deleteNotification(String notificationId) {
    _notificationService.deleteNotification(notificationId).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).notificationDeleted)),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).failedToDeleteNotification)),
      );
    });
  }
}