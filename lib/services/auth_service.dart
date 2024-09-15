import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import the User type here

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Method to register a user using email and password
  Future<User?> registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } catch (e) {
      print('Registration error: $e');
      return null;
    }
  }

  // Method to sign in a user using email and password
  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = result.user;
      return user;
    } catch (e) {
      print('Sign in error: $e');
      return null;
    }
  }
  Future<bool> isUserAdmin(String userId) async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        return userData['isAdmin'] ?? false;
      }
      return false;
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }
  Future<void> updateAdminStatus(String userId, bool isAdmin) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'isAdmin': isAdmin});
    } catch (e) {
      print('Error updating admin status: $e');
      throw Exception('Failed to update admin status');
    }
  }
 Future<void> deleteUser(String userId) async {
    try {
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('No user is currently logged in');
      }

      bool isAdmin = await isUserAdmin(currentUser.uid);
      if (!isAdmin && currentUser.uid != userId) {
        throw Exception('Only admins can delete other users');
      }

      // Delete user from Firebase Authentication
      if (currentUser.uid == userId) {
        await currentUser.delete();
      } else {
        // For deleting other users, you'll need to use Firebase Admin SDK on the server side
        // Here, we'll just delete the user document from Firestore
        await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      }

      // Delete user document from Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();

    } catch (e) {
      print('Error deleting user: $e');
      rethrow;
    }
  }
  // Method to sign out the current user
  Future<void> signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch (e) {
      print('Sign out error: $e');
    }
  }

  // Method to check the current user (for auto-login)
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Method to listen to authentication state changes
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges(); // Ensure this returns Stream<User?>
  }
}
