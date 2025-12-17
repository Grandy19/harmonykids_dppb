import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../shared/widgets/custom_header.dart'; 
import '../../shared/widgets/custom_bottom_nav.dart';

class HarmoTalkScreen extends StatefulWidget {
  const HarmoTalkScreen({super.key});

  @override
  State<HarmoTalkScreen> createState() => _HarmoTalkScreenState();
}

class _HarmoTalkScreenState extends State<HarmoTalkScreen> {
  final int _currentIndex = -1; // Navigasi mati
  
  String _selectedFilter = "Semua"; 
  String _selectedSort = "Terbaru"; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFD),
      body: Stack(
        children: [
          // ==========================================
          // KONTEN HALAMAN
          // ==========================================
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 250, left: 24, right: 24, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // --- FILTER & SORT BAR (Sesuai Gambar Referensi) ---
                Row(
                  children: [
                    // Tombol Filter: Semua
                    _buildFilterBtn("Semua"),
                    
                    const SizedBox(width: 10),
                    
                    // Tombol Filter: Post Saya
                    _buildFilterBtn("Post Saya"),
                    
                    const SizedBox(width: 10),
                    
                    // Dropdown Urutkan
                    Expanded(child: _buildSortDropdown()), 
                  ],
                ),

                // --- AREA KOSONG (Tempat Postingan Nanti) ---
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    "Area Konten Postingan\n(Kosong)",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.baloo2(color: Colors.grey[300]),
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // HEADER CUSTOM
          // ==========================================
          const Positioned(
            top: 0, left: 0, right: 0,
            child: CustomHeader(title: "HarmoTalk"), 
          ),
        ],
      ),
      
      // ==========================================
      // BOTTOM NAV
      // ==========================================
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _currentIndex, 
        onTap: (index) { if (index==0) Navigator.popUntil(context, (r) => r.isFirst); },
      ),
    );
  }

  // Widget Tombol Filter Sederhana
  Widget _buildFilterBtn(String title) {
    bool isActive = _selectedFilter == title;
    return InkWell(
      onTap: () => setState(() => _selectedFilter = title),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF3577E5) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
        ),
        child: Text(title, style: GoogleFonts.baloo2(
          color: isActive ? Colors.white : const Color(0xFF3577E5),
          fontWeight: FontWeight.bold,
          fontSize: 14, // Ukuran font disesuaikan agar rapi
        )),
      ),
    );
  }

  // Widget Dropdown Sort (Terbaru & Terpopuler)
  Widget _buildSortDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 40, 
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5)],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSort,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF3577E5)),
          isExpanded: true,
          style: GoogleFonts.baloo2(
            color: const Color(0xFF3577E5), 
            fontWeight: FontWeight.bold, 
            fontSize: 14
          ),
          items: ["Terbaru", "Terpopuler"].map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (val) => setState(() => _selectedSort = val!),
        ),
      ),
    );
  }
}