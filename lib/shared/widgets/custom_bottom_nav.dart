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
    
    // WARNA GRADIENT 
    const Gradient mainGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFF3577E5), 
        Color(0xFF0F3974), 
      ],
    );

    return SizedBox(
      height: 100, 
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // BACKGROUND BAR DENGAN LENGKUNGAN 
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: selectedIndex.toDouble()),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic, 
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

          // TOMBOL LINGKARAN MENGAMBANG
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: selectedIndex.toDouble()),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            builder: (context, animatedValue, child) {
              double itemWidth = size.width / 4;
              double xOffset = (itemWidth * animatedValue) + (itemWidth / 2) - (60 / 2);

              return Positioned(
                left: xOffset,
                top: 0, 
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF3577E5),
                    // SETTINGAN SHADOW 
                    boxShadow: [
                       BoxShadow(
                        color: const Color(0xFF6EC1E4).withOpacity(0.8),
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

          // IKON-IKON MENU (STATIS)
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

// PAINTER LENGKUNGAN
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
    
    // SETTINGAN PRESISI
    double itemWidth = size.width / itemsCount;
    double bumpCenterX = (itemWidth * selectedIndex) + (itemWidth / 2);
    double topY = 30; 
    double bottomY = topY +40; 
    double curveRadius = 38; 
    path.moveTo(0, topY);
    path.lineTo(bumpCenterX - curveRadius - 15, topY);
    path.cubicTo(
      bumpCenterX - curveRadius, topY,        
      bumpCenterX - curveRadius + 0, bottomY,   
      bumpCenterX, bottomY,                      
    );

    // LENGKUNGAN KANAN (BAHU NAIK)
    path.cubicTo(
      bumpCenterX + curveRadius - 0, bottomY,   
      bumpCenterX + curveRadius, topY,           
      bumpCenterX + curveRadius + 15, topY,      
    );

    path.lineTo(size.width, topY);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawShadow(path, Colors.black.withOpacity(0.15), 6.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _CurvedNavBarPainter oldDelegate) {
    return oldDelegate.selectedIndex != selectedIndex;
  }
}