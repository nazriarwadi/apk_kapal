import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import '../models/anggota_response.dart';
import '../services/api_service.dart';
import '../services/shared_prefs.dart';

class AnggotaScreen extends StatefulWidget {
  const AnggotaScreen({Key? key}) : super(key: key);

  @override
  _AnggotaScreenState createState() => _AnggotaScreenState();
}

class _AnggotaScreenState extends State<AnggotaScreen> {
  late Future<AnggotaResponse> _currentAnggotaFuture;
  late Future<AnggotaAllResponse> _allAnggotaFuture;
  final ApiService _apiService = ApiService();

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
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Data Anggota Kamu'),
            _buildCurrentAnggota(),
            const SizedBox(height: 32),
            _buildSectionTitle('Data Anggota Yang Lainnya'),
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
          color: AppColors.textSecondary,
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
          return const Center(child: CircularProgressIndicator());
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
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
          return const Center(child: Text('Tidak ada data anggota'));
        } else {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.0,
            ),
            itemCount: snapshot.data!.data.length,
            itemBuilder: (context, index) {
              final anggota = snapshot.data!.data[index];
              return _buildAnggotaGridItem(
                  anggota.nama, anggota.namaRegu, anggota.namaProfesi);
            },
          );
        }
      },
    );
  }

  Widget _buildAnggotaCard(String nama, String regu, String profesi) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.blue.shade50, Colors.blue.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.person_outline,
                size: 40, color: Colors.blueAccent),
            const SizedBox(height: 12),
            Text(
              nama,
              style: AppFonts.heading2.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Regu: $regu',
              style: AppFonts.bodyText.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 4),
            Text(
              'Profesi: $profesi',
              style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnggotaGridItem(String nama, String regu, String profesi) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(Icons.person, size: 40, color: Colors.white),
            const SizedBox(height: 12),
            Text(
              nama,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text('Regu: $regu',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70)),
            const SizedBox(height: 4),
            Text('Profesi: $profesi',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
