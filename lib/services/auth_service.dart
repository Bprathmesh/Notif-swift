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
  Future<void> deleteUser(String userId) async {
    try {
      // Get an instance of FirebaseAuth
      FirebaseAuth auth = FirebaseAuth.instance;

      // Get the current user
      User? currentUser = auth.currentUser;

      if (currentUser != null && currentUser.uid == userId) {
        // If the user to be deleted is the current user, delete them directly
        await currentUser.delete();
      } else {
        // If it's a different user, you'll need admin SDK or Cloud Functions
        // This is just a placeholder - implement your server-side logic here
        throw Exception('Deleting other users requires admin privileges');
      }
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
