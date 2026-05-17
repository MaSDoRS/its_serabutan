import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class AppColors {
  // Deep Blue Professional Palette
  static const Color darkBlue = Color(0xFF041C32);
  static const Color primaryBlue = Color(0xFF064663);
  static const Color secondaryBlue = Color(0xFF04293A);
  static const Color accentBlue = Color(0xFF1B9CFC);
  static const Color lightBlue = Color(0xFFECF2FF);
  
  // Accents
  static const Color luxuryYellow = Color(0xFFFFD700);
  static const Color softYellow = Color(0xFFFFF9C4);
  static const Color white = Colors.white;
  static const Color textBlack = Color(0xFF2C3E50);
  static const Color textGrey = Color(0xFF7F8C8D);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ITS Serabutan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        primaryColor: AppColors.primaryBlue,
        scaffoldBackgroundColor: AppColors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryBlue,
          primary: AppColors.primaryBlue,
          secondary: AppColors.luxuryYellow,
          surface: AppColors.white,
        ),
        fontFamily: 'Roboto',
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryBlue,
            foregroundColor: AppColors.white,
            minimumSize: const Size(double.infinity, 56),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            shadowColor: AppColors.primaryBlue.withOpacity(0.4),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, letterSpacing: 0.5),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightBlue.withOpacity(0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppColors.lightBlue, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.accentBlue, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          labelStyle: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.w500),
          prefixIconColor: AppColors.primaryBlue,
        ),
      ),
      home: const OnboardingPage(),
    );
  }
}

// ==========================================
// CUSTOM UI COMPONENTS
// ==========================================

class ExpertBackground extends StatelessWidget {
  final Widget child;
  final bool includeYellow;

  const ExpertBackground({super.key, required this.child, this.includeYellow = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.white,
            AppColors.lightBlue.withOpacity(0.3),
            if (includeYellow) AppColors.softYellow.withOpacity(0.2),
          ],
        ),
      ),
      child: Stack(
        children: [
          if (includeYellow)
            Positioned(
              top: -50,
              right: -50,
              child: CircleAvatar(
                radius: 120,
                backgroundColor: AppColors.luxuryYellow.withOpacity(0.1),
              ),
            ),
          Positioned(
            bottom: -100,
            left: -50,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: AppColors.primaryBlue.withOpacity(0.05),
            ),
          ),
          SafeArea(child: child),
        ],
      ),
    );
  }
}

// ==========================================
// 1. ONBOARDING PAGE
// ==========================================
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Hero Section
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [AppColors.darkBlue, AppColors.primaryBlue],
              ),
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppColors.white.withOpacity(0.2)),
                    ),
                    child: const Icon(Icons.handyman_outlined, size: 70, color: AppColors.luxuryYellow),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'ITS Serabutan',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content Section
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Solusi Cerdas Mahasiswa',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.darkBlue),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Platform terintegrasi untuk kebutuhan harian di lingkungan ITS. Cepat, Aman, dan Bersahabat.',
                    style: TextStyle(fontSize: 16, color: AppColors.textGrey, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  _buildFeatureRow(Icons.verified_rounded, 'Mitra Terverifikasi KTM'),
                  const SizedBox(height: 16),
                  _buildFeatureRow(Icons.payments_rounded, 'Sistem Penawaran Terbuka'),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                    child: const Text('Jelajahi Sekarang'),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: AppColors.textGrey, fontSize: 14),
                          children: [
                            TextSpan(text: 'Sudah memiliki akun? '),
                            TextSpan(
                              text: 'Masuk',
                              style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accentBlue, size: 24),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondaryBlue)),
      ],
    );
  }
}

