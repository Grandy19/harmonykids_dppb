import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool isPassword;
  final bool isObscure;
  final VoidCallback? onToggleObscure;
  final TextInputType inputType;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.isObscure = false,
    this.onToggleObscure,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    // Warna biru utama
    final Color primaryBlue = const Color(0xFF1A73E8);

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
        obscureText: isPassword ? isObscure : false,
        keyboardType: inputType,
        style: GoogleFonts.baloo2(
          color: primaryBlue,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: GoogleFonts.baloo2(
            color: primaryBlue.withOpacity(0.6),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0),
            child: Icon(icon, color: primaryBlue, size: 26),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 50),
          suffixIcon: isPassword
              ? IconButton(
                  onPressed: onToggleObscure,
                  icon: Icon(
                    isObscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    color: primaryBlue.withOpacity(0.6),
                    size: 22,
                  ),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}