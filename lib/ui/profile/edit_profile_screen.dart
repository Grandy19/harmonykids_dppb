import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import Widget Custom
import '../../shared/widgets/custom_header.dart'; 
import '../../shared/widgets/custom_bottom_nav.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}


class _EditProfileScreenState extends State<EditProfileScreen> {
  final int _currentIndex = -1; // Navbar mati

  // Controllers Kosong (Template)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _jobController = TextEditingController();
  final TextEditingController _relationController = TextEditingController();

  // Warna Utama
  final Color _primaryBlue = const Color(0xFF1A73E8); 

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _jobController.dispose();
    _relationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFD),
      
      body: Stack(
        children: [
          // ==========================================
          // LAYER 1: KONTEN SCROLL
          // ==========================================
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            // UBAH DISINI: Ganti bottom: 100 menjadi bottom: 30
            padding: const EdgeInsets.only(top: 250, left: 24, right: 24, bottom: 30),
            child: Column(
              children: [
                
                // --- 1. FOTO PROFIL (TEMPLATE ICON MURNI) ---
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      // Lingkaran Utama
                      Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          color: const Color(0xFFD8D5EA), // Warna placeholder (Abu-Ungu)
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: [
                            BoxShadow(
                              color: _primaryBlue.withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        // ICON BAWAAN
                        child: const Icon(
                          Icons.person_rounded, 
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      
                      // Tombol Edit Kecil (Lingkaran Biru)
                      Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: _primaryBlue,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 18),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // --- 2. FORM FIELDS (TINGGI 60px, RADIUS 15px) ---
                
                _buildTemplateInput(
                  controller: _nameController,
                  hintText: "Nama Lengkap",
                  icon: Icons.person_rounded,
                ),
                
                const SizedBox(height: 20),

                _buildTemplateInput(
                  controller: _emailController,
                  hintText: "Email",
                  icon: Icons.email_rounded,
                  inputType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 20),

                _buildTemplateInput(
                  controller: _addressController,
                  hintText: "Alamat Lengkap",
                  icon: Icons.location_on_rounded, 
                  inputType: TextInputType.streetAddress,
                ),

                const SizedBox(height: 20),

                _buildTemplateInput(
                  controller: _phoneController,
                  hintText: "Nomor Telepon",
                  icon: Icons.phone_rounded,
                  inputType: TextInputType.phone,
                ),

                const SizedBox(height: 20),

                _buildTemplateInput(
                  controller: _jobController,
                  hintText: "Pekerjaan",
                  icon: Icons.work_rounded,
                ),

                const SizedBox(height: 20),

                _buildTemplateInput(
                  controller: _relationController,
                  hintText: "Hubungan dengan anak",
                  icon: Icons.favorite_rounded,
                ),

                const SizedBox(height: 40),

                // --- 3. TOMBOL SIMPAN ---
                Container(
                  width: double.infinity,
                  height: 50, // Tombol Simpan (sedikit lebih kecil dari input)
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
                        // Aksi Simpan Kosong
                      },
                      child: Center(
                        child: Text(
                          "Simpan",
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
                
              ],
            ),
          ),

          // ==========================================
          // LAYER 2: CUSTOM HEADER
          // ==========================================
          const Positioned(
            top: 0, left: 0, right: 0,
            child: CustomHeader(
              title: "Edit Akun", 
            ), 
          ),
        ],
      ),

      // ==========================================
      // BOTTOM NAV
      // ==========================================
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _currentIndex, 
        onTap: (index) {
          if (index == 0) {
             Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ),
    );
  }

  // --- WIDGET HELPER INPUT FIELD (UPDATED) ---
  Widget _buildTemplateInput({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      // 1. SET TINGGI 60px
      height: 60, 
      decoration: BoxDecoration(
        color: Colors.white,
        // 2. SET RADIUS 15px
        borderRadius: BorderRadius.circular(15), 
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      // Agar TextField berada di tengah secara vertikal di dalam Container 60px
      alignment: Alignment.center, 
      child: TextField(
        controller: controller,
        keyboardType: inputType,
        // Align text vertical agar pas dengan ikon
        textAlignVertical: TextAlignVertical.center,
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
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Icon(
              icon, 
              color: _primaryBlue, 
              size: 26, 
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 48),
          
          border: InputBorder.none,
          // Hapus vertical padding bawaan agar tidak konflik dengan height 60px container
          // Kita sudah pakai Alignment.center pada Container
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          isCollapsed: true, 
          
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: Icon(
              Icons.edit,
              color: _primaryBlue.withOpacity(0.4),
              size: 18,
            ),
          ),
          suffixIconConstraints: const BoxConstraints(minWidth: 40),
        ),
      ),
    );
  }
}