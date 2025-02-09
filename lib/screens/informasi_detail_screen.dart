import 'package:flutter/material.dart';
import 'package:kapal_application/widgets/loading_indicator.dart';
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
  Future<InformasiDetail>? _informasiDetail;

  @override
  void initState() {
    super.initState();
    _loadInformasiDetail();
  }

  Future<void> _loadInformasiDetail() async {
    final token = await SharedPrefs.getToken();
    if (token != null) {
      setState(() {
        _informasiDetail = _apiService
            .getInformasiDetail(token, widget.informasiId)
            .then((response) => response.data);
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
            return LoadingIndicator();
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
          }

          final informasi = snapshot.data!;
          return _buildDetailContent(informasi);
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
          Image.network(
            fullImageUrl,
            width: double.infinity,
            height: 260,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 260,
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
                height: 260,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow(
                    'Bawaan', informasi.bawaan, Icons.inventory_2_outlined),
                _buildDetailRow('Keberangkatan', informasi.kebarangkatan,
                    Icons.directions_bus),
                _buildDetailRow(
                    'Jam Sampai', informasi.jamSampai, Icons.schedule),
                _buildDetailRow(
                    'Dibuat pada', informasi.createdAt, Icons.date_range),
                _buildDetailStatus('Status', informasi.status),
                _buildDetailRegus('Regu', informasi.regus),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String title, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primaryColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.w500)),
          ),
          Text(value,
              style: AppFonts.bodyText.copyWith(color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildDetailStatus(String title, String status) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'selesai':
        statusColor = Colors.green;
        break;
      case 'sedang dikerjakan':
        statusColor = Colors.orange;
        break;
      case 'belum dikerjakan':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.info, color: statusColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title,
                style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.w500)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: AppFonts.bodyText
                  .copyWith(color: statusColor, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRegus(String title, List<String> regus) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: AppFonts.bodyText.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: regus.map((regu) => Chip(label: Text(regu))).toList(),
          ),
        ],
      ),
    );
  }
}
