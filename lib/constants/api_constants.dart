// lib/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'http://192.168.168.119:8000/api';
  static const String baseImageUrl = 'http://192.168.168.119:8000/storage/';

  // Endpoint untuk Autentikasi
  static const String loginEndpoint = '/login';
  static const String userEndpoint = '/user';
  static const String resetPasswordEndpoint = '/reset-password';
  static const String logoutEndpoint = '/logout';

  // Endpoint untuk Informasi
  static const String informasiEndpoint = '/informasi';

  // Endpoint untuk absensi
  static const String absensiEndpoint = '/absensi';

  // Endpoint untuk get data anggota login
  static const String anggotaEndpoint = '/anggota/current';
  // Endpoint untuk get semua data anggota
  static const String allanggotaEndpoint = '/anggota/all';

  // Endpoint untuk get data slip gaji
  static const String slipgajiEndpoint = '/slip-gaji';

  // Endpoint untuk get list data informasi
  static const String listEndpoint = '/informasi';
  // Endpoint untuk get detail data informasi
  static const String detailEndpoint = '/informasi/{id}';
}
