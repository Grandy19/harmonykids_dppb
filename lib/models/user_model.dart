class UserModel {
  final int id;
  final String name;
  final String email;
  final String? nomorTelepon;
  final String? jenisKelamin;
  final String? alamat;
  final String? pekerjaan;
  final String? hubunganDenganAnak; // CamelCase di Dart
  final String? fotoProfil;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.nomorTelepon,
    this.jenisKelamin,
    this.alamat,
    this.pekerjaan,
    this.hubunganDenganAnak,
    this.fotoProfil,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      // Ambil sesuai nama kolom database/JSON response
      nomorTelepon: json['nomor_telepon'], 
      jenisKelamin: json['jenis_kelamin'],
      alamat: json['alamat'],
      pekerjaan: json['pekerjaan'],
      hubunganDenganAnak: json['hubungan_dengan_anak'],
      fotoProfil: json['foto_profil'] != null 
          ? 'http://10.0.2.2:8000/storage/${json['foto_profil']}' // Langsung rakit URL disini biar gampang
          : null,
    );
  }
}