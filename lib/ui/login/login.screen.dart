import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../cubits/login/login_cubit.dart';
import '../../cubits/login/login_state.dart';
import '../../shared/widgets/auth_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // LOGIKA LOGIN 
  void _onLoginPressed() {
    context.read<LoginCubit>().login(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  // POP-UP SUKSES (HIJAU)
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
              Text("Berhasil Masuk!", style: TextStyle(fontWeight: FontWeight.bold)),
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
                  Navigator.pop(ctx);
                  Navigator.pushReplacementNamed(context, '/main');
                },
                child: Text("Lanjut ke Beranda", style: GoogleFonts.baloo2(color: Colors.white)),
              ),
            ),
          ],
        );
      },
    );
  }

  // POP-UP GAGAL / VALIDASI (MERAH)
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
              Text("Gagal Masuk", style: TextStyle(fontWeight: FontWeight.bold)),
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
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccess) {
          _showSuccessDialog(state.message);
        } else if (state is LoginFailure) {
          _showFailureDialog(state.message);
        }
      },
      builder: (context, state) {
        bool isLoading = (state is LoginLoading);

        return Scaffold(
          backgroundColor: const Color(0xFF0F3974),
          body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF0F3974), Color(0xFF2E7CF6)],
              ),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 60),
                        // ILUSTRASI
                        Transform.translate(
                          offset: const Offset(0, -40),
                          child: Image.asset(
                            'assets/images/plane.png',
                            height: 350,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.airplanemode_active_rounded, size: 100, color: Colors.white),
                          ),
                        ),
                        // HEADLINE
                        Transform.translate(
                          offset: const Offset(0, -32),
                          child: Column(
                            children: [
                              Text("“Hai, Mama Papa!”",
                                  style: GoogleFonts.baloo2(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: "Siap tumbuh bersama ",
                                  style: GoogleFonts.baloo2(color: Colors.white, fontSize: 16),
                                  children: [
                                    TextSpan(text: "HarmonyKids?", style: GoogleFonts.baloo2(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // INPUT FIELDS
                        AuthTextField(
                          controller: _emailController,
                          hintText: "Email",
                          icon: Icons.email_rounded,
                          inputType: TextInputType.emailAddress,
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
                        const SizedBox(height: 40),

                        // TOMBOL MASUK
                        Container(
                          width: double.infinity,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: const [
                              BoxShadow(color: Color(0xFFD8D5EA), blurRadius: 0, offset: Offset(0, 10)),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(15),
                              onTap: isLoading ? null : _onLoginPressed,
                              child: Center(
                                child: isLoading
                                    ? const SizedBox(
                                        width: 24, height: 24,
                                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0D253F)),
                                      )
                                    : Text(
                                        "Masuk",
                                        style: GoogleFonts.baloo2(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF0D253F)),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  // TOMBOL BACK
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
                        child: const Icon(Icons.chevron_left, color: Color(0xFF1A73E8), size: 28),
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