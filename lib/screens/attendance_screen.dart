import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import '../models/attendance_response.dart';
import '../services/api_service.dart';
import '../services/shared_prefs.dart';
import '../widgets/loading_indicator.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late Future<AttendanceResponse> _attendanceFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    try {
      final token = await SharedPrefs.getToken();
      if (token == null) {
        throw Exception('Token tidak ditemukan');
      }
      setState(() {
        _attendanceFuture = _apiService.getAttendance(token);
      });
    } catch (e) {
      setState(() {
        _attendanceFuture = Future.error('Gagal memuat data: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Absensi', style: AppFonts.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<AttendanceResponse>(
          future: _attendanceFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: LoadingIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style: AppFonts.bodyText.copyWith(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
              return const Center(child: Text('Tidak ada data absensi.'));
            } else {
              final attendanceData = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTotalStats(attendanceData),
                  const SizedBox(height: 24),
                  Expanded(
                    child: ListView.builder(
                      itemCount: attendanceData.data.length,
                      itemBuilder: (context, index) {
                        return _buildAttendanceCard(attendanceData.data[index]);
                      },
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTotalStats(AttendanceResponse attendance) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard('Hadir', attendance.totalHadir, Icons.check_circle,
            AppColors.primaryColor),
        _buildStatCard('Izin', attendance.totalIzin, Icons.error_outline,
            AppColors.accentColor),
        _buildStatCard('Lembur', attendance.totalLembur, Icons.work,
            AppColors.secondaryColor),
      ],
    );
  }

  Widget _buildStatCard(String title, int value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title,
                style:
                    AppFonts.bodyText.copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: 4),
            Text(value.toString(),
                style: AppFonts.heading1.copyWith(color: color, fontSize: 22)),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(AttendanceData attendance) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(attendance.namaAnggota,
            style: AppFonts.heading1.copyWith(fontSize: 18)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${attendance.namaProfesi} - ${attendance.namaRegu}',
                style:
                    AppFonts.bodyText.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 4),
            Text(attendance.tanggalAbsensi,
                style:
                    AppFonts.caption.copyWith(color: AppColors.primaryColor)),
            const SizedBox(height: 8),
            Row(
              children: [
                if (attendance.hadir != null && attendance.hadir! > 0)
                  _buildAttendanceBadge('Hadir', AppColors.primaryColor),
                if (attendance.izin != null && attendance.izin! > 0)
                  _buildAttendanceBadge('Izin', AppColors.accentColor),
                if (attendance.lembur != null && attendance.lembur! > 0)
                  _buildAttendanceBadge('Lembur', AppColors.secondaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceBadge(String label, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: AppFonts.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
