import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import '../models/slip_gaji_response.dart';
import '../services/api_service.dart';
import '../services/shared_prefs.dart';

class SlipGajiScreen extends StatefulWidget {
  const SlipGajiScreen({Key? key}) : super(key: key);

  @override
  _SlipGajiScreenState createState() => _SlipGajiScreenState();
}

class _SlipGajiScreenState extends State<SlipGajiScreen> {
  late Future<SlipGajiResponse> _slipGajiFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadSlipGaji();
  }

  Future<void> _loadSlipGaji() async {
    final token = await SharedPrefs.getToken();
    if (token != null) {
      setState(() {
        _slipGajiFuture = _apiService.getSlipGaji(token);
      });
    } else {
      throw Exception('Token tidak ditemukan');
    }
  }

  String formatRupiah(String amount) {
    final formatter = NumberFormat.currency(
        locale: 'id_ID', symbol: 'Rp. ', decimalDigits: 0);
    return formatter.format(double.tryParse(amount) ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Slip Gaji', style: AppFonts.heading2),
        backgroundColor: AppColors.background,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<SlipGajiResponse>(
          future: _slipGajiFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.data.isEmpty) {
              return const Center(child: Text('Tidak ada data slip gaji.'));
            } else {
              final slipGajiList = snapshot.data!.data;
              return ListView.builder(
                itemCount: slipGajiList.length,
                itemBuilder: (context, index) {
                  final slip = slipGajiList[index];
                  return _buildSlipGajiCard(slip);
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildSlipGajiCard(SlipGaji slip) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  slip.namaAnggota,
                  style: AppFonts.heading1,
                ),
                Text(
                  formatRupiah(slip.gaji),
                  style:
                      AppFonts.heading2.copyWith(color: AppColors.primaryColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.work, size: 16, color: AppColors.secondaryColor),
                const SizedBox(width: 8),
                Text(
                  slip.namaProfesi,
                  style: AppFonts.bodyText,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.group, size: 16, color: AppColors.accentColor),
                const SizedBox(width: 8),
                Text(
                  slip.namaRegu,
                  style: AppFonts.bodyText,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatChip(
                    'Hadir', slip.hadir.toString(), AppColors.primaryColor),
                _buildStatChip(
                    'Izin', slip.izin.toString(), AppColors.accentColor),
                _buildStatChip(
                    'Lembur', slip.lembur.toString(), AppColors.secondaryColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(String label, String value, Color color) {
    return Chip(
      backgroundColor: color.withOpacity(0.1),
      label: Text(
        '$label: $value',
        style: AppFonts.caption
            .copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
