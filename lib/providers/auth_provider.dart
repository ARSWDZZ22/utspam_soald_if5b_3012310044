import 'package:flutter/material.dart';
import 'package:utspam_soald_if5b_3012310044/models/user.dart';
import 'package:utspam_soald_if5b_3012310044/services/storage_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

  Future<void> loadUserFromStorage() async {
    _user = StorageService.getUser();
    notifyListeners();
  }

  Future<void> login(String username, String password) async {
    _setLoading(true);
    try {
      final storedUser = StorageService.getUser();
      if (storedUser != null &&
          storedUser.username == username &&
          storedUser.password == password) {
        _user = storedUser;
        notifyListeners();
      } else {
        throw Exception('Username atau Password salah');
      }
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(User user) async {
    _setLoading(true);
    try {
      await StorageService.saveUser(user);
      _user = user;
      notifyListeners();
    } catch (e) {
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    await StorageService.clearAllData();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
