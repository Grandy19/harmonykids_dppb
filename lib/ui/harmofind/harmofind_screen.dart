import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import Service, Model, dan Widget Card lo
import '../../services/instansi_service.dart';
import '../../models/instansi_model.dart';
import '../../shared/widgets/school_card.dart';
import '../../shared/widgets/custom_header.dart'; 
import '../../shared/widgets/custom_bottom_nav.dart';

class HarmoFindScreen extends StatefulWidget {
  const HarmoFindScreen({super.key});

  @override
  State<HarmoFindScreen> createState() => _HarmoFindScreenState();
}

class _HarmoFindScreenState extends State<HarmoFindScreen> {
  final int _currentIndex = 1;
  final InstansiService _apiService = InstansiService();

  // --- STATE DATA ---
  List<InstansiModel> _listInstansi = [];
  bool _isLoading = false;
  
  // --- STATE FILTER ---
  String? _selectedLocation = "Bandung"; // Default lokasi awal
  bool _isLocationDropdownOpen = false;

  String _selectedCategory = "TK/PG";
  
  String _selectedSort = "Terbaru";
  bool _isSortDropdownOpen = false;

  final List<String> _locations = ["Bandung", "Bekasi", "Surabaya"];
  final List<String> _sortOptions = ["Terbaru", "Terpopuler", "Harga Tertinggi", "Harga Terendah"];

  @override
  void initState() {
    super.initState();
    _loadData(); // Ambil data saat pertama kali buka screen
  }

