import 'package:flutter/material.dart';
import 'package:kapal_application/widgets/loading_indicator.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import '../services/api_service.dart';
import '../models/informasi_response.dart';
import '../services/shared_prefs.dart';
import '../constants/api_constants.dart';
import 'informasi_detail_screen.dart';

class InformasiListScreen extends StatefulWidget {
  const InformasiListScreen({Key? key}) : super(key: key);

  @override
  _InformasiListScreenState createState() => _InformasiListScreenState();
}

class _InformasiListScreenState extends State<InformasiListScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Informasi>?> _informasiList = Future.value(null);

  @override
  void initState() {
    super.initState();
    _loadInformasi();
  }

  Future<void> _loadInformasi() async {
    try {
      final token = await SharedPrefs.getToken();
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

  Widget _buildStatusBadge(String status) {
    Color color;
    switch (status) {
      case 'Selesai':
        color = Colors.green;
        break;
      case 'Sedang dikerjakan':
        color = Colors.orange;
        break;
      case 'Belum dikerjakan':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
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
      body: RefreshIndicator(
        onRefresh: _loadInformasi,
        child: FutureBuilder<List<Informasi>?>(
          future: _informasiList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingIndicator();
            }
            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error: ${snapshot.error}',
                  style:
                      AppFonts.bodyText.copyWith(color: AppColors.errorColor),
                ),
              );
            }
            if (snapshot.connectionState == ConnectionState.done &&
                (!snapshot.hasData || snapshot.data!.isEmpty)) {
              return const Center(
                child: Text(
                  'Tidak ada data informasi.',
                  style: AppFonts.bodyText,
                ),
              );
            }

            final informasiList = snapshot.data!;
            return ListView.builder(
              itemCount: informasiList.length,
              itemBuilder: (context, index) {
                final informasi = informasiList[index];
                final fullImageUrl =
                    '${ApiConstants.baseImageUrl}${informasi.gambar}';

                return GestureDetector(
                  onTap: () {
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
                    margin: const EdgeInsets.all(16.0),
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
                              const SizedBox(height: 8),
                              _buildStatusBadge(informasi.status),
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
      ),
    );
  }
}
