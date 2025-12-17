import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import '../../core/app_colors.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFD),
      
      // PERUBAHAN DISINI: SingleChildScrollView membungkus seluruh Stack
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
            // ==========================================
            // 1. KONTEN (BANNER & MENU) - LAYER BELAKANG
            // ==========================================
            Padding(
              // Padding Top 280 agar konten muncul di bawah Header
              padding: const EdgeInsets.only(top: 280, bottom: 100), 
              child: Column(
                children: [
                  _buildPromoBanner(size),

                  const SizedBox(height: 20), // Jarak 20px

                  _buildMenuGrid(),
                ],
              ),
            ),

            // ==========================================
            // 2. HEADER - LAYER DEPAN (IKUT SCROLL)
            // ==========================================
            // Karena berada di dalam SingleChildScrollView, 
            // Header ini akan ikut naik ke atas saat di-scroll.
            const Positioned(
              top: 0, 
              left: 0, 
              right: 0,
              child: HomeHeader(),
            ),
          ],
        ),
      ),
    );
  }

  // WIDGET CARD BANNER
  Widget _buildPromoBanner(Size size) {
    return Container(
      width: double.infinity,
      height: 160,
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF3577E5), Color(0xFF5A9BF8)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3577E5).withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.5,
                  child: Text(
                    "“Cari Sekolah Anak Lebih Mudah”",
                    style: GoogleFonts.baloo2(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFD8D5EA),
                          blurRadius: 0,
                          offset: Offset(0, 6),
                        )
                      ]
                    ),
                    child: Text(
                      "Klik Disini",
                      style: GoogleFonts.baloo2(
                        color: const Color(0xFF0F3974),
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Positioned(
            right: 5,
            bottom: 17,
            child: Image.asset(
              'assets/images/anak_playground.png',
              height: 130,
              fit: BoxFit.contain,
              errorBuilder: (ctx, err, stack) => const Icon(Icons.boy, size: 80, color: Colors.white24),
            ),
          ),
        ],
      ),
    );
  }

  // WIDGET GRID MENU
  Widget _buildMenuGrid() {
    final List<Map<String, dynamic>> menus = [
      {'title': 'HarmoFind', 'img': 'assets/images/find.png'},
      {'title': 'HarmoView', 'img': 'assets/images/view.png'},
      {'title': 'HarmoTalent', 'img': 'assets/images/talent.png'},
      {'title': 'HarmoTalk', 'img': 'assets/images/talk.png'},
      {'title': 'HarmoRide', 'img': 'assets/images/ride.png'},
      {'title': 'HarmoTale', 'img': 'assets/images/tale.png'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 15,
        ),
        itemCount: menus.length,
        itemBuilder: (context, index) {
          final menu = menus[index];
          return InkWell(
            onTap: () {
              // Logika Navigasi
              if (menu['title'] == 'HarmoView') {
                Navigator.pushNamed(context, '/harmoview');
              } else if (menu['title'] == 'HarmoTalk') {
                Navigator.pushNamed(context, '/harmotalk');
              } else {
                // Placeholder untuk menu lain yang belum ada halamannya
                print("${menu['title']} diklik");
              }
            },
            borderRadius: BorderRadius.circular(16), // Efek ripple rounded
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 1,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    menu['img'],
                    fit: BoxFit.contain,
                    errorBuilder: (ctx, err, stack) {
                      return Icon(
                        menu['icon'] ?? Icons.image,
                        size: 30,
                        color: menu['color'] ?? Colors.orange,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  menu['title'],
                  textAlign: TextAlign.center,
                  style: GoogleFonts.baloo2(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F3974),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// KODE HEADER (TETAP SAMA)
// ==========================================
class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  String? selectedLokasi;
  bool isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    // --- SETTINGAN TINGGI (Dinamis untuk dropdown) ---
    const double textureHeight = 245.0;
    const double cloudTop = 195.0; 
    const double searchBarTop = 115.0; 
    
    // Header akan memanjang jika dropdown terbuka
    final double headerHeight = isDropdownOpen ? 450.0 : 300.0;

    return SizedBox(
      height: headerHeight,
      child: Stack(
        children: [
          // 1. BACKGROUND TEXTURE BIRU
          Positioned(
            top: 0, left: 0, right: 0,
            height: textureHeight,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/texture.png'), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // 2. GAMBAR AWAN
          Positioned(
            top: cloudTop, 
            left: 0, right: 0,
            child: Image.asset(
              'assets/images/cloud.png',
              height: 70, 
              fit: BoxFit.fill,
            ),
          ),

// 3. KONTEN PROFILE
          Positioned(
            top: 30, left: 24, right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // --- UBAH DI SINI: Bungkus Container Avatar dengan GestureDetector ---
                    GestureDetector(
                      onTap: () {
                        // Arahkan ke route Edit Profile
                        Navigator.pushNamed(context, '/edit_profile');
                      },
                      child: Container(
                        width: 40, height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: const DecorationImage(
                            image: AssetImage('assets/images/avatar.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    // ---------------------------------------------------------------------

                    const SizedBox(width: 12),
                    
                    // Opsional: Bungkus Teks juga biar bisa diklik (jika mau)
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/edit_profile'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Hallo, Selamat Datang!",
                              style: GoogleFonts.baloo2(color: Colors.white.withOpacity(0.9), fontSize: 14)),
                          Text("Dewi Rosari",
                              style: GoogleFonts.baloo2(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800, height: 1.1)),
                        ],
                      ),
                    ),
                  ],
                ),
                
                // Logo di kanan (tetap sama)
                Image.asset(
                  'assets/images/logo.png',
                  height: 65, fit: BoxFit.contain,
                  errorBuilder: (ctx, err, stack) => const Icon(Icons.image, color: Colors.orange),
                ),
              ],
            ),
          ),

          // 4. SEARCH BAR & DROPDOWN (URUTAN TERAKHIR = PALING ATAS/DEPAN)
          Positioned(
            top: searchBarTop, 
            left: 24, right: 24,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => setState(() => isDropdownOpen = !isDropdownOpen),
                  child: Container(
                    height: 55, 
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(isDropdownOpen ? 16 : 16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15), 
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: Color(0xFF3577E5), size: 25),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            selectedLokasi ?? "Pilih Lokasi",
                            style: GoogleFonts.baloo2(
                              color: selectedLokasi == null ? Colors.grey[400] : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontStyle: selectedLokasi == null ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                        ),
                        Icon(
                          isDropdownOpen ? Icons.keyboard_arrow_up_rounded : Icons.keyboard_arrow_down_rounded, 
                          color: Colors.blue[400], size: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                
                if (isDropdownOpen)
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildDropdownItem("Bandung"),
                        const Divider(height: 1),
                        _buildDropdownItem("Bekasi"),
                        const Divider(height: 1),
                        _buildDropdownItem("Surabaya"),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownItem(String city) {
    return InkWell(
      onTap: () => setState(() { selectedLokasi = city; isDropdownOpen = false; }),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        child: Text(city, style: GoogleFonts.baloo2(fontSize: 14, fontWeight: FontWeight.w600)),
      ),
    );
  }
}