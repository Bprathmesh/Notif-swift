import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  Locale _currentLocale = const Locale('en');

  LanguageProvider() {
    loadSavedLocale();
  }

  Locale get currentLocale => _currentLocale;

  Future<void> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final String languageCode = prefs.getString('languageCode') ?? 'en';
    setLocale(Locale(languageCode));
  }

  void setLocale(Locale locale) {
    if (!['en', 'es'].contains(locale.languageCode)) return;
    _currentLocale = locale;
    _saveLocale(locale.languageCode);
    notifyListeners();
  }

  Future<void> _saveLocale(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
  }
}