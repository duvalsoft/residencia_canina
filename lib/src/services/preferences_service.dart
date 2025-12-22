
// lib/src/services/preferences_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static SharedPreferences? _prefs;
  static const _secureStorage = FlutterSecureStorage();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveCredentials({
    required String baseUrl,
    required String database,
    required String username,
    required String password,
  }) async {
    await _prefs?.setString('baseUrl', baseUrl);
    await _prefs?.setString('database', database);
    await _prefs?.setString('username', username);
    await _secureStorage.write(key: 'password', value: password);
  }

  static Future<Map<String, String>> getCredentials() async {
    final password = await _secureStorage.read(key: 'password') ?? '';
    return {
      'baseUrl': _prefs?.getString('baseUrl') ?? 'https://tumburu.es',
      'database': _prefs?.getString('database') ?? '',
      'username': _prefs?.getString('username') ?? '',
      'password': password,
    };
  }

  static Future<bool> hasCredentials() async {
    final db = _prefs?.getString('database');
    final user = _prefs?.getString('username');
    final password = await _secureStorage.read(key: 'password');
    return db != null &&
        db.isNotEmpty &&
        user != null &&
        user.isNotEmpty &&
        password != null &&
        password.isNotEmpty;
  }

  static Future<void> clearCredentials() async {
    await _prefs?.remove('baseUrl');
    await _prefs?.remove('database');
    await _prefs?.remove('username');
    await _secureStorage.delete(key: 'password');
  }
}
