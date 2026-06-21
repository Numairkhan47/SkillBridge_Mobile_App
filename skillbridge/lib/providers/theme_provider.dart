import 'package:flutter/material.dart';
import '../services/storage_service.dart';

/// Lets the user toggle between light and dark mode from the Settings
/// screen, persisting the choice across app restarts.
class ThemeProvider extends ChangeNotifier {
  static const _key = 'skillbridge_dark_mode';

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;
  ThemeMode get themeMode => _isDarkMode ? ThemeMode.dark : ThemeMode.light;

  ThemeProvider() {
    _isDarkMode = StorageService.readBool(_key);
  }

  Future<void> toggle(bool value) async {
    _isDarkMode = value;
    await StorageService.saveBool(_key, value);
    notifyListeners();
  }
}
