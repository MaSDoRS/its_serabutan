import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'mitra_navigation_screen.dart';
import 'register_mitra_screen.dart';

class LoginMitraScreen extends StatefulWidget {
  const LoginMitraScreen({Key? super.key});

  @override
  State<LoginMitraScreen> createState() => _LoginMitraScreenState();
}

class _LoginMitraScreenState extends State<LoginMitraScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _ensureUserAndProviderRow() async {
    final authUser = supabase.auth.currentUser;
    if (authUser == null) return;

    var userRow = await supabase
        .from('users')
        .select('id')
        .eq('auth_uid', authUser.id)
        .maybeSingle();

    int userId;
    if (userRow == null) {
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
      await supabase.from('users').update({'role': 'provider'}).eq('id', userId);
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

  String splitPart(String? email) {
    if (email == null) return 'Mitra Baru';
    return email.split('@')[0];
  }

  Future<void> _loginMitraWithEmailPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final response = await supabase.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (response.user != null) {
        await _ensureUserAndProviderRow();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Berhasil masuk sebagai Mitra!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const MitraNavigationScreen(),
            ),
            (route) => false,
          );
        }
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal masuk: ${error.message}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan tidak terduga: $error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                // Tab Masuk / Daftar
                _buildTabSelector(isLogin: true),
                const SizedBox(height: 28),

                // Email
                _buildLabel('EMAIL'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _emailController,
                  hintText: '',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Email tidak boleh kosong';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password
                _buildLabel('PASSWORD'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _passwordController,
                  hintText: '',
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colors.grey,
                      size: 20,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Password tidak boleh kosong';
                    if (v.length < 6) return 'Password minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 32),

                // Tombol MASUK
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4FC3F7)),
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _loginMitraWithEmailPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD54F),
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 1,
                        ),
                        child: const Text(
                          'MASUK',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabSelector({required bool isLogin}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Tab Masuk (aktif)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: isLogin ? Colors.white : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                border: isLogin ? Border.all(color: Colors.grey.shade400) : null,
              ),
              child: Text(
                'Masuk',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isLogin ? FontWeight.w700 : FontWeight.w400,
                  color: isLogin ? Colors.black87 : Colors.grey.shade500,
                ),
              ),
            ),
          ),
          // Tab Daftar
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterMitraScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: !isLogin ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Daftar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: !isLogin ? FontWeight.w700 : FontWeight.w400,
                    color: !isLogin ? Colors.black87 : Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
        filled: true,
        fillColor: const Color(0xFFE3F2FD),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF42A5F5), width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.5),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}