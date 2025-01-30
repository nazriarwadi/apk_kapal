// models/attendance_response.dart
class AttendanceResponse {
  final String status;
  final String message;
  final List<AttendanceData> data;

  AttendanceResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory AttendanceResponse.fromJson(Map<String, dynamic> json) {
    return AttendanceResponse(
      status: json['status'] as String,
      message: json['message'] as String,
      data: (json['data'] as List)
          .map((item) => AttendanceData.fromJson(item))
          .toList(),
    );
  }
}

class AttendanceData {
  final String namaAnggota;
  final String namaProfesi;
  final String namaRegu;
  final int hadir;
  final int izin;
  final int lembur;

  AttendanceData({
    required this.namaAnggota,
    required this.namaProfesi,
    required this.namaRegu,
    required this.hadir,
    required this.izin,
    required this.lembur,
  });

  factory AttendanceData.fromJson(Map<String, dynamic> json) {
    return AttendanceData(
      namaAnggota: json['nama_anggota'] as String,
      namaProfesi: json['nama_profesi'] as String,
      namaRegu: json['nama_regu'] as String,
      hadir: json['hadir'] as int,
      izin: json['izin'] as int,
      lembur: json['lembur'] as int,
    );
  }
}
