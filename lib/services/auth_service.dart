import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';

class AuthService {
  // -----------------------------------------------------------------------
  // REGISTER WALI
  // -----------------------------------------------------------------------
  Future<Map<String, dynamic>> registerWali({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.registerWali);
      final response = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'name': name,
          'email': email,
          'nomor_telepon': phone,
          'jenis_kelamin': 'Laki-laki', 
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return { 'success': true, 'message': 'Registrasi Berhasil!' };
      } else {
        return { 'success': false, 'message': data['message'] ?? 'Gagal Daftar' };
      }
    } catch (e) {
      return { 'success': false, 'message': 'Error: $e' };
    }
  }

  // -----------------------------------------------------------------------
  // LOGIN (VERSI FINAL ANTI-CRASH)
  // -----------------------------------------------------------------------
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse(ApiConfig.login);
      
      // Print untuk cek di Debug Console
      print("Mencoba login ke: $url");

      final response = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // Print respon mentah dari server
      print("Respon Server: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // AMBIL TOKEN (Cari 'access_token' atau 'token')
        String token = data['access_token'] ?? data['token'] ?? '';
        
        // AMBIL USER DATA (Cari 'user' atau 'data')
        Map<String, dynamic> userData = {};
        if (data['user'] != null) {
          userData = Map<String, dynamic>.from(data['user']);
        } else if (data['data'] != null) {
          userData = Map<String, dynamic>.from(data['data']);
        }

        // AMBIL ROLE (Paksa string kosong jika null)
        String role = userData['role'] ?? 'wali';
        String name = userData['name'] ?? 'User';

        // Simpan ke HP
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('role', role);
        await prefs.setString('user_name', name);

        return { 'success': true, 'message': 'Login Berhasil!' };
      } else {
        return { 
          'success': false, 
          'message': data['message'] ?? 'Email/Password Salah' 
        };
      }
    } catch (e) {
      // Print error lengkapnya
      print("ERROR LOGIN: $e");
      return { 'success': false, 'message': 'Error Koneksi: $e' };
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}