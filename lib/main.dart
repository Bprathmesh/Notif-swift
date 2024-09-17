import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mypushnotifications/generated/l10n.dart';
import 'package:mypushnotifications/pages/admin_page.dart';
import 'package:mypushnotifications/pages/home_page.dart';
import 'package:mypushnotifications/pages/sign_in_page.dart';
import 'package:mypushnotifications/pages/register_page.dart';
import 'package:mypushnotifications/pages/notification_history_page.dart';
import 'package:mypushnotifications/pages/preferences_page.dart';
import 'package:mypushnotifications/pages/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart';
import 'phoenix.dart';
import 'package:provider/provider.dart';
import 'package:mypushnotifications/providers/theme_provider.dart';
import 'package:mypushnotifications/providers/language_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'firebase_options.dart';


// Conditional import for web
import 'utils/web_url_strategy.dart' if (dart.library.io) 'utils/stub_url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  if (kIsWeb) {
    // Use this for web support
    configureUrl();
  }
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await NotificationService().init();

  runApp(
    Phoenix(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
          ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeProvider, LanguageProvider>(
      builder: (context, themeProvider, languageProvider, child) {
        return MaterialApp(
          title: 'Notification App',
          theme: themeProvider.lightTheme,
          darkTheme: themeProvider.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
           debugShowCheckedModeBanner: false, 
          localizationsDelegates: const [
            S.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: S.delegate.supportedLocales,
          locale: languageProvider.currentLocale,
          initialRoute: '/',
          routes: {
            '/': (context) => const Wrapper(),
            '/home': (context) => const HomePage(),
            '/sign_in': (context) => const SignInPage(),
            '/register': (context) => const RegisterPage(),
            '/notification_history': (context) => const NotificationHistoryPage(),
            '/preferences': (context) => const PreferencesPage(),
            '/admin': (context) => const AdminPage()
          },
        );
      },
    );
  }
}