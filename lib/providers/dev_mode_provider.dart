import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DevModeProvider extends ChangeNotifier {
  static const _devModeKey = 'dev_mode_enabled';
  static const _passKeyKey = 'dev_mode_passkey';

  bool _enabled = false;
  String _passkey = '1234'; // القيمة الافتراضية

  bool get enabled => _enabled;
  String get passkey => _passkey;

  DevModeProvider() {
    _loadFromPrefs();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(_devModeKey) ?? false;
    _passkey = prefs.getString(_passKeyKey) ?? 'eager';
    notifyListeners();
  }

  Future<void> enable(String inputPasskey) async {
    if (inputPasskey == _passkey) {
      _enabled = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_devModeKey, true);
      notifyListeners();
    }
  }

  Future<void> disable() async {
    _enabled = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_devModeKey, false);
    notifyListeners();
  }

  Future<void> changePasskey(String newPasskey) async {
    _passkey = newPasskey;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_passKeyKey, newPasskey);
    notifyListeners();
  }
}
