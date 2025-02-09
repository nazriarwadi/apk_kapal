import 'package:dio/dio.dart';
import '../models/notifikasi_response.dart';
import '../services/local_storage_service.dart';
import '../constants/api_constants.dart';

class NotificationService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  // Metode untuk memeriksa notifikasi absensi
  Future<CheckNewAbsensiResponse> checkNewAbsensi(String token) async {
    try {
      // Ambil last_checked dari SharedPreferences dalam format timestamp (detik)
      int lastCheckedTimestamp = await LocalStorageService.getLastChecked();

      // Jika last_checked belum ada, gunakan timestamp saat ini
      if (lastCheckedTimestamp == 0) {
        lastCheckedTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      }

      // Kirim last_checked sebagai parameter dalam detik
      final response = await _dio.get(
        ApiConstants.checkNewAbsensiEndpoint,
        queryParameters: {'last_checked': lastCheckedTimestamp},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Jika berhasil, update last_checked ke waktu saat ini (sekarang)
      await LocalStorageService.saveLastChecked(
          DateTime.now().millisecondsSinceEpoch ~/ 1000);

      return CheckNewAbsensiResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        final message = e.response!.data['message'] ??
            'Terjadi kesalahan saat memeriksa notifikasi';
        throw Exception(message);
      } else {
        throw Exception('Tidak dapat terhubung ke server');
      }
    } catch (e) {
      throw Exception('Gagal memeriksa notifikasi: $e');
    }
  }
}
