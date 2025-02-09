class AttendanceResponse {
  final String status;
  final String message;
  final List<AttendanceData> data;
  final int totalHadir;
  final int totalIzin;
  final int totalLembur;

  AttendanceResponse({
    required this.status,
    required this.message,
    required this.data,
    required this.totalHadir,
    required this.totalIzin,
    required this.totalLembur,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => AttendanceData.fromJson(item))
          .toList(),
      totalHadir: json['total_hadir'] as int,
      totalIzin: json['total_izin'] as int,
      totalLembur: json['total_lembur'] as int,
    );
  }
}

class AttendanceData {
  final String namaAnggota;
  final String namaProfesi;
  final String namaRegu;
  final String tanggalAbsensi;
  final int? hadir;
  final int? izin;
  final int? lembur;

  AttendanceData({
    required this.namaAnggota,
    required this.namaProfesi,
    required this.namaRegu,
    required this.tanggalAbsensi,
    this.hadir,
    this.izin,
    this.lembur,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      namaAnggota: json['nama_anggota'] as String,
      namaProfesi: json['nama_profesi'] as String,
      namaRegu: json['nama_regu'] as String,
      tanggalAbsensi: json['tanggal_absensi'] as String,
      hadir: json.containsKey('hadir') ? json['hadir'] as int : null,
      izin: json.containsKey('izin') ? json['izin'] as int : null,
      lembur: json.containsKey('lembur') ? json['lembur'] as int : null,
    );
  }
}
