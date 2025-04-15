import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ValueNotifier<Locale> {
  LocaleProvider() : super(const Locale('pt', 'BR')) {
    _loadLocale();
  }

  Locale get locale => value;
  bool get isPortuguese => value.languageCode == 'pt';
  bool get isEnglish => value.languageCode == 'en';

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'pt';
    final countryCode = prefs.getString('country_code') ?? 'BR';

    value = Locale(languageCode, countryCode);
  }

  Future<void> setLocale(Locale locale) async {
    if (value == locale) return;

    value = locale;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
    await prefs.setString('country_code', locale.countryCode ?? '');
  }

  bool isCurrentLocale(Locale locale) {
    return value.languageCode == locale.languageCode && value.countryCode == locale.countryCode;
  }
}
