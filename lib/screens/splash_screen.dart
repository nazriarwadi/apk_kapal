import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import '../services/shared_prefs.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Panggil fungsi untuk cek login status setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      _checkLoginStatus();
    });
  }

  // Fungsi untuk mengecek status login
  Future<void> _checkLoginStatus() async {
    final token = await SharedPrefs.getToken();

    if (token != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Gambar Logo
            Image.asset(
              'assets/images/logo_apk.png', // Pastikan path sesuai dengan lokasi gambar
              width: 250, // Sesuaikan ukuran logo
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            // Teks Aplikasi
            Text(
              'Tenaga Kerja Bongkar Muat',
              style: AppFonts.heading1.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
