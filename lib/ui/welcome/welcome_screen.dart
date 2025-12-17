import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../home/home_screen.dart'; // Pastikan import ini benar untuk navigasi
import '../../main.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Ukuran layar untuk mengatur posisi responsif
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 1. BACKGROUND IMAGE
        decoration: const BoxDecoration(
          image: DecorationImage(
            // Pastikan file background.png sudah ada di assets/images/
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover, // Agar gambar memenuhi layar
          ),
        ),
        child: Stack(
          children: [
            // ==========================================
            // 3. TEKS & TOMBOL (BAGIAN BAWAH)
            // ==========================================
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Agar menempel di bawah
                  crossAxisAlignment: CrossAxisAlignment.start, // Rata Kiri
                  children: [
                    // Teks Judul
                    Text(
                      "Selamat Datang",
                      style: GoogleFonts.baloo2(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          "di ",
                          style: GoogleFonts.baloo2(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "HarmonyKids",
                          style: GoogleFonts.baloo2(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900, // Lebih tebal
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "\"Langkah Kecil Menuju Masa Depan Cerah.\"",
                      style: GoogleFonts.baloo2(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    
                    const SizedBox(height: 32),

                    // TOMBOL MASUK
                    _buildButton(
                      text: "Masuk", 
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      }
                    ),

                    const SizedBox(height: 32),

                    // TOMBOL DAFTAR
                    _buildButton(
                      text: "Daftar", 
                      onPressed: () {
                        Navigator.pushNamed(context, '/register');
                      }
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget untuk Tombol Putih
  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return Container(
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        // Efek Shadow tombol (sedikit ungu di bawahnya seperti referensi)
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFD8D5EA), // Warna bayangan
            blurRadius: 0,
            offset: Offset(0, 10), // Geser ke bawah
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.baloo2(
                color: const Color(0xFF0F3974), // Biru Tua Teks
                fontSize: 18,
                fontWeight: FontWeight.w800, // Extra Bold
              ),
            ),
          ),
        ),
      ),
    );
  }
}