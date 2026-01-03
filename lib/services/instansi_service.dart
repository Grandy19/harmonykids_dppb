import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/instansi_model.dart';

class InstansiService {
  // Ganti IP sesuai server (10.0.2.2 utk Emulator Android, localhost utk iOS)
  final String baseUrl = "http://10.0.2.2:8000/api"; 

  Future<List<InstansiModel>> fetchInstansi({
    required String kota, 
    String? jenisInstansi // Opsional (TK/PG atau Daycare)
  }) async {
    // Bangun URL dengan Query Parameter
    // Contoh hasil: http://.../api/instansi?kota=Bandung&jenis_instansi=TK/PG
    String url = '$baseUrl/instansi?kota=$kota';
    
    if (jenisInstansi != null && jenisInstansi.isNotEmpty) {
      url += '&jenis_instansi=$jenisInstansi';
    }

    print("Requesting URL: $url"); // Debugging: Cek URL di terminal

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      
      // Ubah List JSON menjadi List Object InstansiModel
      return data.map((e) => InstansiModel.fromJson(e)).toList();
    } else {
      throw Exception('Gagal mengambil data instansi');
    }
  }
}