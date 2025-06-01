import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';
import 'db_helper.dart';

class SessionManager with ChangeNotifier {
  User? _currentUser;

  User? get user => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isAdmin => _currentUser?.role == 'admin';

  static const String _userCodeKey = 'user_code';

  Future<void> login(User user) async {
    _currentUser = user;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userCodeKey, user.code);
  }

  Future<void> logout() async {
    _currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userCodeKey);
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_userCodeKey)) return;

    final code = prefs.getString(_userCodeKey);
    if (code == null) return;

    final user = await DBHelper().getUserByCode(code);
    if (user != null) {
      _currentUser = user;
      notifyListeners();
    }
  }
}
