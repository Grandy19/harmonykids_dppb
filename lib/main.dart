import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- IMPORT FILE-FILE YANG SUDAH DIBUAT ---
import 'core/app_colors.dart';
import 'shared/widgets/custom_header.dart';
import 'shared/widgets/custom_bottom_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Harmony Kids',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        textTheme: GoogleFonts.baloo2TextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      // Kita arahkan langsung ke halaman utama yang punya Navigasi
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Variabel untuk menyimpan index menu yang sedang dipilih (0 = Beranda)
  int _currentIndex = 0;

  // List Halaman sederhana untuk simulasi ganti menu
  final List<Widget> _pages = [
    const Center(child: Text("Halaman Beranda")),
    const Center(child: Text("Halaman Riwayat")),
    const Center(child: Text("Halaman Notifikasi")),
    const Center(child: Text("Halaman Pengaturan")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      
      // PENTING: extendBody: true membuat konten bisa memanjang sampai ke belakang
      // navigation bar. Ini wajib agar efek lengkungan transparan terlihat bagus.
      extendBody: true, 

      body: Column(
        children: [
          // 1. HEADER (Awan, Lebah, Kapsul Judul)
          const CustomHeader(),
          
          // 2. KONTEN (Berubah sesuai menu yang dipilih)
          Expanded(
            child: _pages[_currentIndex],
          ),
        ],
      ),

      // 3. BOTTOM NAVIGATION BAR (Navigasi Bawah Melengkung)
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update halaman saat ikon diklik
          });
        },
      ),
    );
  }
}