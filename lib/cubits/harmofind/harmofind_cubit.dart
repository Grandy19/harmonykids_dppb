import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/instansi_model.dart';
import '../../services/instansi_service.dart';

// --- STATE DEFINITION ---
abstract class HarmoFindState {}

class HarmoFindInitial extends HarmoFindState {} // Kondisi Awal (Belum pilih lokasi)
class HarmoFindLoading extends HarmoFindState {} // Sedang Loading
class HarmoFindLoaded extends HarmoFindState {
  final List<InstansiModel> instansiList;
  HarmoFindLoaded(this.instansiList);
}
class HarmoFindError extends HarmoFindState {
  final String message;
  HarmoFindError(this.message);
}

// --- CUBIT LOGIC ---
class HarmoFindCubit extends Cubit<HarmoFindState> {
  final InstansiService _service = InstansiService();

  HarmoFindCubit() : super(HarmoFindInitial());

  // Variable Filter disimpan di sini
  String? selectedLocation; // Bisa null di awal
  String selectedCategory = "TK/PG"; // Default kategori

  // 1. Fungsi Ganti Lokasi (Bandung/Bekasi/Surabaya)
  void changeLocation(String newLocation) {
    selectedLocation = newLocation;
    fetchData(); // Otomatis cari data saat lokasi berubah
  }

  // 2. Fungsi Ganti Kategori (TK/PG / Daycare)
  void changeCategory(String newCategory) {
    selectedCategory = newCategory;
    // Hanya cari data jika lokasi SUDAH dipilih. 
    // Kalau lokasi belum dipilih, cuma ganti kategori aja di memori, jangan request API.
    if (selectedLocation != null) {
      fetchData();
    } else {
      // Jika lokasi belum dipilih, UI tetap di state Initial, tapi variabel category terupdate
      emit(HarmoFindInitial()); 
    }
  }

  // 3. Fungsi Utama: Ambil Data ke API
  Future<void> fetchData() async {
    // Validasi: Lokasi wajib ada
    if (selectedLocation == null) return;

    emit(HarmoFindLoading()); // UI jadi Loading Spinner

    try {
      final data = await _service.fetchInstansi(
        kota: selectedLocation!,
        jenisInstansi: selectedCategory,
      );
      
      emit(HarmoFindLoaded(data)); // Berhasil -> Tampilkan List
    } catch (e) {
      emit(HarmoFindError(e.toString())); // Gagal -> Tampilkan Error
    }
  }
}