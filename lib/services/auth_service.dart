import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_config.dart';

class AuthService {
  
  // REGISTER WALI (Aman)
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
        if (data['access_token'] != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', data['access_token'].toString());
          await prefs.setString('role', 'wali');
          await prefs.setString('user_name', name);
        }
        return {'success': true, 'message': 'Registrasi Berhasil!'};
      } else {
        return {'success': false, 'message': data['message']?.toString() ?? 'Gagal Daftar'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }

  // --- LOGIN VERSI DETEKTIF (DEBUGGING) ---
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print("[1] Mulai Login...");
      final url = Uri.parse(ApiConfig.login);
      
      print("[2] Request ke: $url");
      final response = await http.post(
        url,
        headers: ApiConfig.defaultHeaders,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print("[3] Status Code: ${response.statusCode}");
      print("[4] Body Mentah: ${response.body}");

      // Cek apakah response HTML (Server Error 500/404)
      if (response.body.trim().startsWith("<")) {
         return {'success': false, 'message': 'Server Error (HTML). Cek Terminal Laravel.'};
      }

      final data = jsonDecode(response.body);
      print("[5] JSON Decode Berhasil");

      if (response.statusCode == 200 && (data['success'] == true || data['token'] != null)) {
        
        print("[6] Mulai Ambil Data...");

        // GUNAKAN TEKNIK AMAN (Fallback ke String Kosong)
        String token = (data['access_token'] ?? data['token'] ?? '').toString();
        print("[7] Token aman: $token");

        // Deteksi struktur data user
        Map<String, dynamic> userData = {};
        if (data['data'] != null && data['data'] is Map) {
          userData = Map<String, dynamic>.from(data['data']);
        } else if (data['user'] != null && data['user'] is Map) {
          userData = Map<String, dynamic>.from(data['user']);
        }
        print("[8] User Data object ditemukan");

        String role = (userData['role'] ?? 'wali').toString();
        print("[9] Role aman: $role");
        
        String name = (userData['name'] ?? 'User').toString();
        print("[10] Name aman: $name");
        
        String userId = (userData['id'] ?? 0).toString();
        print("[11] ID aman: $userId");

        // Simpan ke HP
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('role', role);
        await prefs.setString('user_name', name);
        await prefs.setString('user_id', userId);
        
        print("[12] Sukses Simpan ke HP. Login Selesai.");
        return {'success': true, 'message': 'Login Berhasil!'};
      } else {
        String errMsg = data['message']?.toString() ?? 'Email atau Password Salah';
        return {'success': false, 'message': errMsg};
      }
    } catch (e, stackTrace) {
      print("[CRASH] Error Login: $e");
      print("[TRACE] $stackTrace");
      return {'success': false, 'message': 'Gagal: $e'};
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}