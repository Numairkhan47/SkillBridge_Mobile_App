import 'dart:convert';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import '../utils/dummy_data.dart';
import 'storage_service.dart';

/// Handles registration/login/session for the demo app.
///
/// Mirrors how a real auth service (Firebase Auth, or a custom
/// JWT-based REST API) would be wired in: the [AuthProvider] never
/// needs to know whether `login()` is hitting a local list or a real
/// network call, it just awaits the [Future].
class AuthService {
  static const _usersKey = 'skillbridge_users';
  static const _sessionKey = 'skillbridge_session_user_id';
  static const _uuid = Uuid();

  Future<List<UserModel>> _loadUsers() async {
    final raw = StorageService.readJsonList(_usersKey);
    if (raw.isEmpty) {
      final seed = DummyData.seedUsers();
      await StorageService.saveJsonList(_usersKey, seed.map((u) => u.toJson()).toList());
      return seed;
    }
    return raw.map(UserModel.fromJson).toList();
  }

  Future<void> _saveUsers(List<UserModel> users) {
    return StorageService.saveJsonList(_usersKey, users.map((u) => u.toJson()).toList());
  }

  /// Attempts to restore a previously logged-in session.
  Future<UserModel?> getCurrentUser() async {
    final id = StorageService.readString(_sessionKey);
    if (id == null) return null;
    final users = await _loadUsers();
    try {
      return users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<UserModel> login({required String email, required String password}) async {
    final users = await _loadUsers();
    final match = users.where(
      (u) => u.email.toLowerCase() == email.trim().toLowerCase() && u.password == password,
    );
    if (match.isEmpty) {
      throw Exception('Invalid email or password.');
    }
    final user = match.first;
    await StorageService.saveString(_sessionKey, user.id);
    return user;
  }

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String location,
  }) async {
    final users = await _loadUsers();
    final exists = users.any((u) => u.email.toLowerCase() == email.trim().toLowerCase());
    if (exists) {
      throw Exception('An account with this email already exists.');
    }
    final newUser = UserModel(
      id: _uuid.v4(),
      name: name.trim(),
      email: email.trim(),
      password: password,
      location: location.trim().isEmpty ? 'Rawalpindi, Pakistan' : location.trim(),
      avatarColorHex: _randomColorHex(users.length),
    );
    users.add(newUser);
    await _saveUsers(users);
    await StorageService.saveString(_sessionKey, newUser.id);
    return newUser;
  }

  Future<void> updateUser(UserModel updated) async {
    final users = await _loadUsers();
    final index = users.indexWhere((u) => u.id == updated.id);
    if (index != -1) {
      users[index] = updated;
      await _saveUsers(users);
    }
  }

  Future<void> logout() async {
    await StorageService.remove(_sessionKey);
  }

  String _randomColorHex(int seed) {
    const palette = [
      '#6C5CE7',
      '#00B894',
      '#E17055',
      '#0984E3',
      '#D63031',
      '#E84393',
      '#00CEC9',
      '#FDCB6E',
    ];
    return palette[seed % palette.length];
  }
}

/// Helper to make jsonEncode usable for a single map (used sparingly).
String encodeMap(Map<String, dynamic> map) => jsonEncode(map);
