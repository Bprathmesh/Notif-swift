import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mypushnotifications/pages/schedule_notification_page.dart';
import 'package:mypushnotifications/services/auth_service.dart';
import 'package:mypushnotifications/services/notification_service.dart';
import 'package:mypushnotifications/services/firebase_service.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mypushnotifications/generated/l10n.dart';
import '../phoenix.dart';
import 'package:provider/provider.dart';
import 'package:mypushnotifications/providers/theme_provider.dart';
import 'package:mypushnotifications/providers/language_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = AuthService();
  final NotificationService _notificationService = NotificationService();
  final FirebaseService _firebaseService = FirebaseService();
  bool _receiveNotifications = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _initializeNotifications();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  void _navigateToScheduleNotification() {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const ScheduleNotificationPage()),
  );
}

  void _toggleLanguage() {
    final languageProvider = Provider.of<LanguageProvider>(context, listen: false);
    Locale newLocale = languageProvider.currentLocale.languageCode == 'en' ? const Locale('es') : const Locale('en');
    languageProvider.setLocale(newLocale);
    Phoenix.rebirth(context);
  }

  void _toggleTheme() {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.toggleTheme();
  }

  Future<void> _initializeNotifications() async {
    try {
      await _notificationService.init();
      String? userId = _authService.getCurrentUser()?.uid;
      if (userId != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
        if (userDoc.exists && mounted) {
          setState(() {
            _receiveNotifications = userDoc.get('receiveNotifications') ?? false;
          });
        }
      }
    } catch (e) {
      print('Error initializing notifications: $e');
      if (mounted) {
        _showSnackBar(S.of(context).errorInitializingNotifications);
      }
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _receiveNotifications = value;
    });

    String? userId = _authService.getCurrentUser()?.uid;
    if (userId != null) {
      try {
        await _firestore.collection('users').doc(userId).update({
          'receiveNotifications': value,
        });

        if (value) {
          await _firebaseMessaging.subscribeToTopic('test_notifications');
        } else {
          await _firebaseMessaging.unsubscribeFromTopic('test_notifications');
        }
      } catch (e) {
        print('Error updating notification settings: $e');
        _showSnackBar(S.of(context).errorUpdatingNotificationSettings);
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await _authService.signOut();
      Navigator.pushReplacementNamed(context, '/sign_in');
    } catch (e) {
      print('Error signing out: $e');
      _showSnackBar(S.of(context).errorSigningOut);
    }
  }

  Future<void> _sendPersonalizedNotification() async {
    try {
      String? userId = _authService.getCurrentUser()?.uid;
      if (userId != null) {
        await _notificationService.sendPersonalizedNotification(
          userId: userId,
          title: S.of(context).personalizedNotificationTitle,
          body: S.of(context).personalizedNotificationBody,
          context: context,
        );
        _showSnackBar(S.of(context).personalizedNotificationSent);
      } else {
        _showSnackBar(S.of(context).userNotLoggedIn);
      }
    } catch (e) {
      print('Error sending personalized notification: $e');
      _showSnackBar(S.of(context).errorSendingPersonalizedNotification);
    }
  }

  Future<void> _sendPromotionalNotification() async {
    try {
      await _notificationService.sendPromotionalNotification(context);
      _showSnackBar(S.of(context).promotionalNotificationSent);
    } catch (e) {
      print('Error sending promotional notification: $e');
      _showSnackBar(S.of(context).errorSendingPromotionalNotification);
    }
  }

  Future<void> _sendUpdateNotification() async {
    try {
      await _notificationService.sendUpdateNotification(context);
      _showSnackBar(S.of(context).updateNotificationSent);
    } catch (e) {
      print('Error sending update notification: $e');
      _showSnackBar(S.of(context).errorSendingUpdateNotification);
    }
  }

  
  void _showSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Widget _buildNotificationButton(String text, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(text),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final languageProvider = Provider.of<LanguageProvider>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).homePage, style: const TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: _toggleTheme,
            tooltip: S.of(context).changeTheme,
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: _toggleLanguage,
            tooltip: S.of(context).changeLanguage,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _signOut,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).pushNamed('/preferences');
            },
          ),
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: FadeTransition(
        opacity: _animation,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).primaryColor,
                themeProvider.isDarkMode ? Colors.black : Colors.white,
              ],
            ),
          ),
          child: AnimationLimiter(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: <Widget>[
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: SwitchListTile(
                      title: Text(S.of(context).receiveNotifications, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      value: _receiveNotifications,
                      onChanged: _toggleNotifications,
                      secondary: Icon(Icons.notifications, color: Theme.of(context).primaryColor),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.history),
                    label: Text(S.of(context).viewNotificationHistory),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/notification_history');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(S.of(context).sendTestNotifications, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  _buildNotificationButton(
                     S.of(context).scheduleNewNotification,
                    Icons.schedule,
                     _navigateToScheduleNotification,
                  ),
                  const SizedBox(height: 10),
                  _buildNotificationButton(
                    S.of(context).sendPromotionalNotification,
                    Icons.local_offer,
                    _sendPromotionalNotification,
                  ),
                  const SizedBox(height: 10),
                  _buildNotificationButton(
                    S.of(context).sendUpdateNotification,
                    Icons.update,
                    _sendUpdateNotification,
                  ),
                  const SizedBox(height: 10),
                  _buildNotificationButton(
                   S.of(context).scheduleNewNotification,
                    Icons.schedule,
                     _navigateToScheduleNotification,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}