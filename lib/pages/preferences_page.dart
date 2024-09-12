import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/models/user.dart' as AppUser;
import 'package:mypushnotifications/services/notification_service.dart';

class PreferencesPage extends StatefulWidget {
  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();
  
  late AppUser.User _user;
  bool _isLoading = true;

  List<String> _availableInterests = [
    'Technology', 'Sports', 'Music', 'Travel', 'Food', 'Fashion', 'Health', 'Finance'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    setState(() {
      _isLoading = true;
    });

    final userId = _auth.currentUser!.uid;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    
    if (userDoc.exists) {
      _user = AppUser.User.fromMap(userDoc.data()!..['id'] = userId);
    } else {
      // Handle the case where the user document doesn't exist
      _user = AppUser.User(
        id: userId,
        name: _auth.currentUser!.displayName ?? '',
        email: _auth.currentUser!.email ?? '',
        receivePromotions: false,
        receiveUpdates: false,
        receiveNotifications: false,
        fcmToken: '',
        interests: [],
        lastLogin: DateTime.now(),
        createdAt: DateTime.now(),
      );
      // Create the user document in Firestore
      await _firestore.collection('users').doc(userId).set(_user.toMap());
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _savePreferences() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Update lastLogin
      _user = _user.copyWith(lastLogin: DateTime.now());
      
      await _firestore.collection('users').doc(_user.id).update(_user.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Preferences saved successfully')),
      );

      // If notifications are enabled, send a test notification
      if (_user.receiveNotifications) {
        await _notificationService.sendPersonalizedNotification(userId: '', title: '', body: '');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save preferences: $e')),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preferences'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  title: Text('Email'),
                  subtitle: Text(_user.email),
                ),
                SwitchListTile(
                  title: Text('Receive Notifications'),
                  value: _user.receiveNotifications,
                  onChanged: (value) {
                    setState(() {
                      _user = _user.copyWith(receiveNotifications: value);
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Receive Promotions'),
                  value: _user.receivePromotions,
                  onChanged: (value) {
                    setState(() {
                      _user = _user.copyWith(receivePromotions: value);
                    });
                  },
                ),
                SwitchListTile(
                  title: Text('Receive Updates'),
                  value: _user.receiveUpdates,
                  onChanged: (value) {
                    setState(() {
                      _user = _user.copyWith(receiveUpdates: value);
                    });
                  },
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                    'Interests',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ..._availableInterests.map((interest) => CheckboxListTile(
                  title: Text(interest),
                  value: _user.interests.contains(interest),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _user = _user.copyWith(
                          interests: [..._user.interests, interest],
                        );
                      } else {
                        _user = _user.copyWith(
                          interests: _user.interests.where((i) => i != interest).toList(),
                        );
                      }
                    });
                  },
                )).toList(),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    child: Text('Save Preferences'),
                    onPressed: _savePreferences,
                  ),
                ),
              ],
            ),
    );
  }
}