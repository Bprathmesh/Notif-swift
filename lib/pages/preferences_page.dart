import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/models/user.dart' as AppUser;
import 'package:mypushnotifications/services/notification_service.dart';
import 'package:mypushnotifications/services/auth_service.dart';
import 'package:mypushnotifications/services/firebase_service.dart';
import 'package:provider/provider.dart';
import 'package:mypushnotifications/providers/theme_provider.dart';
import 'package:mypushnotifications/providers/language_provider.dart';
import 'package:mypushnotifications/generated/l10n.dart';

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
        preferredLanguage: 'en',
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
        SnackBar(content: Text(S.of(context).preferencesSaved)),
      );

      // If notifications are enabled, send a test notification
      if (_user.receiveNotifications) {
        await _notificationService.sendPersonalizedNotification(
          userId: _user.id,
          title: S.of(context).preferencesUpdated,
          body: S.of(context).notificationPreferencesUpdated,
          context: context,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(S.of(context).failedToSavePreferences(e.toString()))),
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

  List<String> _getAvailableInterests(BuildContext context) {
    return [
      S.of(context).technology,
      S.of(context).sports,
      S.of(context).music,
      S.of(context).travel,
      S.of(context).food,
      S.of(context).fashion,
      S.of(context).health,
      S.of(context).finance,
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    final availableInterests = _getAvailableInterests(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).preferences),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
            tooltip: S.of(context).changeTheme,
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
                    title: Text(S.of(context).email),
                    subtitle: Text(_user.email),
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: SwitchListTile(
                    title: Text(S.of(context).receiveNotifications),
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
                    title: Text(S.of(context).receivePromotions),
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
                    title: Text(S.of(context).receiveUpdates),
                    value: _user.receiveUpdates,
                    onChanged: (value) {
                      setState(() {
                        _user = _user.copyWith(receiveUpdates: value);
                      });
                    },
                  ),
                ),
                Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    title: Text(S.of(context).language),
                    trailing: DropdownButton<String>(
                      value: _user.preferredLanguage,
                      items: [
                        DropdownMenuItem(value: 'en', child: Text(S.of(context).english)),
                        DropdownMenuItem(value: 'es', child: Text(S.of(context).spanish)),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _user = _user.copyWith(preferredLanguage: newValue);
                          });
                          languageProvider.setLocale(Locale(newValue));
                        }
                      },
                    ),
                  ),
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    S.of(context).interests,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                ...availableInterests.map((interest) => Card(
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
                    child: Text(S.of(context).savePreferences),
                  ),
                ),
              ],
            ),
    );
  }
}