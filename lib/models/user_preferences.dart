import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class UserPreferences extends ChangeNotifier {
  bool _receiveNotifications = false;
  bool _receivePromotions = false;
  bool _receiveUpdates = false;
  List<String> _interests = [];

  bool get receiveNotifications => _receiveNotifications;
  bool get receivePromotions => _receivePromotions;
  bool get receiveUpdates => _receiveUpdates;
  List<String> get interests => _interests;

  void updatePreferences({
      bool? receiveNotifications,
      bool? receivePromotions,
      bool? receiveUpdates,
      List<String>? interests,
    }) {
      _receiveNotifications = receiveNotifications ?? _receiveNotifications;
      _receivePromotions = receivePromotions ?? _receivePromotions;
      _receiveUpdates = receiveUpdates ?? _receiveUpdates;
      _interests = interests ?? _interests;
      notifyListeners();
      print('Preferences updated: $_receiveNotifications, $_receivePromotions, $_receiveUpdates');
}

  Future<void> loadPreferences(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> data = userDoc.data() as Map<String, dynamic>;
        _receiveNotifications = data['receiveNotifications'] ?? false;
        _receivePromotions = data['receivePromotions'] ?? false;
        _receiveUpdates = data['receiveUpdates'] ?? false;
        _interests = List<String>.from(data['interests'] ?? []);
        notifyListeners();
        print('Preferences loaded: $_receiveNotifications, $_receivePromotions, $_receiveUpdates');
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Error loading user preferences: $e');
    }
  }

  Future<void> savePreferences(String userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'receiveNotifications': _receiveNotifications,
        'receivePromotions': _receivePromotions,
        'receiveUpdates': _receiveUpdates,
        'interests': _interests,
      });
      print('Preferences saved: $_receiveNotifications, $_receivePromotions, $_receiveUpdates');
    } catch (e) {
      print('Error saving user preferences: $e');
    }
  }
}
