// lib/services/api_service.dart
import 'package:dio/dio.dart';
import '../models/attendance_response.dart';
import '../models/auth_models.dart'; // Import model autentikasi
import '../models/anggota_response.dart'; // Import konstanta API
import '../constants/api_constants.dart';
import '../models/informasi_response.dart';
import '../models/slip_gaji_response.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: ApiConstants.baseUrl));

  // Login
  Future<LoginResponse> login(String email, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint, // Menggunakan konstanta endpoint
        data: {
          'email': email,
          'password': password,
        },
      );

      // Jika login berhasil
      return LoginResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Menangani error dari Dio
      if (e.response != null) {
        final responseData = e.response!.data;
        final message =
            responseData['message'] ?? 'Terjadi kesalahan saat login';

        // Cek apakah akun dibanned
        if (responseData.containsKey('banned_until')) {
          final bannedUntil = responseData['banned_until'];
          throw Exception('$message\n$bannedUntil');
        }

        // Cek berbagai skenario error login
        if (message == 'Email tidak terdaftar') {
          throw Exception('Email tidak terdaftar');
        } else if (message == 'Password salah') {
          throw Exception('Password salah');
        } else {
          throw Exception(message);
        }
      } else {
        throw Exception('Tidak dapat terhubung ke server');
      }
    } catch (e) {
      throw Exception('Gagal melakukan login: $e');
    }
  }

  // Get User Data
  Future<UserResponse> getUser(String token) async {
    try {
      final response = await _dio.get(
        ApiConstants.userEndpoint, // Menggunakan konstanta endpoint
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return UserResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('Gagal mengambil data pengguna: $e');
    }
  }

  // Reset Password dengan Token
  Future<ResetPasswordResponse> resetPassword(
      String token, String email, String newPassword) async {
    try {
      final response = await _dio.post(
        ApiConstants.resetPasswordEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
        data: {
          'email': email,
          'new_password': newPassword,
        },
      );
      return ResetPasswordResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Gagal mereset password: ${e.response?.data}');
      } else {
        throw Exception('Gagal mereset password: ${e.message}');
      }
    }
  }

  // Fungsi untuk mendapatkan data absensi
  Future<AttendanceResponse> getAttendance(String token) async {
    try {
      final response = await _dio.get(
        ApiConstants.absensiEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Konversi response JSON ke model AttendanceResponse
      return AttendanceResponse.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Gagal mengambil data absensi: ${e.response?.data}');
      } else {
        throw Exception('Gagal mengambil data absensi: ${e.message}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk mengambil data anggota yang sedang login menggunakan token
  Future<AnggotaResponse> getCurrentAnggota(String token) async {
    try {
      final response = await _dio.get(
        ApiConstants.anggotaEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Konversi response JSON ke model AnggotaResponse
      return AnggotaResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Handle error dari Dio
      if (e.response != null) {
        throw Exception('Gagal mengambil data anggota: ${e.response?.data}');
      } else {
        throw Exception('Gagal mengambil data anggota: ${e.message}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk mengambil semua data anggota menggunakan token
  Future<AnggotaAllResponse> getAllAnggota(String token) async {
    try {
      final response = await _dio.get(
        ApiConstants.allanggotaEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Konversi response JSON ke model AnggotaAllResponse
      return AnggotaAllResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Handle error dari Dio
      if (e.response != null) {
        throw Exception(
            'Gagal mengambil semua data anggota: ${e.response?.data}');
      } else {
        throw Exception('Gagal mengambil semua data anggota: ${e.message}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Fungsi untuk mengambil data slip gaji menggunakan token
  Future<SlipGajiResponse> getSlipGaji(String token) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.baseUrl}${ApiConstants.slipgajiEndpoint}',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Gunakan fromMap karena response.data sudah berupa Map
      return SlipGajiResponse.fromMap(response.data);
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Gagal mengambil data slip gaji: ${e.response?.data}');
      } else {
        throw Exception('Gagal mengambil data slip gaji: ${e.message}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Get Informasi List
  Future<InformasiListResponse> getAllInformasi(String token) async {
    try {
      final response = await _dio.get(
        ApiConstants.listEndpoint, // Gunakan endpoint untuk list informasi
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Konversi response JSON ke model InformasiListResponse
      return InformasiListResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Handle error dari Dio
      if (e.response != null) {
        throw Exception(
            'Gagal mengambil semua data informasi: ${e.response?.data}');
      } else {
        throw Exception('Gagal mengambil semua data informasi: ${e.message}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Get Informasi Detail
  Future<InformasiDetailResponse> getInformasiDetail(
      String token, int id) async {
    try {
      final response = await _dio.get(
        ApiConstants.detailEndpoint.replaceFirst(
            '{id}', id.toString()), // Ganti {id} dengan nilai sebenarnya
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      // Konversi response JSON ke model InformasiDetailResponse
      return InformasiDetailResponse.fromJson(response.data);
    } on DioException catch (e) {
      // Handle error dari Dio
      if (e.response != null) {
        throw Exception(
            'Gagal mengambil detail informasi: ${e.response?.data}');
      } else {
        throw Exception('Gagal mengambil detail informasi: ${e.message}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}
