// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, library_prefixes

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/models/user.dart' as AppUser;
import 'package:mypushnotifications/services/notification_service.dart';
import 'package:mypushnotifications/services/auth_service.dart';
import 'package:mypushnotifications/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:mypushnotifications/providers/theme_provider.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final NotificationService _notificationService = NotificationService();
  final AuthService _authService = AuthService();
  final FirebaseService _firebaseService = FirebaseService();
  
  late AppUser.User _user;
  bool _isLoading = true;

  final List<String> _availableInterests = [
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

      // Update user preferences using FirebaseService
      await _firebaseService.saveUserPreferences(_user.id, _user.receivePromotions);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferences saved successfully')),
      );

      // If notifications are enabled, send a test notification
      if (_user.receiveNotifications) {
        await _notificationService.sendPersonalizedNotification(
          userId: _user.id,
          title: 'Preferences Updated',
          body: 'Your notification preferences have been updated.',
        );
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

  void _toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferences'),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
            tooltip: 'Change Theme',
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: const Text('Email'),
                    subtitle: Text(_user.email),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: SwitchListTile(
                    title: const Text('Receive Notifications'),
                    value: _user.receiveNotifications,
                    onChanged: (value) {
                      setState(() {
                        _user = _user.copyWith(receiveNotifications: value);
                      });
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: SwitchListTile(
                    title: const Text('Receive Promotions'),
                    value: _user.receivePromotions,
                    onChanged: (value) {
                      setState(() {
                        _user = _user.copyWith(receivePromotions: value);
                      });
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: SwitchListTile(
                    title: const Text('Receive Updates'),
                    value: _user.receiveUpdates,
                    onChanged: (value) {
                      setState(() {
                        _user = _user.copyWith(receiveUpdates: value);
                      });
                    },
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'Interests',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ..._availableInterests.map((interest) => Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: CheckboxListTile(
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
                  ),
                )),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: _savePreferences,
                    child: const Text('Save Preferences'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}