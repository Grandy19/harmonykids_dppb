import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/app_colors.dart';
import 'shared/widgets/custom_bottom_nav.dart';
import 'ui/home/home_screen.dart'; 
import 'ui/welcome/welcome_screen.dart';
import 'ui/login/login.screen.dart'; 
import 'ui/register/register_screen.dart'; 
// 1. IMPORT FILE HARMOVIEW
import 'ui/harmoview/harmoview_screen.dart'; 
import 'ui/harmotalk/harmotalk_screen.dart';
import 'ui/profile/edit_profile_screen.dart';

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
      initialRoute: '/', 
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/main': (context) => const MainScreen(),
        // 2. DAFTARKAN ROUTE HARMOVIEW DI SINI
        '/harmoview': (context) => const HarmoviewScreen(),
        '/harmotalk': (context) => const HarmoTalkScreen(),
        '/edit_profile': (context) => const EditProfileScreen(),
      },
    );
  }
}

// ... (Class MainScreen tetap sama)
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomeScreen(),
    const Center(child: Text("Halaman Riwayat")),
    const Center(child: Text("Halaman Notifikasi")),
    const Center(child: Text("Halaman Pengaturan")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true, 
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