// ==========================================
// 2. LOGIN PAGE
// ==========================================
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isUser = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpertBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Selamat Datang',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.darkBlue),
              ),
              const Text('Silakan masuk untuk melanjutkan', style: TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 40),
              
              // Animated Role Toggle
              Container(
                height: 56,
                decoration: BoxDecoration(
                  color: AppColors.lightBlue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(child: _buildToggleItem('Pengguna', isUser, () => setState(() => isUser = true))),
                    Expanded(child: _buildToggleItem('Mitra', !isUser, () => setState(() => isUser = false))),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Email / NRP',
                  prefixIcon: Icon(Icons.alternate_email_rounded),
                ),
              ),
              const SizedBox(height: 20),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Kata Sandi',
                  prefixIcon: Icon(Icons.lock_outline_rounded),
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: const Text('Lupa sandi?', style: TextStyle(color: AppColors.accentBlue, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Masuk Ke Aplikasi'),
              ),
              const SizedBox(height: 32),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('atau', style: TextStyle(color: AppColors.textGrey))),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 32),
              OutlinedButton.icon(
                onPressed: () {},
                // Gunakan URL yang lebih stabil dan tambahkan errorBuilder
                icon: Image.network(
                  'https://www.gstatic.com/images/branding/product/1x/g_logo_24dp.png',
                  height: 24,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.g_mobiledata_rounded,
                      size: 30,
                      color: AppColors.primaryBlue
                  ),
                ),
                label: const Text('Masuk dengan Google', style: TextStyle(fontWeight: FontWeight.bold)),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  side: const BorderSide(color: AppColors.lightBlue),
                ),
              ),
              const SizedBox(height: 40),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterRolePage())),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: AppColors.textGrey),
                      children: [
                        TextSpan(text: 'Baru di sini? '),
                        TextSpan(
                          text: 'Daftar Sekarang',
                          style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleItem(String title, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: active ? AppColors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: active ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)] : [],
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: active ? AppColors.primaryBlue : AppColors.textGrey,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 3. REGISTER ROLE PAGE
// ==========================================
class RegisterRolePage extends StatefulWidget {
  const RegisterRolePage({super.key});

  @override
  State<RegisterRolePage> createState() => _RegisterRolePageState();
}

class _RegisterRolePageState extends State<RegisterRolePage> {
  bool isUser = true;
  String identityType = 'KTM';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpertBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
              const SizedBox(height: 20),
              const Text('Daftar Akun Baru', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.darkBlue)),
              const Text('Langkah 1: Tentukan peran Anda', style: TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 40),
              
              Row(
                children: [
                  Expanded(child: _buildRoleCard(true, Icons.person_search_rounded, 'Pengguna', 'Cari Jasa')),
                  const SizedBox(width: 16),
                  Expanded(child: _buildRoleCard(false, Icons.engineering_rounded, 'Mitra', 'Beri Jasa')),
                ],
              ),
              
              const SizedBox(height: 32),
              const TextField(decoration: InputDecoration(labelText: 'Nama Lengkap', prefixIcon: Icon(Icons.badge_outlined))),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(labelText: 'Email Kampus / Umum', prefixIcon: Icon(Icons.email_outlined))),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(labelText: 'Nomor WhatsApp', prefixIcon: Icon(Icons.phone_outlined))),
              
              const SizedBox(height: 32),
              const Text('Pilih Jenis Identitas', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildIdentityBadge('KTM', 'Mahasiswa ITS'),
                  const SizedBox(width: 12),
                  _buildIdentityBadge('KTP', 'Masyarakat Umum'),
                ],
              ),
              
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterUploadPage(isMitra: !isUser))),
                child: const Text('Lanjut Ke Verifikasi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(bool target, IconData icon, String title, String sub) {
    bool selected = isUser == target;
    return GestureDetector(
      onTap: () => setState(() => isUser = target),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryBlue : AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: selected ? AppColors.primaryBlue : AppColors.lightBlue, width: 2),
          boxShadow: selected ? [BoxShadow(color: AppColors.primaryBlue.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))] : [],
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? AppColors.white : AppColors.primaryBlue, size: 48),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(color: selected ? AppColors.white : AppColors.darkBlue, fontWeight: FontWeight.bold)),
            Text(sub, style: TextStyle(color: selected ? AppColors.white.withOpacity(0.8) : AppColors.textGrey, fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildIdentityBadge(String type, String label) {
    bool selected = identityType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => identityType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? AppColors.lightBlue : AppColors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? AppColors.primaryBlue : AppColors.lightBlue, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.primaryBlue : AppColors.textGrey,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 4. REGISTER UPLOAD PAGE
// ==========================================
class RegisterUploadPage extends StatelessWidget {
  final bool isMitra;
  const RegisterUploadPage({super.key, required this.isMitra});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpertBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
              const SizedBox(height: 20),
              const Text('Validasi Dokumen', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.darkBlue)),
              const Text('Unggah foto dokumen identitas resmi Anda', style: TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 40),
              
              // Upload Area
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 60),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.accentBlue.withOpacity(0.2), style: BorderStyle.solid),
                ),
                child: const Column(
                  children: [
                    Icon(Icons.cloud_upload_rounded, size: 64, color: AppColors.accentBlue),
                    SizedBox(height: 16),
                    Text('Ambil atau Pilih Foto', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                    Text('Ukuran maks. 5MB', style: TextStyle(color: AppColors.textGrey, fontSize: 12)),
                  ],
                ),
              ),
              
              const SizedBox(height: 32),
              const TextField(decoration: InputDecoration(labelText: 'Nomor Identitas (NRP / NIK)', prefixIcon: Icon(Icons.numbers_rounded))),
              const SizedBox(height: 32),
              
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.luxuryYellow.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.shield_rounded, color: AppColors.primaryBlue, size: 24),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Data Anda dijamin kerahasiaannya dan hanya digunakan untuk keperluan verifikasi.',
                        style: TextStyle(fontSize: 12, color: AppColors.primaryBlue, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  if (isMitra) {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterMitraCategoryPage()));
                  } else {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const WaitingVerificationPage()));
                  }
                },
                child: Text(isMitra ? 'Pilih Kategori Jasa' : 'Selesaikan Pendaftaran'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 5. REGISTER MITRA CATEGORY PAGE
// ==========================================
class RegisterMitraCategoryPage extends StatefulWidget {
  const RegisterMitraCategoryPage({super.key});

  @override
  State<RegisterMitraCategoryPage> createState() => _RegisterMitraCategoryPageState();
}

class _RegisterMitraCategoryPageState extends State<RegisterMitraCategoryPage> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Antar-Jemput', 'icon': Icons.motorcycle_rounded, 'selected': true},
    {'name': 'Jastip Belanja', 'icon': Icons.shopping_basket_rounded, 'selected': false},
    {'name': 'Logistik', 'icon': Icons.local_shipping_rounded, 'selected': false},
    {'name': 'Pembersihan', 'icon': Icons.clean_hands_rounded, 'selected': false},
    {'name': 'Tugas Akademik', 'icon': Icons.assignment_rounded, 'selected': false},
    {'name': 'Lain-lain', 'icon': Icons.grid_view_rounded, 'selected': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpertBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back_rounded)),
              const SizedBox(height: 20),
              const Text('Bidang Keahlian', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.darkBlue)),
              const Text('Kategori jasa yang ingin Anda tawarkan', style: TextStyle(color: AppColors.textGrey)),
              const SizedBox(height: 32),
              
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                ),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  bool sel = cat['selected'];
                  return GestureDetector(
                    onTap: () => setState(() => cat['selected'] = !sel),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: sel ? AppColors.primaryBlue : AppColors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: sel ? AppColors.primaryBlue : AppColors.lightBlue, width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(cat['icon'], color: sel ? AppColors.white : AppColors.primaryBlue, size: 36),
                          const SizedBox(height: 12),
                          Text(
                            cat['name'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: sel ? AppColors.white : AppColors.darkBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 32),
              const TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Bio Singkat Keahlian',
                  hintText: 'Contoh: Saya hafal jalanan sekitar ITS dan memiliki motor...',
                ),
              ),
              
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WaitingVerificationPage())),
                child: const Text('Simpan Data Mitra'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 6. WAITING VERIFICATION PAGE
// ==========================================
class WaitingVerificationPage extends StatelessWidget {
  const WaitingVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ExpertBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.luxuryYellow.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.verified_user_outlined, size: 80, color: AppColors.luxuryYellow),
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                'Proses Verifikasi',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.darkBlue),
              ),
              const SizedBox(height: 16),
              const Text(
                'Data Anda telah kami terima. Tim admin ITS Serabutan akan meninjau kelengkapan berkas dalam maksimal 24 jam.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: AppColors.textGrey, height: 1.6),
              ),
              const SizedBox(height: 48),
              
              // Status Indicator
              Column(
                children: [
                  _buildStatusLine(Icons.check_circle_rounded, 'Formulir Pendaftaran', true),
                  _buildConnector(true),
                  _buildStatusLine(Icons.check_circle_rounded, 'Unggah Dokumen', true),
                  _buildConnector(true),
                  _buildStatusLine(Icons.radio_button_checked_rounded, 'Review Admin', false),
                ],
              ),
              
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const OnboardingPage()),
                      (route) => false,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    side: const BorderSide(color: AppColors.primaryBlue, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Kembali Ke Beranda', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusLine(IconData icon, String title, bool done) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: done ? Colors.green : AppColors.accentBlue, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            color: done ? AppColors.textGrey : AppColors.darkBlue,
            fontWeight: done ? FontWeight.normal : FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildConnector(bool done) {
    return Container(
      width: 2,
      height: 20,
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: done ? Colors.green.withOpacity(0.5) : AppColors.lightBlue,
    );
  }
}
