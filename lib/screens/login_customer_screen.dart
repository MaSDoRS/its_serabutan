import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'main_navigation_screen.dart';
import 'register_customer_umum_screen.dart';

final supabase = Supabase.instance.client;

class LoginCustomerScreen extends StatefulWidget {
  const LoginCustomerScreen({super.key});

  @override
  State<LoginCustomerScreen> createState() => _LoginCustomerScreenState();
}

class _LoginCustomerScreenState extends State<LoginCustomerScreen> {
  bool _isLoading = false;

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback/',
      );
      // Setelah OAuth sukses, pastikan baris di tabel users sudah ada,
      // lalu cek apakah profil (phone/identity) sudah lengkap atau belum.
      final isProfileComplete = await _ensureUserRowAndCheckProfile();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => isProfileComplete
                ? const MainNavigationScreen()
                : const RegisterCustomerUmumScreen(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal login dengan Google: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Memastikan ada baris di public.users untuk auth user ini.
  // Karena id di tabel users adalah int8 auto-increment (bukan UUID auth),
  // kita cari berdasarkan email. Kalau belum ada, baru insert baris baru
  // dan biarkan database generate id integer-nya sendiri.
  // Return true kalau profil (phone & identity_number) sudah lengkap.
  Future<bool> _ensureUserRowAndCheckProfile() async {
    final authUser = supabase.auth.currentUser;
    if (authUser == null) return false;

    final existing = await supabase
        .from('users')
        .select('phone, identity_number')
        .eq('email', authUser.email ?? '')
        .maybeSingle();

    if (existing == null) {
      await supabase.from('users').insert({
        'name': authUser.userMetadata?['full_name'] ?? authUser.email,
        'email': authUser.email,
        'role': 'user',
      });
      return false; // baru dibuat, belum lengkap
    }

    return existing['phone'] != null && existing['identity_number'] != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF48FB1),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Masuk Sebagai Customer',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.account_circle,
                size: 100,
                color: Colors.blue.shade200,
              ),
              const SizedBox(height: 24),
              const Text(
                'Masuk dengan akun Google kamu\nuntuk melanjutkan',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              _isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _loginWithGoogle,
                        icon: const Icon(Icons.g_mobiledata, size: 28),
                        label: const Text(
                          'MASUK DENGAN GOOGLE',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD54F),
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
