import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ValueNotifier<ThemeMode> {
  ThemeProvider() : super(ThemeMode.dark) {
    _loadThemeMode();
  }

  ThemeMode get themeMode => value;
  bool get isDarkMode => value == ThemeMode.dark;

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('theme_mode') ?? 2;
    value = ThemeMode.values[themeModeIndex];
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (value == mode) return;

    value = mode;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('theme_mode', mode.index);
  }

  Future<void> toggleTheme() async {
    if (value == ThemeMode.light) {
      await setThemeMode(ThemeMode.dark);
    } else if (value == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      if (brightness == Brightness.dark) {
        await setThemeMode(ThemeMode.light);
      } else {
        await setThemeMode(ThemeMode.dark);
      }
    }
  }

  Future<void> useSystemTheme() async {
    await setThemeMode(ThemeMode.system);
  }
}
