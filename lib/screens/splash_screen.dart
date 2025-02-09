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
    Future.delayed(const Duration(seconds: 3), () {
      _checkLoginStatus();
    });
  }

  Future<void> _checkLoginStatus() async {
    final token = await SharedPrefs.getToken();
    final isBanned = await SharedPrefs.getIsBanned();

    if (token != null) {
      if (isBanned) {
        // Jika akun dibanned, hapus token dan arahkan ke LoginScreen
        await SharedPrefs.clearAll();
        _navigateToLogin(banned: true);
      } else {
        _navigateToHome();
      }
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  void _navigateToLogin({bool banned = false}) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen(banned: banned)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_apk.png',
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),
            Text(
              'Tenaga Kerja Bongkar Muat',
              style: AppFonts.heading1.copyWith(color: AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}
