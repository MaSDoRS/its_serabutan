import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'mitra_navigation_screen.dart';

final supabase = Supabase.instance.client;

class LoginMitraScreen extends StatefulWidget {
  const LoginMitraScreen({super.key});

  @override
  State<LoginMitraScreen> createState() => _LoginMitraScreenState();
}

class _LoginMitraScreenState extends State<LoginMitraScreen> {
  bool _isLoading = false;

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.flutter://login-callback/',
      );
      await _ensureUserAndProviderRow();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const MitraNavigationScreen(),
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

  // Memastikan ada baris di public.users DAN public.providers untuk akun mitra ini.
  Future<void> _ensureUserAndProviderRow() async {
    final authUser = supabase.auth.currentUser;
    if (authUser == null) return;

    var userRow = await supabase
        .from('users')
        .select('id')
        .eq('email', authUser.email ?? '')
        .maybeSingle();

    int userId;
    if (userRow == null) {
      final inserted = await supabase
          .from('users')
          .insert({
            'name': authUser.userMetadata?['full_name'] ?? authUser.email,
            'email': authUser.email,
            'role': 'provider',
          })
          .select('id')
          .single();
      userId = inserted['id'] as int;
    } else {
      userId = userRow['id'] as int;
    }

    final providerRow = await supabase
        .from('providers')
        .select('id')
        .eq('user_id', userId)
        .maybeSingle();

    if (providerRow == null) {
      await supabase.from('providers').insert({
        'user_id': userId,
        'status': 'active',
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4FC3F7),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Masuk Sebagai Mitra',
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
              Icon(Icons.work_outline, size: 100, color: Colors.blue.shade200),
              const SizedBox(height: 24),
              const Text(
                'Masuk dengan akun Google kamu\nuntuk melanjutkan sebagai Mitra',
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
