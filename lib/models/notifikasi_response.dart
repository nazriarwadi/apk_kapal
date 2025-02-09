// lib/models/notifikasi_response.dart
class CheckNewAbsensiResponse {
  final String status;
  final String message;
  final bool hasNewData;

  CheckNewAbsensiResponse({
    required this.status,
    required this.message,
    required this.hasNewData,
  });

  factory CheckNewAbsensiResponse.fromJson(Map<String, dynamic> json) {
    return CheckNewAbsensiResponse(
      status: json['status'],
      message: json['message'],
      hasNewData: json['has_new_data'],
    );
  }
}
