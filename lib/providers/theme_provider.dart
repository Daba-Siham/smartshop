import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDark = false;
  double _fontScale = 1.0; // 1.0 = taille normale

  bool get isDark => _isDark;
  double get fontScale => _fontScale;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('darkmode') ?? false;
    _fontScale = prefs.getDouble('fontScale') ?? 1.0;
    notifyListeners();
  }

  Future<void> toggleTheme(bool value) async {
    _isDark = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkmode', _isDark);
  }

  Future<void> setFontScale(double value) async {
    _fontScale = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontScale', _fontScale);
  }
}
