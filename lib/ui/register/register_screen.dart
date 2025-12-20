import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../cubits/register/register_cubit.dart';
import '../../cubits/register/register_state.dart';
import '../../shared/widgets/auth_text_field.dart';

// WRAPPER: MENYEDIAKAN CUBIT
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterCubit(),
      child: const RegisterView(),
    );
  }
}

// VIEW: TAMPILAN UI
class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  // UI State (Hanya untuk mata password & checkbox)
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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

  // LOGIKA REGISTER (PANGGIL CUBIT)
  void _onRegisterPressed() {
    context.read<RegisterCubit>().registerWali(
          name: _nameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          password: _passwordController.text,
          confirmPassword: _confirmPasswordController.text,
          isAgreed: _isAgreed,
        );
  }

  // POP-UP SUKSES 
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
              Text("Registrasi Berhasil!", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  Navigator.pop(ctx); // Tutup Dialog
                  Navigator.pushReplacementNamed(context, '/login'); // Pindah ke Login
                },
                child: Text("Silakan Login", style: GoogleFonts.baloo2(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  // POP-UP GAGAL
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
              Text("Gagal Daftar", style: TextStyle(fontWeight: FontWeight.bold)),
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
                child: Text("Perbaiki Data", style: GoogleFonts.baloo2(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          _showSuccessDialog(state.message);
        } else if (state is RegisterFailure) {
          _showFailureDialog(state.message);
        }
      },
      builder: (context, state) {
        bool isLoading = (state is RegisterLoading);

        return Scaffold(
          backgroundColor: const Color(0xFF0F3974),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0F3974),
                  Color(0xFF2E7CF6),
                ],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  // --- KONTEN SCROLL ---
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 60),

                        // GAMBAR KELUARGA
                        Transform.translate(
                          offset: const Offset(0, -40),
                          child: Image.asset(
                            'assets/images/keluarga.png',
                            height: 300,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.family_restroom_rounded, size: 100, color: Colors.white);
                            },
                          ),
                        ),

                        // TEXT HEADER
                        Transform.translate(
                          offset: const Offset(0, -32),
                          child: Column(
                            children: [
                              Text(
                                "“Hai, Mama Papa!”",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.baloo2(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              Text(
                                "“Yuk, bergabung dan tumbuh bersama\nHarmonyKids!”",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.baloo2(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),

                        // INPUT FIELDS
                        AuthTextField(
                          controller: _nameController,
                          hintText: "Nama Lengkap",
                          icon: Icons.person_rounded,
                        ),
                        const SizedBox(height: 20),
                        AuthTextField(
                          controller: _emailController,
                          hintText: "Email",
                          icon: Icons.email_rounded,
                          inputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),
                        AuthTextField(
                          controller: _phoneController,
                          hintText: "Nomor Telepon",
                          icon: Icons.phone_rounded,
                          inputType: TextInputType.phone,
                        ),
                        const SizedBox(height: 20),
                        AuthTextField(
                          controller: _passwordController,
                          hintText: "Kata Sandi",
                          icon: Icons.lock_rounded,
                          isPassword: true,
                          isObscure: _obscurePassword,
                          onToggleObscure: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        const SizedBox(height: 20),
                        AuthTextField(
                          controller: _confirmPasswordController,
                          hintText: "Konfirmasi Kata Sandi",
                          icon: Icons.verified_user_rounded,
                          isPassword: true,
                          isObscure: _obscureConfirmPassword,
                          onToggleObscure: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),

                        const SizedBox(height: 20),

                        // CHECKBOX
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                                style: GoogleFonts.baloo2(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
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
                            boxShadow: const [BoxShadow(color: Color(0xFFD8D5EA), blurRadius: 0, offset: Offset(0, 8))],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: isLoading ? null : _onRegisterPressed, // Logic di Cubit
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24, height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0D253F)),
                                      )
                                    : Text(
                                        "Daftar",
                                        style: GoogleFonts.baloo2(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0D253F)),
                                      ),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),

                  // --- TOMBOL BACK FIXED ---
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
                          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))],
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
      },
    );
  }
}