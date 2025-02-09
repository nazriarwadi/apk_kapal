import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _lastCheckedKey = 'last_checked';

  // Simpan waktu terakhir dicek dalam format timestamp (detik)
  static Future<void> saveLastChecked(int timestamp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastCheckedKey, timestamp);
  }

  // Ambil waktu terakhir dicek, default ke 0 jika belum ada
  static Future<int> getLastChecked() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_lastCheckedKey) ?? 0;
  }

  // Hapus timestamp terakhir (jika diperlukan)
  static Future<void> clearLastChecked() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastCheckedKey);
  }
}
