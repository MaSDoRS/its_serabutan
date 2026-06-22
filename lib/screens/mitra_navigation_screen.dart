import 'package:flutter/material.dart';
import 'beranda_mitra_screen.dart';
import 'upload_showcase_screen.dart';
import 'profile_mitra_screen.dart';

class MitraNavigationScreen extends StatefulWidget {
  const MitraNavigationScreen({super.key});

  @override
  State<MitraNavigationScreen> createState() => _MitraNavigationScreenState();
}

class _MitraNavigationScreenState extends State<MitraNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    BerandaMitraScreen(),
    UploadShowcaseScreen(),
    ProfileMitraScreen(),
  ];

  // Keahlian aktif mitra
  final List<String> _keahlianAktif = const [
    'Antar Jemput',
    'Tenaga & Logistik',
    'Kebersihan',
    'Jastip & Belanja',
    'Perbaikan Ringan',
    'Sosial & Lainnya',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            // Shared header
            _buildMitraHeader(),
            // Screen content
            Expanded(
              child: IndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF29B6F6),
          unselectedItemColor: Colors.grey.shade400,
          selectedFontSize: 11,
          unselectedFontSize: 11,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.assignment_outlined),
              activeIcon: Icon(Icons.assignment),
              label: 'Order Masuk',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.cloud_upload_outlined),
              activeIcon: Icon(Icons.cloud_upload),
              label: 'Upload Showcase',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMitraHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF29B6F6),
            Color(0xFF03A9F4),
            Color(0xFF0288D1),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            // Row: Greeting + Mascot
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: 'Halo, ',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            TextSpan(
                              text: 'Ghaly Rakha!',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFFD54F),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Peran Keahlian Aktif Anda:',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                ClipOval(
                  child: Transform.scale(
                    scale: 1.4,
                    child: Image.asset(
                      'assets/images/mascot.jpg',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            // Skill badges
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _keahlianAktif.map((skill) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    skill,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
