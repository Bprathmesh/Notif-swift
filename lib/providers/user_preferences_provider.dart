import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserPreferencesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _receiveNotifications = false;
  bool _receivePromotions = false;
  bool _receiveUpdates = false;
  List<String> _interests = [];

  bool get receiveNotifications => _receiveNotifications;
  bool get receivePromotions => _receivePromotions;
  bool get receiveUpdates => _receiveUpdates;
  List<String> get interests => _interests;

  Future<void> loadUserPreferences() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
          _receiveNotifications = userData['receiveNotifications'] ?? false;
          _receivePromotions = userData['receivePromotions'] ?? false;
          _receiveUpdates = userData['receiveUpdates'] ?? false;
          _interests = List<String>.from(userData['interests'] ?? []);
          notifyListeners();
        }
      } catch (e) {
        print('Error loading user preferences: $e');
      }
    }
  }

  Future<void> updatePreferences({
    bool? receiveNotifications,
    bool? receivePromotions,
    bool? receiveUpdates,
    List<String>? interests,
  }) async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        Map<String, dynamic> updateData = {};
        if (receiveNotifications != null) {
          _receiveNotifications = receiveNotifications;
          updateData['receiveNotifications'] = receiveNotifications;
        }
        if (receivePromotions != null) {
          _receivePromotions = receivePromotions;
          updateData['receivePromotions'] = receivePromotions;
        }
        if (receiveUpdates != null) {
          _receiveUpdates = receiveUpdates;
          updateData['receiveUpdates'] = receiveUpdates;
        }
        if (interests != null) {
          _interests = interests;
          updateData['interests'] = interests;
        }

        await _firestore.collection('users').doc(user.uid).update(updateData);
        notifyListeners();
      } catch (e) {
        print('Error updating user preferences: $e');
      }
    }
  }
}