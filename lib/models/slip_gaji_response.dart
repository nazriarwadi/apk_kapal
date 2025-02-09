import 'dart:convert';

class SlipGajiResponse {
  final String status;
  final String message;
  final List<SlipGaji> data;

  SlipGajiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  // Convert JSON ke Model
  factory SlipGajiResponse.fromJson(String str) =>
      SlipGajiResponse.fromMap(json.decode(str));

  factory SlipGajiResponse.fromMap(Map<String, dynamic> json) =>
      SlipGajiResponse(
        status: json["status"],
        message: json["message"],
        data: List<SlipGaji>.from(json["data"].map((x) => SlipGaji.fromMap(x))),
      );

  // Convert Model ke JSON
  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "status": status,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toMap())),
      };
}

// Model untuk setiap Slip Gaji
class SlipGaji {
  final String namaAnggota;
  final String namaProfesi;
  final String namaRegu;
  final int hadir;
  final int izin;
  final int lembur;
  final String gaji;
  final String bulan;

  SlipGaji(
      {required this.namaAnggota,
      required this.namaProfesi,
      required this.namaRegu,
      required this.hadir,
      required this.izin,
      required this.lembur,
      required this.gaji,
      required this.bulan});

  // Convert JSON ke Model
  factory SlipGaji.fromJson(String str) => SlipGaji.fromMap(json.decode(str));

  factory SlipGaji.fromMap(Map<String, dynamic> json) => SlipGaji(
      namaAnggota: json["nama_anggota"],
      namaProfesi: json["nama_profesi"],
      namaRegu: json["nama_regu"],
      hadir: json["hadir"],
      izin: json["izin"],
      lembur: json["lembur"],
      gaji: json["gaji"],
      bulan: json["bulan"]);

  // Convert Model ke JSON
  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() => {
        "nama_anggota": namaAnggota,
        "nama_profesi": namaProfesi,
        "nama_regu": namaRegu,
        "hadir": hadir,
        "izin": izin,
        "lembur": lembur,
        "gaji": gaji,
        "bulan": bulan,
      };
}
