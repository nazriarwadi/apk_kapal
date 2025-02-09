import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kapal_application/constants/app_colors.dart';
import 'package:kapal_application/constants/app_fonts.dart';
import 'package:kapal_application/screens/informasi_list_screen.dart';
import 'package:kapal_application/screens/slip_gaji_screen.dart';
import 'package:kapal_application/services/shared_prefs.dart';
import '../services/time_service.dart';
import '../widgets/bottom_nav_bar.dart';
import 'anggota_screen.dart';
import 'attendance_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  String currentTime = TimeService.getCurrentTime();
  String currentDate = TimeService.getCurrentDate();
  String? token;

  @override
  void initState() {
    super.initState();
    _loadToken();
    // Inisialisasi timer untuk memperbarui waktu setiap detik
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        currentTime = TimeService.getCurrentTime();
        currentDate = TimeService.getCurrentDate();
      });
    });
  }

  Future<void> _loadToken() async {
    token = await SharedPrefs.getToken();
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel(); // Hentikan timer saat widget dihancurkan
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Menyesuaikan posisi teks "Menu"
        children: [
          // Bagian atas (background dengan gambar kapal)
          Stack(
            children: [
              Container(
                height: 300,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/ship_background.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currentTime,
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      currentDate,
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 40,
                right: 20, // Menempatkan ikon di pojok kanan atas
                child: GestureDetector(
                  onTap: () {
                    if (token != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              NotificationScreen(token: token!),
                        ),
                      );
                    }
                  },
                  child: const Icon(
                    Icons.notifications,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),

          // Teks "Menu"
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Text(
              "Menu",
              style: GoogleFonts.poppins(
                fontSize: AppFonts.extraLarge,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),

          // Bagian menu
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: [
                  _buildMenuItem(
                    imagePath: 'assets/images/absen.png',
                    label: 'Absen',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AttendanceScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    imagePath: 'assets/images/anggota.png',
                    label: 'Anggota',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AnggotaScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    imagePath: 'assets/images/slip_gaji.png',
                    label: 'Slip Gaji',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const SlipGajiScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    imagePath: 'assets/images/informasi_kapal.png',
                    label: 'Informasi Kapal',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const InformasiListScreen()),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavBar(selectedIndex: 0),
    );
  }

  // Widget untuk item menu dengan gambar
  Widget _buildMenuItem({
    required String imagePath,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 100, // Ukuran box tetap
            width: 100, // Ukuran box tetap
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 60, // Ukuran gambar tetap
                  width: 60,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain, // Hindari gambar terpotong
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
