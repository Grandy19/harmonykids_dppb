import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class ProfileService {
  // Ganti IP sesuai server (10.0.2.2 utk Emulator Android, localhost utk iOS/Web)
  final String baseUrl = "http://10.0.2.2:8000/api"; 

  // Helper: Ambil Token
  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token'); 
  }

  // A. GET DATA USER
  Future<UserModel> getProfile() async {
    String? token = await _getToken();
    
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return UserModel.fromJson(data);
    } else {
      throw Exception('Gagal load profil: ${response.statusCode}');
    }
  }

  // B. UPDATE DATA USER (Multipart)
  Future<bool> updateProfile({
    required String name,
    required String email,
    // Parameter disesuaikan agar lebih jelas
    required String alamat,
    required String noTelepon,
    required String gender,
    required String pekerjaan,
    required String hubungan, // Tambahan field Hubungan
    File? imageFile,
  }) async {
    String? token = await _getToken();
    var uri = Uri.parse('$baseUrl/profile/update');
    
    var request = http.MultipartRequest('POST', uri);
    
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    // --- MAPPING DATA KE BAHASA INDONESIA (Sesuai Controller Laravel) ---
    request.fields['name'] = name;
    request.fields['email'] = email;
    
    // PERHATIKAN: Key string di kiri ['...'] WAJIB sama dengan di Controller Laravel
    request.fields['alamat'] = alamat; 
    request.fields['nomor_telepon'] = noTelepon; 
    request.fields['jenis_kelamin'] = gender;
    request.fields['pekerjaan'] = pekerjaan; 
    request.fields['hubungan_dengan_anak'] = hubungan; 

    // Kirim File Gambar (Jika User Ganti Foto)
    if (imageFile != null) {
      var photoStream = await http.MultipartFile.fromPath(
        'photo', // Key ini HARUS SAMA dengan $request->file('photo') di Laravel
        imageFile.path
      );
      request.files.add(photoStream);
    }

    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        print("Sukses Update: ${response.body}");
        return true; 
      } else {
        print("Gagal Update Backend: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error Koneksi: $e");
      return false;
    }
  }
}