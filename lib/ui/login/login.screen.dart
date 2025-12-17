import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // WARNA TEKS/ICON INPUT
  final Color _inputColor = const Color(0xFF1A73E8);

  // WARNA UNTUK TOMBOL BACK (Bisa disesuaikan, misal biru muda atau biru tua)
  final Color _backButtonColor = const Color(0xFF1A73E8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F3974),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // BACKGROUND GRADIENT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F3974), // Atas
              Color(0xFF2E7CF6), // Bawah
            ],
          ),
        ),
        child: SafeArea(
          // GUNAKAN STACK AGAR TOMBOL BACK DIAM
          child: Stack(
            children: [
              // --- LAYER 1: KONTEN SCROLL ---
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // SIZEDBOX UNTUK MEMBERI JARAK DARI ATAS
                    // Sesuaikan ini agar gambar tidak tertutup tombol back
                    const SizedBox(height: 60),

                    // 1. ILUSTRASI (plane.png) DIGESER NAIK
                    Transform.translate(
                      // Offset negatif Y menarik gambar ke atas
                      offset: const Offset(0, -40), 
                      child: Image.asset(
                        'assets/images/plane.png',
                        height: 350, // Sesuaikan tinggi gambar
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.airplanemode_active_rounded,
                            size: 100,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),

                    // TEXT HEADLINE (DIGESER NAIK JUGA)
                    Transform.translate(
                      offset: const Offset(0, -32), // Samakan offsetnya
                      child: Column(
                        children: [
                          Text(
                            "“Hai, Mama Papa!”",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.baloo2(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: "Siap tumbuh bersama ",
                              style: GoogleFonts.baloo2(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                              children: [
                                TextSpan(
                                  text: "HarmonyKids?",
                                  style: GoogleFonts.baloo2(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Kurangi jarak di sini karena elemen di atas sudah ditarik

                    // 2. FORM INPUT (Email)
                    _buildTextField(
                      controller: _emailController,
                      hintText: "Email",
                      icon: Icons.email_rounded,
                      isPassword: false,
                    ),

                    const SizedBox(height: 20),

                    // 3. FORM INPUT (Password)
                    _buildTextField(
                      controller: _passwordController,
                      hintText: "Kata Sandi",
                      icon: Icons.lock_rounded,
                      isPassword: true,
                    ),

                    const SizedBox(height: 40),

                    // 4. TOMBOL MASUK
                    Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFD8D5EA),
                            blurRadius: 0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            Navigator.pushReplacementNamed(context, '/main');
                          },
                          child: Center(
                            child: Text(
                              "Masuk",
                              style: GoogleFonts.baloo2(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0D253F),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // --- LAYER 2: TOMBOL BACK FIXED ---
              Positioned(
                top: 16,
                left: 24,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                         BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.chevron_left, color: _backButtonColor, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER INPUT FIELD ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: GoogleFonts.baloo2(
          color: _inputColor, // Menggunakan warna biru terang 0xFF1A73E8
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.baloo2(
            color: _inputColor.withOpacity(0.6),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(
              icon,
              color: _inputColor, // Icon biru terang
              size: 26,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 48),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
      ),
    );
  }
}