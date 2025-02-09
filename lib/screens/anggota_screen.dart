import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import '../models/anggota_response.dart';
import '../services/api_service.dart';
import '../services/shared_prefs.dart';
import '../widgets/loading_indicator.dart';

class AnggotaScreen extends StatefulWidget {
  const AnggotaScreen({Key? key}) : super(key: key);

  @override
  _AnggotaScreenState createState() => _AnggotaScreenState();
}

class _AnggotaScreenState extends State<AnggotaScreen> {
  late Future<AnggotaResponse> _currentAnggotaFuture;
  late Future<AnggotaAllResponse> _allAnggotaFuture;
  final ApiService _apiService = ApiService();
  String namaRegu = 'Regu Tidak Diketahui'; // Default jika data belum tersedia

  @override
  void initState() {
    super.initState();
    _loadAnggotaData();
  }

  Future<void> _loadAnggotaData() async {
    final token = await SharedPrefs.getToken();
    if (token != null) {
      setState(() {
        _currentAnggotaFuture = _apiService.getCurrentAnggota(token);
        _allAnggotaFuture = _apiService.getAllAnggota(token);
      });

      // Ambil nama regu dari daftar anggota lainnya
      final allAnggota = await _apiService.getAllAnggota(token);
      if (allAnggota.data.isNotEmpty) {
        setState(() {
          namaRegu = allAnggota.data.first.namaRegu;
        });
      }
    } else {
      throw Exception('Token tidak ditemukan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Anggota', style: AppFonts.heading2),
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: _loadAnggotaData,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildSectionTitle('Profil Anda'),
            _buildCurrentAnggota(),
            const SizedBox(height: 24),
            _buildSectionTitle('Daftar Anggota $namaRegu'),
            _buildAllAnggota(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: AppFonts.heading1.copyWith(
          fontSize: 22,
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCurrentAnggota() {
    return FutureBuilder<AnggotaResponse>(
      future: _currentAnggotaFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return const Center(child: Text('Tidak ada data'));
        } else {
          final user = snapshot.data!;
          return _buildAnggotaCard(
              user.data.nama, user.data.namaRegu, user.data.namaProfesi);
        }
      },
    );
  }

  Widget _buildAllAnggota() {
    return FutureBuilder<AnggotaAllResponse>(
      future: _allAnggotaFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
          return const Center(child: Text('Tidak ada anggota lain'));
        } else {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.9,
            ),
            itemCount: snapshot.data!.data.length,
            itemBuilder: (context, index) {
              final anggota = snapshot.data!.data[index];
              return _buildAnggotaCard(
                  anggota.nama, anggota.namaRegu, anggota.namaProfesi);
            },
          );
        }
      },
    );
  }

  Widget _buildAnggotaCard(String nama, String regu, String profesi) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize:
              MainAxisSize.min, // Menyesuaikan tinggi card sesuai konten
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 50, color: Colors.blueAccent),
            const SizedBox(height: 12),
            Flexible(
              child: Text(
                nama,
                style: AppFonts.heading2.copyWith(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                'Regu: $regu',
                style:
                    AppFonts.bodyText.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 4),
            Flexible(
              child: Text(
                'Profesi: $profesi',
                style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
