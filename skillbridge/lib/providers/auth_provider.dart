import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

/// Exposes authentication state to the widget tree using the
/// `ChangeNotifier` + `provider` pattern taught for Flutter state
/// management.
class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  UserModel? _currentUser;
  AuthStatus _status = AuthStatus.unknown;
  String? _errorMessage;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  AuthStatus get status => _status;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  Future<void> restoreSession() async {
    final user = await _authService.getCurrentUser();
    _currentUser = user;
    _status = user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _setLoading(true);
    try {
      final user = await _authService.login(email: email, password: password);
      _currentUser = user;
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
    required String location,
  }) async {
    _setLoading(true);
    try {
      final user = await _authService.signUp(
        name: name,
        email: email,
        password: password,
        location: location,
      );
      _currentUser = user;
      _status = AuthStatus.authenticated;
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfile(UserModel updated) async {
    await _authService.updateUser(updated);
    _currentUser = updated;
    notifyListeners();
  }

  Future<void> toggleFavorite(String skillId) async {
    final user = _currentUser;
    if (user == null) return;
    if (user.favoriteListingIds.contains(skillId)) {
      user.favoriteListingIds.remove(skillId);
    } else {
      user.favoriteListingIds.add(skillId);
    }
    await _authService.updateUser(user);
    notifyListeners();
  }

  bool isFavorite(String skillId) =>
      _currentUser?.favoriteListingIds.contains(skillId) ?? false;

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
