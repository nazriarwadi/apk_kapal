import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_fonts.dart';
import '../services/api_service.dart';
import '../services/shared_prefs.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  final bool banned;
  const LoginScreen({super.key, this.banned = false});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  bool _isLoading = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkBannedStatus();
  }

  Future<void> _checkBannedStatus() async {
    final isBanned = await SharedPrefs.getIsBanned();
    if (isBanned || widget.banned) {
      _showBannedDialog('Akun Anda masih diblokir. Hubungi admin.');
    }
  }

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
        await SharedPrefs.setIsBanned(false);
      }

      _showSnackbar(
          'Login berhasil! Selamat datang, ${loginResponse.anggota?.nama}',
          AppColors.successColor);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (e) {
      String errorMessage = 'Terjadi kesalahan saat login';

      if (e.toString().contains('banned')) {
        await SharedPrefs.setIsBanned(true);
        await SharedPrefs.clearAll();
        List<String> parts = e.toString().split('\n');
        String bannedMessage = parts[0].replaceFirst('Exception: ', '');
        String bannedUntil = parts.length > 1 ? parts[1] : '';
        _showBannedDialog('$bannedMessage\nBerlaku hingga: $bannedUntil');
        return;
      } else if (e.toString().contains('Email tidak terdaftar')) {
        errorMessage = 'Email tidak terdaftar';
      } else if (e.toString().contains('Password salah')) {
        errorMessage = 'Password salah';
      }

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

  void _showBannedDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.block, color: Colors.red, size: 50),
                const SizedBox(height: 10),
                Text('Akun Diblokir',
                    style: AppFonts.bodyText
                        .copyWith(fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 10),
                Text(message,
                    textAlign: TextAlign.center, style: AppFonts.caption),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await SharedPrefs.clearAll();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.errorColor),
                  child: Text('Logout', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_apk.png',
                      width: constraints.maxWidth * 0.5,
                      height: constraints.maxWidth * 0.5,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Email',
                          style: AppFonts.bodyText
                              .copyWith(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: 'Masukkan email Anda',
                        hintStyle: AppFonts.caption,
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppColors.primaryColor, width: 2.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Password',
                          style: AppFonts.bodyText
                              .copyWith(fontWeight: FontWeight.bold)),
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
                          borderSide: BorderSide(
                              color: AppColors.primaryColor, width: 2.0),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.textSecondary,
                          ),
                          onPressed: () => setState(
                              () => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
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
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : Text('Masuk',
                                style: AppFonts.bodyText.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
