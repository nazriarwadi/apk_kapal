import 'package:flutter/material.dart';
import '../constants/api_constants.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import '../services/api_service.dart';
import '../models/informasi_response.dart';
import '../services/shared_prefs.dart';

class InformasiDetailScreen extends StatefulWidget {
  final int informasiId;

  const InformasiDetailScreen({Key? key, required this.informasiId})
      : super(key: key);

  @override
  _InformasiDetailScreenState createState() => _InformasiDetailScreenState();
}

class _InformasiDetailScreenState extends State<InformasiDetailScreen> {
  final ApiService _apiService = ApiService();
  late Future<InformasiDetail> _informasiDetail;

  @override
  void initState() {
    super.initState();
    _loadInformasiDetail();
  }

  Future<void> _loadInformasiDetail() async {
    final token = await SharedPrefs.getToken();
    if (token != null) {
      setState(() {
        _informasiDetail =
            _apiService.getInformasiDetail(token, widget.informasiId).then(
                  (response) => response.data,
                );
      });
    } else {
      setState(() {
        _informasiDetail =
            Future.error('Token tidak ditemukan. Silakan login ulang.');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Informasi', style: AppFonts.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      backgroundColor: AppColors.background,
      body: FutureBuilder<InformasiDetail>(
        future: _informasiDetail,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingIndicator();
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: AppFonts.bodyText.copyWith(color: AppColors.errorColor),
              ),
            );
          } else if (!snapshot.hasData) {
            return const Center(
              child: Text(
                'Data detail tidak ditemukan.',
                style: AppFonts.bodyText,
              ),
            );
          } else {
            final informasi = snapshot.data!;
            return _buildDetailContent(informasi);
          }
        },
      ),
    );
  }

  Widget _buildDetailContent(InformasiDetail informasi) {
    final fullImageUrl = '${ApiConstants.baseImageUrl}${informasi.gambar}';
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar utama dengan overlay
          Stack(
            children: [
              ClipRRect(
                child: Image.network(
                  fullImageUrl,
                  width: double.infinity,
                  height: 260,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
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
                    return Container(
                      height: 300,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.primaryColor,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Overlay gradient untuk judul
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              // Judul di atas gambar
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: Text(
                  informasi.regu,
                  style: AppFonts.heading1.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Detail informasi dalam card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      title: 'Bawaan',
                      value: informasi.bawaan,
                      icon: Icons.inventory_2_outlined,
                    ),
                    const Divider(height: 24, thickness: 1),
                    _buildDetailRow(
                      title: 'Keberangkatan',
                      value: informasi.kebarangkatan,
                      icon: Icons.directions_bus_filled_outlined,
                    ),
                    const Divider(height: 24, thickness: 1),
                    _buildDetailRow(
                      title: 'Jam Sampai',
                      value: informasi.jamSampai,
                      icon: Icons.schedule_outlined,
                    ),
                    const Divider(height: 24, thickness: 1),
                    _buildDetailRow(
                      title: 'Dibuat pada',
                      value: informasi.createdAt,
                      icon: Icons.date_range_outlined,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryColor, size: 28),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.w500),
          ),
        ),
        Text(
          value,
          style: AppFonts.bodyText.copyWith(color: Colors.grey[700]),
        ),
      ],
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
            'Memuat detail informasi...',
            style: AppFonts.bodyText.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
