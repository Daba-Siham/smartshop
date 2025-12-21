import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("darkMode", isDark);
  }

  Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("darkMode") ?? false;
  }
}
