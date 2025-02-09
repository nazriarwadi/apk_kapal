class Anggota {
  final int id;
  final String nama;
  final String noTelp;
  final String email;
  final String? password; // Hanya untuk update, tidak dikirim dari API
  final int reguId;
  final int profesiId;
  final String createdAt;
  final String updatedAt;

  Anggota({
    required this.id,
    required this.nama,
    required this.noTelp,
    required this.email,
    this.password,
    required this.reguId,
    required this.profesiId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Anggota.fromJson(Map<String, dynamic> json) {
    return Anggota(
      id: json['id'],
      nama: json['nama'],
      noTelp: json['no_telp'],
      email: json['email'],
      password: json['password'],
      reguId: json['regu_id'],
      profesiId: json['profesi_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'no_telp': noTelp,
      'email': email,
      'password': password,
      'regu_id': reguId,
      'profesi_id': profesiId,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class LoginResponse {
  final String status;
  final String message;
  final String? token;
  final Anggota? anggota;
  final String? bannedUntil; // Tambahan untuk menangani respons banned

  LoginResponse({
    required this.status,
    required this.message,
    this.token,
    this.anggota,
    this.bannedUntil,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      status: json['status'],
      message: json['message'],
      token: json['data']?['token'], // Cegah error jika `data` tidak ada
      anggota: json['data']?['anggota'] != null
          ? Anggota.fromJson(json['data']['anggota'])
          : null,
      bannedUntil:
          json.containsKey('banned_until') ? json['banned_until'] : null,
    );
  }
}

class UserResponse {
  final String status;
  final String message;
  final Anggota? anggota;

  UserResponse({
    required this.status,
    required this.message,
    this.anggota,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      status: json['status'],
      message: json['message'],
      anggota: Anggota.fromJson(json['data']['anggota']),
    );
  }
}

class ResetPasswordResponse {
  final String status;
  final String message;

  ResetPasswordResponse({
    required this.status,
    required this.message,
  });

  factory ResetPasswordResponse.fromJson(Map<String, dynamic> json) {
    return ResetPasswordResponse(
      status: json['status'],
      message: json['message'],
    );
  }
}
