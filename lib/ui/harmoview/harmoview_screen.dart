import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import Widget Custom
import '../../shared/widgets/custom_header.dart'; 
import '../../shared/widgets/custom_bottom_nav.dart';

class HarmoviewScreen extends StatefulWidget {
  const HarmoviewScreen({super.key});

  @override
  State<HarmoviewScreen> createState() => _HarmoviewScreenState();
}

class _HarmoviewScreenState extends State<HarmoviewScreen> {
  // Index -1 agar tidak ada indikator aktif di bottom nav
  final int _currentIndex = -1; 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFD),
      
      body: Stack(
        children: [
          // ==========================================
          // LAYER 1: KONTEN SCROLL (DI BELAKANG HEADER)
          // ==========================================
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            // Padding Top 260-280 disesuaikan agar konten muncul pas di bawah Header
            padding: const EdgeInsets.only(top: 250, left: 24, right: 24, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                
                // --- NOTE: Header Manual (Row) sudah DIHAPUS ---
                // Konten langsung dimulai dengan Input Field

                // INPUT 1: Tk Ceria (Biru)
                _buildCompareInput(
                  text: "Tk Ceria",
                  dotColor: const Color(0xFF2E7CF6), // Biru
                ),

                const SizedBox(height: 30),

                // LABEL TENGAH
                Text(
                  "Cari untuk Membandingkan",
                  style: GoogleFonts.baloo2(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3577E5),
                  ),
                ),

                const SizedBox(height: 15),

                // INPUT 2: Tk Harapan (Merah)
                _buildCompareInput(
                  text: "Tk Harapan",
                  dotColor: const Color(0xFFEA4335), // Merah
                ),

                // AREA UNTUK DIAGRAM (Placeholder)
                const SizedBox(height: 50),
                Center(
                  child: Column(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey.withOpacity(0.2)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bar_chart_rounded, size: 60, color: Colors.grey[300]),
                            const SizedBox(height: 10),
                            Text(
                              "Area Diagram Perbandingan\n(Akan dimuat dari Database)",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.baloo2(
                                color: Colors.grey[400], 
                                fontSize: 14,
                                fontWeight: FontWeight.w500
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==========================================
          // LAYER 2: CUSTOM HEADER (FIXED DI ATAS)
          // ==========================================
          const Positioned(
            top: 0, left: 0, right: 0,
            // Memanggil CustomHeader dengan Judul "HarmoView"
            // Tombol Back sudah otomatis ada di dalam widget ini
            child: CustomHeader(
              title: "HarmoView",
            ), 
          ),
        ],
      ),

      // ==========================================
      // BOTTOM NAV
      // ==========================================
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _currentIndex, 
        onTap: (index) {
          if (index == 0) {
             // Kembali ke Home jika ikon Home diklik
             Navigator.popUntil(context, (route) => route.isFirst);
          }
        },
      ),
    );
  }

  // WIDGET CARD PENCARIAN (Helper)
  Widget _buildCompareInput({
    required String text,
    required Color dotColor,
  }) {
    return Container(
      width: double.infinity,
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.search_rounded,
            color: Colors.grey[400],
            size: 26,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.baloo2(
                color: const Color(0xFF3577E5),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}