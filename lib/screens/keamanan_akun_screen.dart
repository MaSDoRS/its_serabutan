import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KeamananAkunScreen extends StatefulWidget {
  const KeamananAkunScreen({super.key});

  @override
  State<KeamananAkunScreen> createState() => _KeamananAkunScreenState();
}

class _KeamananAkunScreenState extends State<KeamananAkunScreen> {
  final _oldPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  final _supabase = Supabase.instance.client;

  @override
  void dispose() {
    _oldPassController.dispose();
    _newPassController.dispose();
    _confirmPassController.dispose();
    super.dispose();
  }

  Future<void> _gantiPassword() async {
    final newPass = _newPassController.text.trim();
    final confirmPass = _confirmPassController.text.trim();

    if (newPass.isEmpty) {
      _showSnack('Password baru tidak boleh kosong', isError: true);
      return;
    }
    if (newPass.length < 6) {
      _showSnack('Password minimal 6 karakter', isError: true);
      return;
    }
    if (newPass != confirmPass) {
      _showSnack('Konfirmasi password tidak cocok', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _supabase.auth.updateUser(UserAttributes(password: newPass));
      if (mounted) {
        _oldPassController.clear();
        _newPassController.clear();
        _confirmPassController.clear();
        _showSnack('Password berhasil diperbarui!');
      }
    } catch (e) {
      if (mounted) _showSnack('Gagal memperbarui password', isError: true);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: isError ? const Color(0xFFEF5350) : const Color(0xFF43A047),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final email = _supabase.auth.currentUser?.email ?? '-';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info akun
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('AKUN TERHUBUNG', Icons.link_rounded),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: const Color(0xFFE3F2FD),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.email_outlined, color: Color(0xFF0288D1), size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Email', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500)),
                                  Text(email, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE8F5E9),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified, size: 12, color: Color(0xFF43A047)),
                                  SizedBox(width: 4),
                                  Text('Terverifikasi', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF43A047))),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ganti password
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('GANTI PASSWORD', Icons.lock_outline_rounded),
                        const SizedBox(height: 16),
                        _buildPassField('Password Baru', _newPassController, _obscureNew,
                            () => setState(() => _obscureNew = !_obscureNew)),
                        const SizedBox(height: 12),
                        _buildPassField('Konfirmasi Password Baru', _confirmPassController, _obscureConfirm,
                            () => setState(() => _obscureConfirm = !_obscureConfirm)),
                        const SizedBox(height: 6),
                        Text('Minimal 6 karakter', style: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontStyle: FontStyle.italic)),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _gantiPassword,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0288D1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              elevation: 0,
                            ),
                            child: _isLoading
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('Perbarui Password', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Info keamanan
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('TIPS KEAMANAN', Icons.security_outlined),
                        const SizedBox(height: 14),
                        _buildTip(Icons.key_outlined, 'Gunakan password yang kuat dan unik'),
                        _buildTip(Icons.visibility_off_outlined, 'Jangan bagikan password ke siapapun'),
                        _buildTip(Icons.logout_outlined, 'Selalu logout jika menggunakan perangkat umum'),
                        _buildTip(Icons.update_outlined, 'Ganti password secara berkala'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF29B6F6), Color(0xFF0288D1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 4),
              const Expanded(
                child: Text(
                  'Keamanan Akun',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade50, width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 10, offset: const Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF0288D1)),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0288D1), letterSpacing: 0.5)),
      ],
    );
  }

  Widget _buildPassField(String label, TextEditingController controller, bool obscure, VoidCallback toggle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.grey.shade600)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          obscureText: obscure,
          style: const TextStyle(fontSize: 13),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE3F2FD),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.blue.shade100)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF42A5F5), width: 1.5)),
            suffixIcon: IconButton(
              icon: Icon(obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 20, color: Colors.grey.shade500),
              onPressed: toggle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTip(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey.shade600))),
        ],
      ),
    );
  }
}
