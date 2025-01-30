import 'package:flutter/material.dart';
import '../constants/app_colors.dart'; // Import warna
import '../constants/app_fonts.dart'; // Import font
import '../services/api_service.dart';
import '../services/shared_prefs.dart';
import 'home_screen.dart'; // Import HomeScreen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  // Fungsi untuk menangani login
  Future<void> _handleLogin() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar(
          'Email dan password tidak boleh kosong!', AppColors.errorColor);
      return;
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      _showSnackbar('Format email tidak valid!', AppColors.errorColor);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final loginResponse = await _apiService.login(email, password);

      if (loginResponse.token != null) {
        await SharedPrefs.saveToken(loginResponse.token!);
      }

      _showSnackbar(
          'Login berhasil! Selamat datang, ${loginResponse.anggota?.nama}',
          AppColors.successColor);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const HomeScreen()));
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan saat login';
      if (e.toString().contains('Email tidak terdaftar'))
        errorMessage = 'Email tidak terdaftar';
      if (e.toString().contains('Password salah'))
        errorMessage = 'Password salah';

      _showSnackbar(errorMessage, AppColors.errorColor);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackbar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            // Gambar Logo Aplikasi
            Image.asset(
              'assets/images/logo_apk.png',
              width: 180, // Sesuaikan ukuran logo
              height: 180,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 20),

            // Input Email
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Email',
                  style:
                      AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Masukkan email Anda',
                hintStyle: AppFonts.caption,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.primaryColor, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Input Password
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Password',
                  style:
                      AppFonts.bodyText.copyWith(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: 'Masukkan password Anda',
                hintStyle: AppFonts.caption,
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: AppColors.primaryColor, width: 2.0),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.textSecondary,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Lupa Kata Sandi
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {}, // Tambahkan fungsi lupa password
                child: Text('Lupa Kata Sandi?', style: AppFonts.caption),
              ),
            ),
            const SizedBox(height: 20),

            // Tombol Login
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('Masuk',
                        style: AppFonts.bodyText.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
