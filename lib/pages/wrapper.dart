import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import User type from firebase_auth
import 'package:mypushnotifications/services/auth_service.dart';
import 'package:mypushnotifications/pages/home_page.dart';
import 'package:mypushnotifications/pages/login_page.dart';



class Wrapper extends StatelessWidget {
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: _authService.authStateChanges(), // This is Stream<User?>
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomePage(); // User is logged in
        } else {
          return LoginPage(); // User is not logged in
        }
      },
    );
  }
}
