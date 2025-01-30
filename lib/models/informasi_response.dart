class InformasiListResponse {
  final String status;
  final String message;
  final List<Informasi> data;

  InformasiListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory InformasiListResponse.fromJson(Map<String, dynamic> json) {
    return InformasiListResponse(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List)
          .map((item) => Informasi.fromJson(
              item)) // Mengonversi data menjadi List<Informasi>
          .toList(),
    );
  }
}

class Informasi {
  final int id;
  final String gambar;
  final String createdAt;

  Informasi({
    required this.id,
    required this.gambar,
    required this.createdAt,
  });

  factory Informasi.fromJson(Map<String, dynamic> json) {
    return Informasi(
      id: json['id'],
      gambar: json['gambar'],
      createdAt: json['created_at'],
    );
  }
}

class InformasiDetailResponse {
  final String status;
  final String message;
  final InformasiDetail data;

  InformasiDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory InformasiDetailResponse.fromJson(Map<String, dynamic> json) {
    return InformasiDetailResponse(
      status: json['status'],
      message: json['message'],
      data: InformasiDetail.fromJson(
          json['data']), // Memastikan 'data' adalah InformasiDetail
    );
  }
}

class InformasiDetail {
  final int id;
  final String gambar;
  final String bawaan;
  final String kebarangkatan;
  final String jamSampai; // Gunakan camelCase untuk nama variabel
  final String regu;
  final String createdAt;

  InformasiDetail({
    required this.id,
    required this.gambar,
    required this.bawaan,
    required this.kebarangkatan,
    required this.jamSampai,
    required this.regu,
    required this.createdAt,
  });

  factory InformasiDetail.fromJson(Map<String, dynamic> json) {
    return InformasiDetail(
      id: json['id'],
      gambar: json['gambar'],
      bawaan: json['bawaan'],
      kebarangkatan: json['kebarangkatan'],
      jamSampai:
          json['jam_sampai'], // Sesuaikan dengan nama key yang ada di JSON
      regu: json['regu'],
      createdAt: json['created_at'],
    );
  }
}