  // --- FUNGSI AMBIL DATA API ---
  Future<void> _loadData() async {
    if (_selectedLocation == null) return;

    setState(() => _isLoading = true);
    try {
      final data = await _apiService.fetchInstansi(
        kota: _selectedLocation!,
        jenisInstansi: _selectedCategory,
      );

      setState(() {
        _listInstansi = data;
        _applySorting(); // Langsung urutkan setelah data datang
      });
    } catch (e) {
      debugPrint("Error API: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // --- LOGIKA SORTING LOKAL ---
  void _applySorting() {
    setState(() {
      if (_selectedSort == "Harga Tertinggi") {
        _listInstansi.sort((a, b) => b.biayaAngka.compareTo(a.biayaAngka));
      } else if (_selectedSort == "Harga Terendah") {
        _listInstansi.sort((a, b) => a.biayaAngka.compareTo(b.biayaAngka));
      } else if (_selectedSort == "Terpopuler") {
        _listInstansi.sort((a, b) => (b.isPopular ? 1 : 0).compareTo(a.isPopular ? 1 : 0));
      }
      // Untuk "Terbaru", biasanya urutan default dari API sudah terbaru (berdasarkan ID)
    });
  }

  String get _displaySortLabel {
    if (_selectedSort == "Harga Tertinggi") return "Tertinggi";
    if (_selectedSort == "Harga Terendah") return "Terendah";
    return _selectedSort;
  }

  @override
  Widget build(BuildContext context) {
    const double headerHeight = 220; 
    const double locationTop = headerHeight;
    const double filterRowTop = locationTop + 80; 
    const double contentPaddingTop = filterRowTop + 70;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFD),
      body: Stack(
        children: [
          // --- LAYER 1: KONTEN (List Sekolah) ---
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: contentPaddingTop, left: 24, right: 24, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rekomendasi Sekolah",
                  style: GoogleFonts.baloo2(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF2A2A2A)),
                ),
                const SizedBox(height: 16),

                // LOGIKA TAMPILAN (Loading / Empty / List)
                if (_isLoading)
                  const Center(child: Padding(padding: EdgeInsets.only(top: 50), child: CircularProgressIndicator()))
                else if (_listInstansi.isEmpty)
                  _buildEmptyState()
                else
                  ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _listInstansi.length,
                    itemBuilder: (context, index) {
                      return SchoolCard(
                        instansi: _listInstansi[index],
                        onTap: () {
                          // Navigasi ke Detail nanti
                        },
                      );
                    },
                  ),
              ],
            ),
          ),

          // --- LAYER 2: HEADER ---
          const Positioned(top: 0, left: 0, right: 0, child: CustomHeader(title: "Cari Sekolah")),

          // --- LAYER 3: CATEGORY BUTTONS ---
          Positioned(
            top: filterRowTop,
            left: 24,
            child: Row(
              children: [
                _buildCategoryBtn("TK/PG"),
                const SizedBox(width: 10),
                _buildCategoryBtn("Daycare"),
              ],
            ),
          ),

          // --- LAYER 4: DROPDOWN URUTKAN (Z-Index Menengah) ---
          Positioned(
            top: filterRowTop,
            left: 24 + 80 + 10 + 80 + 10, 
            right: 24,
            child: _buildCustomSortDropdown(),
          ),

          // --- LAYER 5: DROPDOWN LOKASI (Paling Atas) ---
          Positioned(
            top: locationTop, 
            left: 24, 
            right: 24,
            child: _buildCustomLocationDropdown(),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _currentIndex,
        onTap: (index) { if (index == 0) Navigator.popUntil(context, (r) => r.isFirst); },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Icon(Icons.search_off_rounded, size: 80, color: Colors.grey[200]),
          const SizedBox(height: 16),
          Text(
            "Tidak ada sekolah ditemukan\ndi $_selectedLocation untuk $_selectedCategory",
            textAlign: TextAlign.center,
            style: GoogleFonts.baloo2(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }

  // ==================== DROPDOWN & BUTTON BUILDERS ====================

  Widget _buildCustomLocationDropdown() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), 
        boxShadow: [BoxShadow(color: const Color(0xFF3577E5).withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() { _isLocationDropdownOpen = !_isLocationDropdownOpen; _isSortDropdownOpen = false; }),
            borderRadius: BorderRadius.circular(20),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Color(0xFF3577E5), size: 22),
                  const SizedBox(width: 12),
                  Expanded(child: Text(_selectedLocation ?? "Pilih Lokasi", style: GoogleFonts.baloo2(color: const Color(0xFF2A2A2A), fontSize: 16, fontWeight: FontWeight.bold))),
                  Icon(_isLocationDropdownOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: const Color(0xFF3577E5)),
                ],
              ),
            ),
          ),
          if (_isLocationDropdownOpen)
            ..._locations.map((loc) => Column(
              children: [
                Divider(height: 1, color: Colors.grey[100]),
                InkWell(
                  onTap: () {
                    setState(() { _selectedLocation = loc; _isLocationDropdownOpen = false; });
                    _loadData(); // RE-FETCH API
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Text(loc, style: GoogleFonts.baloo2(fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildCustomSortDropdown() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () => setState(() { _isSortDropdownOpen = !_isSortDropdownOpen; _isLocationDropdownOpen = false; }),
            borderRadius: BorderRadius.circular(15),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.sort_rounded, color: Color(0xFF3577E5), size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(_displaySortLabel, style: GoogleFonts.baloo2(color: const Color(0xFF3577E5), fontSize: 14, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
                  Icon(_isSortDropdownOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, color: const Color(0xFF3577E5), size: 20),
                ],
              ),
            ),
          ),
          if (_isSortDropdownOpen)
            ..._sortOptions.map((val) => Column(
              children: [
                Divider(height: 1, color: Colors.grey[500]),
                InkWell(
                  onTap: () {
                    setState(() { _selectedSort = val; _isSortDropdownOpen = false; });
                    _applySorting(); // SORT LOKAL SAJA
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Text(val.replaceFirst("Harga ", ""), style: GoogleFonts.baloo2(fontSize: 13, fontWeight: _selectedSort == val ? FontWeight.bold : FontWeight.w500)),
                  ),
                ),
              ],
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildCategoryBtn(String title) {
    bool isActive = _selectedCategory == title;
    return InkWell(
      onTap: () {
        setState(() => _selectedCategory = title);
        _loadData(); // RE-FETCH API
      },
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3577E5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Text(title, style: GoogleFonts.baloo2(color: isActive ? Colors.white : const Color(0xFF3577E5), fontWeight: FontWeight.bold, fontSize: 13)),
      ),
    );
  }
}