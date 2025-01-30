class AnggotaResponse {
  final String status;
  final String message;
  final UserData data;

  AnggotaResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AnggotaResponse.fromJson(Map<String, dynamic> json) {
    return AnggotaResponse(
      status: json['status'],
      message: json['message'],
      data: UserData.fromJson(json['data']),
    );
  }
}

class UserData {
  final int id;
  final String nama;
  final String namaRegu;
  final String namaProfesi;

  UserData({
    required this.id,
    required this.nama,
    required this.namaRegu,
    required this.namaProfesi,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      nama: json['nama'],
      namaRegu: json['nama_regu'],
      namaProfesi: json['nama_profesi'],
    );
  }
}

class AnggotaAllResponse {
  final String status;
  final String message;
  final List<AnggotaData> data;

  AnggotaAllResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AnggotaAllResponse.fromJson(Map<String, dynamic> json) {
    return AnggotaAllResponse(
      status: json['status'],
      message: json['message'],
      data: List<AnggotaData>.from(
        json['data'].map((x) => AnggotaData.fromJson(x)),
      ),
    );
  }
}

class AnggotaData {
  final int id;
  final String nama;
  final String namaRegu;
  final String namaProfesi;

  AnggotaData({
    required this.id,
    required this.nama,
    required this.namaRegu,
    required this.namaProfesi,
  });

  factory AnggotaData.fromJson(Map<String, dynamic> json) {
    return AnggotaData(
      id: json['id'],
      nama: json['nama'],
      namaRegu: json['nama_regu'],
      namaProfesi: json['nama_profesi'],
    );
  }
}
