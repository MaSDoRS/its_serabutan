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
      // 1. Proses Login ke Supabase Auth dengan Email & Password
      await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // 2. Cek apakah profil di tabel public.users sudah lengkap via auth_uid
      final isProfileComplete = await _checkCustomerProfile();

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
          SnackBar(content: Text('Gagal masuk: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Mencari baris user berdasarkan auth_uid untuk mengecek kelengkapan data profil
  Future<bool> _checkCustomerProfile() async {
    final authUser = supabase.auth.currentUser;
    if (authUser == null) return false;

    // Database Trigger secara otomatis membuatkan baris di public.users saat sign up.
    // Kita cukup membaca datanya berdasarkan auth_uid (UUID session auth)
    final existing = await supabase
        .from('users')
        .select('phone, identity_number')
        .eq('auth_uid', authUser.id)
        .maybeSingle();

    if (existing == null) return false;

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle,
                  size: 90,
                  color: Colors.blue.shade200,
                ),
                const SizedBox(height: 24),
                // Input Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
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
                            'MASUK',
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