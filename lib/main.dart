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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await NotificationService().init();
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: const Locale('es'),
      initialRoute: '/',
      routes: {
        '/': (context) => Wrapper(),
        '/home': (context) => HomePage(),
        '/sign_in': (context) => SignInPage(),
        '/register': (context) => RegisterPage(),
        '/notification_history': (context) => NotificationHistoryPage(),
        '/preferences': (context) => PreferencesPage(),
      },
    );
  }
}