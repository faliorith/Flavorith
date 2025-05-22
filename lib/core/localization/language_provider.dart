import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageProvider with ChangeNotifier {
  static const String _languageKey = 'language';
  late SharedPreferences _prefs;
  String _currentLanguage = 'Русский';

  String get currentLanguage => _currentLanguage;

  Locale get currentLocale {
    switch (_currentLanguage) {
      case 'English':
        return const Locale('en', '');
      case 'Español':
        return const Locale('es', '');
      case 'Русский':
      default:
        return const Locale('ru', '');
    }
  }

  LanguageProvider() {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    _prefs = await SharedPreferences.getInstance();
    _currentLanguage = _prefs.getString(_languageKey) ?? 'Русский';
    notifyListeners();
  }

  Future<void> setLanguage(String language) async {
    _currentLanguage = language;
    await _prefs.setString(_languageKey, language);
    notifyListeners();
  }
} 