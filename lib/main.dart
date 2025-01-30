import 'package:flutter/material.dart';
import 'screens/splash_screen.dart'; // Import halaman splash screen
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Pastikan Flutter telah diinisialisasi
  await initializeDateFormatting('id_ID', null); // Inisialisasi locale data
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Perkapalan',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const SplashScreen(), // Set SplashScreen sebagai halaman awal
    );
  }
}
