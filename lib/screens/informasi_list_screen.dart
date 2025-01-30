import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import '../services/api_service.dart';
import '../models/informasi_response.dart';
import '../services/shared_prefs.dart';
import '../constants/api_constants.dart';
import 'informasi_detail_screen.dart'; // Tambahkan import untuk halaman detail

class InformasiListScreen extends StatefulWidget {
  const InformasiListScreen({Key? key}) : super(key: key);

  @override
  _InformasiListScreenState createState() => _InformasiListScreenState();
}

class _InformasiListScreenState extends State<InformasiListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Informasi>?> _informasiList =
      Future.value(null); // Nilai awal null

  @override
  void initState() {
    super.initState();
    _loadInformasi();
  }

  Future<void> _loadInformasi() async {
    try {
      final token =
          await SharedPrefs.getToken(); // Ambil token dari SharedPrefs
      if (token != null) {
        final response = await _apiService.getAllInformasi(token);
        setState(() {
          _informasiList = Future.value(response.data);
        });
      } else {
        setState(() {
          _informasiList =
              Future.error('Token tidak ditemukan. Silakan login ulang.');
        });
      }
    } catch (e) {
      setState(() {
        _informasiList = Future.error('Gagal memuat data informasi: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Informasi', style: AppFonts.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<List<Informasi>?>(
        future: _informasiList,
        builder: (context, snapshot) {
          // Tampilkan loading indicator jika data masih dimuat
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          }

          // Tampilkan pesan error jika terjadi kesalahan
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: AppFonts.bodyText.copyWith(color: AppColors.errorColor),
              ),
            );
          }

          // Tampilkan pesan "Tidak ada data informasi" hanya setelah loading selesai
          if (snapshot.connectionState == ConnectionState.done &&
              (!snapshot.hasData || snapshot.data!.isEmpty)) {
            return const Center(
              child: Text(
                'Tidak ada data informasi.',
                style: AppFonts.bodyText,
              ),
            );
          }

          // Tampilkan data jika tersedia
          final informasiList = snapshot.data!;
          return ListView.builder(
            itemCount: informasiList.length,
            itemBuilder: (context, index) {
              final informasi = informasiList[index];
              final fullImageUrl =
                  '${ApiConstants.baseImageUrl}${informasi.gambar}';

              return GestureDetector(
                onTap: () {
                  // Navigasi ke halaman detail
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InformasiDetailScreen(
                        informasiId: informasi.id,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: const EdgeInsets.all(18.0),
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(20)),
                        child: Image.network(
                          fullImageUrl,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            print('Error loading image: $error');
                            return Container(
                              height: 220,
                              color: Colors.grey[200],
                              child: const Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primaryColor,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dibuat pada: ${informasi.createdAt}',
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryColor),
          ),
          const SizedBox(height: 16),
          Text(
            'Memuat data informasi...',
            style: AppFonts.bodyText.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
