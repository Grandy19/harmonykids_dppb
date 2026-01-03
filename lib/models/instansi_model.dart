class InstansiModel {
  final int id;
  final String nama;
  final String jenisInstansi; // TK/PG atau Daycare
  final String alamat;
  final String kota; // Bandung, Bekasi, Surabaya
  final String biayaDisplay; // Contoh: "Rp 350.000 / Bulan"
  final int biayaAngka; // Contoh: 350000 (untuk sorting/filter)
  final double rating;
  final bool isPopular;
  final String? thumbnailUrl; // URL lengkap gambar (http://...)
  final String? deskripsi;

  // Constructor
  InstansiModel({
    required this.id,
    required this.nama,
    required this.jenisInstansi,
    required this.alamat,
    required this.kota,
    required this.biayaDisplay,
    required this.biayaAngka,
    required this.rating,
    required this.isPopular,
    this.thumbnailUrl,
    this.deskripsi,
  });

  // Factory: Mengubah JSON dari Laravel menjadi Object Flutter
  factory InstansiModel.fromJson(Map<String, dynamic> json) {
    return InstansiModel(
      id: json['id'],
      nama: json['nama'],
      // Pastikan key string ('jenis_instansi') SAMA PERSIS dengan database Laravel
      jenisInstansi: json['jenis_instansi'] ?? '', 
      alamat: json['alamat'] ?? '',
      kota: json['kota'] ?? '',
      biayaDisplay: json['biaya_display'] ?? '',
      // Konversi aman ke int (kadang API kirim string angka)
      biayaAngka: int.tryParse(json['biaya_angka'].toString()) ?? 0,
      // Konversi aman ke double
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      // Konversi 1/0 ke boolean
      isPopular: json['is_popular'] == 1 || json['is_popular'] == true,
      // Ambil dari accessor 'thumbnail_url' yang kita buat di Laravel
      thumbnailUrl: json['thumbnail_url'], 
      deskripsi: json['deskripsi'],
    );
  }
}