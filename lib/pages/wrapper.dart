import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mypushnotifications/pages/home_page.dart';
import 'package:mypushnotifications/pages/sign_in_page.dart';
import 'package:provider/provider.dart';
import 'package:mypushnotifications/providers/theme_provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  themeProvider.isDarkMode ? Colors.white : Colors.blue,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasData) {
          return const HomePage();
        } else {
          return const SignInPage();
        }
      },
    );
  }
}