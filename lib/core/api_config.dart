class ApiConfig {
  static const String baseUrl = "http://10.0.2.2:8000/api"; 

  // ENDPOINTS (DAFTAR ALAMAT)
  
  // --- Auth ---
  static const String login = "$baseUrl/login";
  static const String registerWali = "$baseUrl/register/wali";
  static const String registerPengelola = "$baseUrl/register/pengelola";
  static const String logout = "$baseUrl/logout";

  // Profile / User
  static const String user = "$baseUrl/user"; 
  static const String updateProfile = "$baseUrl/profile/update"; // Sesuaikan route Laravel nanti

  // Instansi / Sekolah
  static const String instansi = "$baseUrl/instansi";

  // HEADERS (PENGATURAN DATA)
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Helper untuk Header dengan Token (Dipakai saat akses halaman Home/Profil)
  static Map<String, String> tokenHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}