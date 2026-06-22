import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'aktivitas_screen.dart';
import 'ulasan_screen.dart';
import 'pilih_role_screen.dart';

final supabase = Supabase.instance.client;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final email = supabase.auth.currentUser?.email;
      if (email == null) return;
      final data = await supabase
          .from('users')
          .select()
          .eq('email', email)
          .single();
      if (mounted) {
        setState(() {
          _userData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Keluar dari Akun',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Apakah kamu yakin ingin keluar dari akun?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w600),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF5350),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Keluar', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await supabase.auth.signOut();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PilihRoleScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final nama = _userData?['name'] ?? supabase.auth.currentUser?.email ?? 'User';
    final email = _userData?['email'] ?? supabase.auth.currentUser?.email ?? '-';
    final phone = _userData?['phone'] ?? '-';
    final identityNumber = _userData?['identity_number'] ?? '-';
    final identityType = _userData?['identity_type'] ?? '';
    final initial = nama.isNotEmpty ? nama[0].toUpperCase() : 'U';
    final isVerified = _userData?['identity_photo_url'] != null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildProfileHeader(context, nama, initial, identityType, isVerified),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── INFORMASI AKUN ──
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('INFORMASI AKUN'),
                        const SizedBox(height: 16),
                        _buildInfoRow(
                          icon: Icons.email_outlined,
                          iconColor: const Color(0xFF29B6F6),
                          label: 'Email',
                          value: email,
                        ),
                        const SizedBox(height: 18),
                        _buildInfoRow(
                          icon: Icons.phone_outlined,
                          iconColor: const Color(0xFF66BB6A),
                          label: 'WhatsApp',
                          value: phone,
                        ),
                        if (identityNumber != '-') ...[
                          const SizedBox(height: 18),
                          _buildInfoRow(
                            icon: Icons.badge_outlined,
                            iconColor: const Color(0xFF42A5F5),
                            label: 'NRP/NIK',
                            value: identityNumber,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── MENU ──
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('MENU'),
                        const SizedBox(height: 12),
                        _buildMenuItem(
                          icon: Icons.receipt_long_outlined,
                          iconBgColor: Colors.grey.shade200,
                          iconColor: Colors.grey.shade600,
                          label: 'Aktivitas Saya',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AktivitasScreen(),
                            ),
                          ),
                        ),
                        _buildMenuItem(
                          icon: Icons.star_border_rounded,
                          iconBgColor: const Color(0xFFFFF8E1),
                          iconColor: const Color(0xFFFFA000),
                          label: 'Ulasan',
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const UlasanScreen()),
                          ),
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Keluar dari Akun ──
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _logout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF5350),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 2,
                        shadowColor: const Color(0xFFEF5350).withValues(alpha: 0.4),
                      ),
                      child: const Text(
                        'Keluar dari Akun',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    String nama,
    String initial,
    String identityType,
    bool isVerified,
  ) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 28),
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 16, top: 8, bottom: 4),
                child: Row(
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
                                  text: 'ITS ',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(
                                  text: 'SERABUTAN',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFFFD54F),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Kerja Apa Aja yang Bisa Dikerjain di Sekitar ITS!',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Logo maskot — sama dengan splash screen
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Transform.scale(
                          scale: 1.4,
                          child: Image.asset(
                            'assets/images/mascot.jpg',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Avatar circle — tap to edit
              Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFFFD54F), width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      initial,
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0288D1),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),

              // Nama
              Text(
                nama,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),

              // Badge verifikasi
              if (isVerified)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified, size: 14, color: Color(0xFFFFD54F)),
                      const SizedBox(width: 4),
                      Text(
                        identityType == 'ktm' ? 'Terverifikasi KTM' : 'Terverifikasi KTP',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.95),
                        ),
                      ),
                    ],
                  ),
                ),

            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade50, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1565C0),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1.5, color: Colors.blue.shade100)),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 22, color: iconColor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required String label,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBgColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, size: 22, color: iconColor),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, size: 22, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }

}
