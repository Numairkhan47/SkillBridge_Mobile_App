import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around [SharedPreferences] used as a lightweight, fully
/// offline "backend" for the app. Every repository in this project talks
/// to this class instead of touching `SharedPreferences` directly, which
/// keeps persistence logic in one testable place and makes it trivial to
/// later swap in a real backend (REST API / Firebase) without touching
/// the UI layer at all.
class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static SharedPreferences get _instance {
    if (_prefs == null) {
      throw StateError('StorageService.init() must be called before use.');
    }
    return _prefs!;
  }

  // ---- Generic helpers ----

  static Future<void> saveJsonList(String key, List<Map<String, dynamic>> items) {
    return _instance.setString(key, jsonEncode(items));
  }

  static List<Map<String, dynamic>> readJsonList(String key) {
    final raw = _instance.getString(key);
    if (raw == null) return [];
    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }

  static Future<void> saveString(String key, String value) => _instance.setString(key, value);

  static String? readString(String key) => _instance.getString(key);

  static Future<void> saveBool(String key, bool value) => _instance.setBool(key, value);

  static bool readBool(String key, {bool defaultValue = false}) =>
      _instance.getBool(key) ?? defaultValue;

  static Future<void> remove(String key) => _instance.remove(key);
}
