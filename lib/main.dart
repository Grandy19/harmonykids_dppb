import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// --- IMPORT CORE & WIDGETS ---
import 'core/app_colors.dart';
import 'shared/widgets/custom_bottom_nav.dart';

// --- IMPORT SCREENS ---
import 'ui/welcome/welcome_screen.dart';
import 'ui/login/login.screen.dart'; 
import 'ui/register/register_screen.dart'; 
import 'ui/home/home_screen.dart'; 

// Fitur-fitur
import 'ui/harmoview/harmoview_screen.dart'; 
import 'ui/harmotalk/harmotalk_screen.dart';
import 'package:harmonykids/ui/profile/edit_profile_screen.dart';
import 'package:harmonykids/ui/harmofind/harmofind_screen.dart'; // <--- TAMBAHAN: Import HarmoFind

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
      
      // Tema Aplikasi
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        textTheme: GoogleFonts.baloo2TextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      
      initialRoute: '/', 
      
      // Daftar Route (Navigasi)
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
        '/home': (context) => const MainScreen(), // Alias ke MainScreen
        
        // --- FITUR ---
        '/harmoview': (context) => const HarmoviewScreen(),
        '/harmotalk': (context) => const HarmoTalkScreen(),
        '/harmofind': (context) => const HarmoFindScreen(), // <--- TAMBAHAN: Route HarmoFind
        
        // --- PROFILE ---
        // Hapus 'const' di sini agar tidak error jika ada perubahan state/bloc
        '/edit_profile': (context) => EditProfileScreen(), 
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  // Daftar Halaman untuk Bottom Navigation
  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text("Halaman Riwayat")),     // Placeholder
    const Center(child: Text("Halaman Notifikasi")),  // Placeholder
    const Center(child: Text("Halaman Pengaturan")),  // Placeholder
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, // Agar konten bisa di belakang navbar (opsional)
      
      body: _pages[_currentIndex],
      
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}