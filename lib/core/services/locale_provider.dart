import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('pt', 'BR');

  Locale get locale => _locale;

  LocaleProvider() {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'pt';
    final countryCode = prefs.getString('country_code') ?? 'BR';

    _locale = Locale(languageCode, countryCode);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');
  }

  bool isCurrentLocale(Locale locale) {
    return _locale.languageCode == locale.languageCode && _locale.countryCode == locale.countryCode;
  }

  bool get isPortuguese => _locale.languageCode == 'pt';
  bool get isEnglish => _locale.languageCode == 'en';
}
