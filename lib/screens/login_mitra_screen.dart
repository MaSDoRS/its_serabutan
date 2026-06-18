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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _formKey.currentState?.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmailPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      // 1. Login menggunakan email dan password ke Supabase Auth
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Sinkronisasi data ke tabel public.users dan public.providers menggunakan auth_uid
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
          SnackBar(content: Text('Gagal masuk sebagai Mitra: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Memastikan baris public.users terpetakan dan mendaftarkan id ke tabel public.providers
  Future<void> _ensureUserAndProviderRow() async {
    final authUser = supabase.auth.currentUser;
    if (authUser == null) return;

    // Ambil nilai id (integer auto-increment) dari public.users menggunakan pencocokan auth_uid
    var userRow = await supabase
        .from('users')
        .select('id')
        .eq('auth_uid', authUser.id)
        .maybeSingle();

    int userId;
    if (userRow == null) {
      // Skenario darurat jika trigger database belum sempat tereksekusi
      final inserted = await supabase
          .from('users')
          .insert({
            'auth_uid': authUser.id,
            'name': authUser.userMetadata?['name'] ?? splitPart(authUser.email),
            'email': authUser.email,
            'role': 'provider',
          })
          .select('id')
          .single();
      userId = inserted['id'] as int;
    } else {
      userId = userRow['id'] as int;
      
      // Update role akun menjadi provider jika sebelumnya terdaftar sebagai customer umum
      await supabase.from('users').update({'role': 'provider'}).eq('id', userId);
    }

    // Cek atau buat baris baru di tabel public.providers menggunakan id integer asli backend
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

  String splitPart(String? email) {
    if (email == null) return 'Mitra Baru';
    return email.split('@')[0];
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_outline, size: 90, color: Colors.blue.shade200),
                const SizedBox(height: 24),
                // Input Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Mitra',
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? 'Email tidak boleh kosong' : null,
                ),
                const SizedBox(height: 16),
                // Input Password
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) => (value == null || value.length < 6) ? 'Password minimal 6 karakter' : null,
                ),
                const SizedBox(height: 32),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _loginWithEmailPassword,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD54F),
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 2,
                          ),
                          child: const Text(
                            'MASUK SEBAGAI MITRA',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}