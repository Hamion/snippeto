
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  SharedPreferences? _preferences;

  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _initTheme();
  }

  Future<void> _initTheme() async {
    _preferences = await SharedPreferences.getInstance();
    final themeModeString = _preferences!.getString('themeMode');
    if (themeModeString != null) {
      _themeMode = _getThemeModeFromString(themeModeString);
    }
    notifyListeners();
  }

  Future<void> setThemeMode(Object? themeMode) async {
    if (themeMode is ThemeMode) {
      _themeMode = themeMode;
      await _preferences!
          .setString('themeMode', _getThemeModeString(themeMode));
      notifyListeners();
    }
  }

  ThemeMode _getThemeModeFromString(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  String _getThemeModeString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}