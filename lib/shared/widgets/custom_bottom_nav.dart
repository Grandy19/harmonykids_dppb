import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    
    // WARNA GRADIENT (Sesuai Request: 3577E5 -> 0F3974)
    const Gradient mainGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF3577E5), // Biru Terang
        Color(0xFF0F3974), // Biru Gelap
      ],
    );

    return SizedBox(
      height: 100, 
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 1. BACKGROUND BAR DENGAN LENGKUNGAN ORGANIK
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: selectedIndex.toDouble()),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic, // Curve lebih smooth
            builder: (context, animatedValue, child) {
              return CustomPaint(
                size: Size(size.width, 100),
                painter: _CurvedNavBarPainter(
                  selectedIndex: animatedValue,
                  itemsCount: 4,
                  gradient: mainGradient,
                ),
              );
            },
          ),

          // 2. TOMBOL LINGKARAN MENGAMBANG
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: selectedIndex.toDouble()),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, child) {
              double itemWidth = size.width / 4;
              // Posisi X tepat di tengah item
              double xOffset = (itemWidth * animatedValue) + (itemWidth / 2) - (60 / 2);

              return Positioned(
                left: xOffset,
                top: 0, // Posisi lingkaran (Floating)
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF3577E5), // Warna Biru Terang Solid
                    // SETTINGAN SHADOW PERSIS SESUAI GAMBAR REFERENCE ANDA
                    // (Position Y: 2, Blur: 30, Color: 6EC1E4)
                    boxShadow: [
                       BoxShadow(
                        color: const Color(0xFF6EC1E4).withOpacity(0.8), // Opacity disesuaikan agar tidak terlalu silau
                        blurRadius: 30, 
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                    // Border putih tipis
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 2),
                  ),
                  child: Center(
                    child: Icon(
                      _getIcon(selectedIndex),
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
              );
            },
          ),

          // 3. IKON-IKON MENU (STATIS)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded),
                _buildNavItem(1, Icons.access_time_filled_rounded),
                _buildNavItem(2, Icons.notifications_rounded),
                _buildNavItem(3, Icons.settings_rounded),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0: return Icons.home_rounded;
      case 1: return Icons.access_time_filled_rounded;
      case 2: return Icons.notifications_rounded;
      case 3: return Icons.settings_rounded;
      default: return Icons.home_rounded;
    }
  }

  Widget _buildNavItem(int index, IconData icon) {
    bool isSelected = index == selectedIndex;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 60,
        height: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 15.0), 
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isSelected ? 0.0 : 1.0, 
                child: Icon(
                  icon,
                  color: Colors.white.withOpacity(0.8),
                  size: 28,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- PAINTER LENGKUNGAN ORGANIK (REVISI TOTAL) ---
class _CurvedNavBarPainter extends CustomPainter {
  final double selectedIndex; 
  final int itemsCount;
  final Gradient gradient;

  _CurvedNavBarPainter({
    required this.selectedIndex,
    required this.itemsCount,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    Path path = Path();
    
    // --- SETTINGAN PRESISI AGAR MIRIP SCREENSHOT ---
    double itemWidth = size.width / itemsCount;
    double bumpCenterX = (itemWidth * selectedIndex) + (itemWidth / 2);
    
    // Bar dimulai dari Y=30 (memberi ruang untuk kepala lingkaran)
    double topY = 30; 
    // Kedalaman cekungan (titik terbawah)
    double bottomY = topY +40; 
    
    // Radius kelengkungan (lebar bahu)
    double curveRadius = 38; 

    path.moveTo(0, topY);

    // 1. Garis lurus kiri sampai mendekati lengkungan
    path.lineTo(bumpCenterX - curveRadius - 15, topY);

    // 2. LENGKUNGAN KIRI (BAHU TURUN)
    // Ini kuncinya: Control point pertama sejajar horizontal (topY) agar mulus
    path.cubicTo(
      bumpCenterX - curveRadius, topY,           // CP1: Bahu kiri (tetap datar)
      bumpCenterX - curveRadius + 0, bottomY,   // CP2: Lereng curam ke bawah
      bumpCenterX, bottomY,                      // END: Dasar mangkuk
    );

    // 3. LENGKUNGAN KANAN (BAHU NAIK)
    path.cubicTo(
      bumpCenterX + curveRadius - 0, bottomY,   // CP1: Lereng curam naik
      bumpCenterX + curveRadius, topY,           // CP2: Bahu kanan (kembali datar)
      bumpCenterX + curveRadius + 15, topY,      // END: Kembali ke garis lurus
    );

    // 4. Garis lurus sisa ke kanan
    path.lineTo(size.width, topY);

    // 5. Tutup shape
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    // Gambar Bayangan Bar (Shadow halus di bawah bar)
    canvas.drawShadow(path, Colors.black.withOpacity(0.15), 6.0, true);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvedNavBarPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}