// lib/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  // Warna utama (digunakan untuk elemen penting seperti tombol utama)
  static const Color primaryColor = Color(0xFF3A7CA5); // Biru lembut
  static const Color secondaryColor =
      Color.fromARGB(255, 11, 131, 250); // Hijau teal

  // Warna teks
  static const Color textPrimary =
      Color(0xFF333333); // Abu-abu gelap untuk teks utama
  static const Color textSecondary =
      Color(0xFF757575); // Abu-abu sedang untuk teks sekunder

  // Warna background
  static const Color background =
      Color(0xFFF5F5F5); // Abu-abu terang, hampir putih
  static const Color backgroundDark =
      Color(0xFF1E1E2C); // Biru keabu-abuan gelap (untuk mode gelap)

  // Warna aksen
  static const Color accentColor =
      Color(0xFFFFC857); // Kuning pastel untuk elemen aksen
  static const Color errorColor =
      Color(0xFFEE6C4D); // Merah oranye lembut untuk pesan error

  // Warna sukses
  static const Color successColor =
      Color(0xFF4CAF50); // Hijau klasik untuk pesan sukses
  static const Color warningColor =
      Color(0xFFFFB703); // Oranye lembut untuk peringatan

  // Warna tambahan untuk elemen sekunder
  static const Color cardColor =
      Color(0xFFFFFFFF); // Putih untuk kartu atau elemen kotak
  static const Color dividerColor =
      Color(0xFFE0E0E0); // Abu-abu terang untuk pembatas

  // Warna transparan
  static const Color transparent = Colors.transparent;
}
