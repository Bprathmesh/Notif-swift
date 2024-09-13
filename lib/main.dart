import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mypushnotifications/generated/l10n.dart';
import 'pages/home_page.dart';
import 'pages/sign_in_page.dart';
import 'pages/register_page.dart';
import 'pages/notification_history_page.dart';
import 'pages/preferences_page.dart';
import 'pages/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart';
import 'phoenix.dart';
import 'package:provider/provider.dart';
import 'package:mypushnotifications/providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const Phoenix(child: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Notification App',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: const Locale('en'),
          initialRoute: '/',
          routes: {
            '/': (context) => const Wrapper(),
            '/home': (context) => const HomePage(),
            '/sign_in': (context) => const SignInPage(),
            '/register': (context) => const RegisterPage(),
            '/notification_history': (context) => NotificationHistoryPage(),
            '/preferences': (context) => const PreferencesPage(),
          },
        );
      },
    );
  }
}