import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/app_colors.dart'; 

class CustomHeader extends StatelessWidget {
  const CustomHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Tinggi Header Total
    const double headerHeight = 240.0;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        children: [
          // 1. BACKGROUND TEXTURE
          Container(
            height: headerHeight - 50, 
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/texture.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 2. GAMBAR AWAN
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/cloud.png',
              fit: BoxFit.fill,
              height: 80,
            ),
          ),

          // 3. Kapsul Judul
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                height: 65, 
                decoration: BoxDecoration(
                  color: AppColors.white, 
                  borderRadius: BorderRadius.circular(20), 
                  
                  boxShadow: [
                    // Layer 1: Glow
                    BoxShadow(
                      color: const Color(0xFF6EC1E4).withOpacity(0.6), 
                      blurRadius: 20, 
                      spreadRadius: 0, 
                      offset: const Offset(0, 5),
                    ),
                    // Layer 2: Shadow Tebal
                    BoxShadow(
                      color: const Color(0xFFD8D5EA), 
                      blurRadius: 0, 
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.primaryDark,
                        size: 28,
                        shadows: const [
                          Shadow(
                            color: AppColors.primaryDark, 
                            blurRadius: 0.5, 
                            offset: Offset(0.5, 0.5), 
                          ),
                          Shadow(
                            color: AppColors.primaryDark,
                            blurRadius: 0.5,
                            offset: Offset(-0.2, -0.2), 
                          ),
                        ],
                      ),
                    ),
                    
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 4.0), 
                        child: Text(
                          "HarmoFind", 
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.baloo2(
                            fontSize: 24,
                            fontWeight: FontWeight.w800, 
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),

                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.star_rounded,
                        color: AppColors.accentYellow,
                        size: 40, 
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Gambar Lebah
          Positioned(
            top: 35,
            left: 10,
            child: Transform.rotate(
              angle: -0.1,
              child: Image.asset(
                'assets/images/bee.png',
                width: 65, 
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.bug_report, size: 50, color: Colors.orange);
                },
              ),
            ),
          ),
          
          // 5. Titik Putih
          Positioned(
            top: 90,
            right: 15,
            child: Container(
              width: 12,
              height: 12,
              decoration: const BoxDecoration(
                color: AppColors.white, 
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}