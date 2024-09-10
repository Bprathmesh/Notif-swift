import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> getCurrentUser() async {
    return _auth.currentUser;
  }

  Future<void> saveUserPreferences(String userId, bool receivePromotions) async {
    await _firestore.collection('users').doc(userId).set({
      'receivePromotions': receivePromotions,
    }, SetOptions(merge: true));
  }
}
