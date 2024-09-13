import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/services/notification_service.dart';
import 'package:intl/intl.dart';
import 'package:mypushnotifications/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:mypushnotifications/providers/theme_provider.dart';

class NotificationHistoryPage extends StatefulWidget {
  const NotificationHistoryPage({super.key});

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

  void _toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
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
            tooltip: 'Change Theme',
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _notificationsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
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
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) {
                  _deleteNotification(notification.id);
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
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    try {
      if (notification.data() is Map<String, dynamic>) {
        final data = notification.data() as Map<String, dynamic>;
        if (data['status'] == 'scheduled') {
          return themeProvider.isDarkMode ? Colors.orangeAccent : Colors.orange;
        } else {
          return themeProvider.isDarkMode ? Colors.lightBlueAccent : Colors.blue;
        }
      }
    } catch (e) {
      print('Error getting notification color: $e');
    }
    return themeProvider.isDarkMode ? Colors.lightBlueAccent : Colors.blue;
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