import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // State untuk Checkbox
  bool _isAgreed = false;

  // Warna Utama
  final Color _primaryBlue = const Color(0xFF1A73E8); 

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F3974),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 1. BACKGROUND GRADIENT
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF0F3974), // Warna Atas
              Color(0xFF2E7CF6), // Warna Bawah
            ],
          ),
        ),
        child: SafeArea(
          // PENGGUNAAN STACK AGAR TOMBOL BACK DIAM (TIDAK IKUT SCROLL)
          child: Stack(
            children: [
              // --- LAYER 1: KONTEN YANG BISA DI-SCROLL ---
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                child: Column(
                  children: [
                    // Memberi jarak kosong di atas agar konten awal tidak tertutup tombol back
                    // atau disesuaikan dengan posisi gambar yang diinginkan.
                    const SizedBox(height: 60), 

                    // 2. GAMBAR KELUARGA (DIGESER KE ATAS MENGGUNAKAN TRANSFORM)
                    Transform.translate(
                      offset: const Offset(0, -40), // Naikkan lebih tinggi lagi karena ada SizedBox di atas
                      child: Image.asset(
                        'assets/images/keluarga.png',
                        height: 350, 
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.family_restroom_rounded,
                            size: 100,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),

                    // TEXT HEADER (DIGESER KE ATAS JUGA)
                    Transform.translate(
                      offset: const Offset(0, -32), 
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
                          Text(
                            "“Yuk, bergabung dan tumbuh bersama\nHarmonyKids!”",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.baloo2(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // FORM FIELDS
                    // Kita kurangi jarak di sini karena elemen di atasnya sudah ditarik ke atas (Offset -80)
                    // Gunakan SizedBox negatif atau kecil jika jaraknya terlalu jauh
                    const SizedBox(height: 0), 

                    // Nama Lengkap
                    _buildTextField(
                      controller: _nameController,
                      hintText: "Nama Lengkap",
                      icon: Icons.person_rounded,
                    ),
                    const SizedBox(height: 20),

                    // Email
                    _buildTextField(
                      controller: _emailController,
                      hintText: "Email",
                      icon: Icons.email_rounded,
                      inputType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 20),

                    // Nomor Telepon
                    _buildTextField(
                      controller: _phoneController,
                      hintText: "Nomor Telepon",
                      icon: Icons.phone_rounded,
                      inputType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // Kata Sandi
                    _buildTextField(
                      controller: _passwordController,
                      hintText: "Kata Sandi",
                      icon: Icons.lock_rounded,
                      isPassword: true,
                    ),
                    const SizedBox(height: 20),

                    // Konfirmasi Kata Sandi
                    _buildTextField(
                      controller: _confirmPasswordController,
                      hintText: "Konfirmasi Kata Sandi",
                      icon: Icons.verified_user_rounded,
                      isPassword: true,
                    ),

                    const SizedBox(height: 20),

                    // CHECKBOX & TERMS
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: Checkbox(
                            value: _isAgreed,
                            activeColor: Colors.white,
                            checkColor: _primaryBlue,
                            side: const BorderSide(color: Colors.white, width: 2),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (value) {
                              setState(() {
                                _isAgreed = value ?? false;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            "Saya setuju dengan Ketentuan Layanan dan Kebijakan Privasi HarmonyKids",
                            style: GoogleFonts.baloo2(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // TOMBOL DAFTAR
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
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(15),
                          onTap: () {
                            if (_isAgreed) {
                              Navigator.pushReplacementNamed(context, '/login');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Harap setujui syarat & ketentuan")),
                              );
                            }
                          },
                          child: Center(
                            child: Text(
                              "Daftar",
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

                    const SizedBox(height: 32),
                  ],
                ),
              ),

              // --- LAYER 2: TOMBOL BACK FIXED (DIAM DI TEMPAT) ---
              // Widget ini diletakkan di luar SingleChildScrollView
              Positioned(
                top: 16, // Jarak dari atas SafeArea
                left: 24, // Jarak dari kiri (sesuai padding horizontal konten)
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [ // Opsional: Tambah shadow biar tombol terlihat melayang
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.chevron_left, color: _primaryBlue, size: 28),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- REUSABLE TEXT FIELD WIDGET ---
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
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
        keyboardType: inputType,
        style: GoogleFonts.baloo2(
          color: _primaryBlue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.baloo2(
            color: _primaryBlue.withOpacity(0.6),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Icon(icon, color: _primaryBlue, size: 26),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 50),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}