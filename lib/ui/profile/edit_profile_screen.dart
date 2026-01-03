import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 1. Import Bloc
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

// Import Service, Model, & Cubit
import '../../services/profile_service.dart';
import '../../models/user_model.dart';
import '../../cubits/profile/profile_cubit.dart'; // Pastikan import ini benar

// Import Widget Custom (Desain Asli Tetap Dipakai)
import '../../shared/widgets/custom_header.dart';
import '../../shared/widgets/custom_bottom_nav.dart';

// --- WRAPPER: AGAR CUBIT BISA DIPAKAI DI SCREEN INI ---
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Membungkus view dengan BlocProvider agar Cubit tersedia
    return BlocProvider(
      create: (context) => ProfileCubit(),
      child: const EditProfileView(),
    );
  }
}

// --- VIEW UTAMA (DESAIN ASLI) ---
class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final int _currentIndex = -1;

  // --- LOGIC VARIABLES ---
  final ProfileService _profileService = ProfileService();
  // bool _isLoading = false; // HAPUS INI (Diganti State Cubit)
  
  File? _selectedImage;    
  String? _currentPhotoUrl; 
  final ImagePicker _picker = ImagePicker();

  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _jobController = TextEditingController(); 
  final TextEditingController _relationController = TextEditingController(); 

  // Opsi Gender
  String? _selectedGender;
  final List<String> _genderOptions = [
    'Laki-laki',
    'Perempuan',
    'Tidak ingin memberi tahu'
  ];

  // Warna Utama
  final Color _primaryBlue = const Color(0xFF1A73E8);

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Ambil data awal
  }

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

  // Icon Helper
  IconData _getGenderIcon(String? value) {
    if (value == 'Laki-laki') return Icons.male_rounded;
    if (value == 'Perempuan') return Icons.female_rounded;
    if (value == 'Tidak ingin memberi tahu') return Icons.lock_outline_rounded;
    return Icons.wc_rounded;
  }

  // --- LOAD DATA AWAL (Masih pakai setState untuk inisialisasi) ---
  Future<void> _loadUserData() async {
    // Note: Idealnya fetch awal juga pakai Cubit, tapi agar tidak terlalu banyak ubahan,
    // kita pakai cara lama hanya untuk fetch data awal form.
    try {
      UserModel user = await _profileService.getProfile();
      _nameController.text = user.name;
      _emailController.text = user.email;
      _addressController.text = user.alamat ?? '';
      _phoneController.text = user.nomorTelepon ?? ''; 
      _jobController.text = user.pekerjaan ?? '';
      _relationController.text = user.hubunganDenganAnak ?? ''; 
      
      if (user.jenisKelamin != null && _genderOptions.contains(user.jenisKelamin)) {
        _selectedGender = user.jenisKelamin;
      } else {
        _selectedGender = null;
      }
      
      if (mounted) {
        setState(() {
          _currentPhotoUrl = user.fotoProfil; 
        });
      }
    } catch (e) {
      if (mounted) {
        // Gunakan SnackBar biasa hanya untuk error fetch awal
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  // FUNGSI SUBMIT BARU (MENGGUNAKAN CUBIT)
  void _onSubmit() {
    // Panggil fungsi update di Cubit
    context.read<ProfileCubit>().updateProfile(
      name: _nameController.text,
      email: _emailController.text,
      alamat: _addressController.text,
      noTelepon: _phoneController.text,
      gender: _selectedGender ?? '',
      pekerjaan: _jobController.text,
      hubungan: _relationController.text,
      imageFile: _selectedImage,
    );
  }

  // --- POP-UP SUKSES (Gaya Login) ---
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Column(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: Colors.green, size: 60),
              SizedBox(height: 10),
              Text("Berhasil Disimpan!", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(fontSize: 16),
          ),
          actions: [
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3974),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pop(ctx); // Tutup dialog
                  _loadUserData(); // Refresh data di form agar foto/data terbaru muncul
                },
                child: Text("OK", style: GoogleFonts.baloo2(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- POP-UP GAGAL (Gaya Login) ---
  void _showFailureDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Column(
            children: [
              Icon(Icons.cancel_outlined, color: Colors.red, size: 60),
              SizedBox(height: 10),
              Text("Gagal", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(fontSize: 16),
          ),
          actions: [
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text("Coba Lagi", style: GoogleFonts.baloo2(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 2. Tambahkan BlocListener untuk memunculkan Dialog
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          _showSuccessDialog(state.message);
        } else if (state is ProfileFailure) {
          _showFailureDialog(state.message);
        }
      },
      child: Scaffold(
        // DESAIN ASLI (Background Putih)
        backgroundColor: const Color(0xFFF9FCFD),
        
        body: Stack(
          children: [
            // LAYER 1: KONTEN SCROLL
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(top: 250, left: 24, right: 24, bottom: 30),
              child: Column(
                children: [
                  
                  // FOTO PROFIL
                  GestureDetector(
                    onTap: _pickImage,
                    child: Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD8D5EA),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: [
                                BoxShadow(
                                  color: _primaryBlue.withOpacity(0.3),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                              image: _getAvatarImage(), 
                            ),
                            child: (_selectedImage == null && _currentPhotoUrl == null)
                                ? const Icon(
                                    Icons.person_rounded,
                                    size: 60,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
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
                  ),

                  const SizedBox(height: 32),

                  // FORM INPUT
                  // Note: Kita tidak pakai loading spinner besar disini lagi, 
                  // loading hanya di tombol simpan.
                  Column(
                    children: [
                      _buildTemplateInput(controller: _nameController, hintText: "Nama Lengkap", icon: Icons.person_rounded),
                      const SizedBox(height: 20),
                      _buildTemplateInput(controller: _emailController, hintText: "Email", icon: Icons.email_rounded, inputType: TextInputType.emailAddress),
                      const SizedBox(height: 20),
                      _buildTemplateInput(controller: _addressController, hintText: "Alamat Lengkap", icon: Icons.location_on_rounded, inputType: TextInputType.streetAddress),
                      const SizedBox(height: 20),
                      _buildTemplateInput(controller: _phoneController, hintText: "Nomor Telepon", icon: Icons.phone_rounded, inputType: TextInputType.phone),
                      const SizedBox(height: 20),
                      _buildDropdownGender(),
                      const SizedBox(height: 20),
                      _buildTemplateInput(controller: _jobController, hintText: "Pekerjaan", icon: Icons.work_rounded),
                      const SizedBox(height: 20),
                      _buildTemplateInput(controller: _relationController, hintText: "Hubungan dengan anak", icon: Icons.favorite_rounded),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // 3. TOMBOL SIMPAN (Dibungkus BlocBuilder untuk Loading State)
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      // Cek apakah sedang loading berdasarkan state Cubit
                      bool isLoading = (state is ProfileLoading);

                      return Container(
                        width: double.infinity,
                        height: 50,
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
                            // Disable tombol jika loading
                            onTap: isLoading ? null : _onSubmit, 
                            child: Center(
                              // Tampilkan Spinner jika loading, Teks jika tidak
                              child: isLoading 
                                ? CircularProgressIndicator(color: _primaryBlue)
                                : Text(
                                    "Simpan",
                                    style: GoogleFonts.baloo2(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF0F3974),
                                    ),
                                  ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  
                ],
              ),
            ),

            // LAYER 2: CUSTOM HEADER (DESAIN ASLI)
            const Positioned(
              top: 0, left: 0, right: 0,
              child: CustomHeader(
                title: "Edit Akun",
              ),
            ),
          ],
        ),

        // BOTTOM NAV (DESAIN ASLI)
        bottomNavigationBar: CustomBottomNav(
          selectedIndex: _currentIndex,
          onTap: (index) {
            if (index == 0) {
              Navigator.popUntil(context, (route) => route.isFirst);
            }
          },
        ),
      ),
    );
  }

  // --- WIDGET HELPER (TIDAK BERUBAH DARI DESAIN ASLI) ---
  Widget _buildDropdownGender() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          hint: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(_getGenderIcon(null), color: _primaryBlue, size: 26),
              ),
              Text(
                "Jenis Kelamin",
                style: GoogleFonts.baloo2(
                  color: _primaryBlue.withOpacity(0.6), 
                  fontSize: 16, 
                  fontWeight: FontWeight.bold
                ),
              ),
            ],
          ),
          icon: Padding(
             padding: const EdgeInsets.only(right: 12.0),
             child: Icon(Icons.arrow_drop_down_rounded, color: _primaryBlue.withOpacity(0.4)),
          ),
          isExpanded: true,
          items: _genderOptions.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: Icon(_getGenderIcon(value), color: _primaryBlue, size: 26),
                  ),
                  Text(
                    value,
                    style: GoogleFonts.baloo2(
                      color: _primaryBlue, 
                      fontSize: 16, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            setState(() {
              _selectedGender = newValue;
            });
          },
        ),
      ),
    );
  }

  DecorationImage? _getAvatarImage() {
    if (_selectedImage != null) {
      return DecorationImage(
        image: FileImage(_selectedImage!),
        fit: BoxFit.cover,
      );
    } 
    if (_currentPhotoUrl != null && _currentPhotoUrl!.isNotEmpty) {
      return DecorationImage(
        image: NetworkImage(_currentPhotoUrl!),
        fit: BoxFit.cover,
      );
    }
    return null;
  }

  Widget _buildTemplateInput({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
  }) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: inputType,
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