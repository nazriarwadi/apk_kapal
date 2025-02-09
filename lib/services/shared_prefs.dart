import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _tokenKey = 'auth_token';
  static const String _bannedKey = 'is_banned';

  // Simpan token ke SharedPreferences
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Ambil token dari SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Hapus token dari SharedPreferences (untuk logout)
  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Simpan status banned
  static Future<void> setIsBanned(bool banned) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_bannedKey, banned);
  }

  // Ambil status banned
  static Future<bool> getIsBanned() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_bannedKey) ?? false;
  }

  // Hapus semua data (logout)
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
