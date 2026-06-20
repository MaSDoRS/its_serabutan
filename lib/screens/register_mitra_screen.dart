import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login_mitra_screen.dart';
import 'mitra_navigation_screen.dart';

final _supabase = Supabase.instance.client;

class RegisterMitraScreen extends StatefulWidget {
  const RegisterMitraScreen({super.key});

  @override
  State<RegisterMitraScreen> createState() => _RegisterMitraScreenState();
}

class _RegisterMitraScreenState extends State<RegisterMitraScreen> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _jurusanController = TextEditingController();
  final _angkatanController = TextEditingController();
  final _nrpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  File? _ktmImage;
  bool _isLoading = false;
  final Set<String> _selectedKeahlian = {};

  final List<_KeahlianItem> _keahlianList = [
    _KeahlianItem('Antar Jemput', 'Antar jemput, ojek keliling Surabaya!',
        Icons.motorcycle, const Color(0xFF1565C0)),
    _KeahlianItem('Tenaga & Logistik',
        'Angkut barang pindahan, angkat barang beres, dsb.',
        Icons.local_shipping, const Color(0xFFE65100)),
    _KeahlianItem('Kebersihan',
        'Bersihkan kamar kos, kontrakan, rumah, cuci kendaraan, dsb.',
        Icons.cleaning_services, const Color(0xFF2E7D32)),
    _KeahlianItem('Jastip & Belanja',
        'Beli makan di warung atau resto dan belanja kebutuhan sehari hari.',
        Icons.shopping_bag, const Color(0xFF6A1B9A)),
    _KeahlianItem('Perbaikan Ringan', 'Perbaikan dan perlengkapan ringan.',
        Icons.build, const Color(0xFFC62828)),
    _KeahlianItem('Sosial & Lainnya',
        'Teman makan, belajar, curhat, keliling kota. Perawatan hewan, penitipan hewan, dsb.',
        Icons.people, const Color(0xFF00695C)),
  ];

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _whatsappController.dispose();
    _jurusanController.dispose();
    _angkatanController.dispose();
    _nrpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _pickKtmImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => _ktmImage = File(picked.path));
  }

  Future<void> _daftar() async {
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final whatsapp = _whatsappController.text.trim();
    final jurusan = _jurusanController.text.trim();
    final angkatan = _angkatanController.text.trim();
    final nrp = _nrpController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (nama.isEmpty || email.isEmpty || whatsapp.isEmpty ||
        jurusan.isEmpty || angkatan.isEmpty || nrp.isEmpty) {
      _showError('Semua data diri harus diisi');
      return;
    }
    if (_ktmImage == null) {
      _showError('Harap upload foto KTM terlebih dahulu');
      return;
    }
    if (password.isEmpty) {
      _showError('Password tidak boleh kosong');
      return;
    }
    if (password.length < 6) {
      _showError('Password minimal 6 karakter');
      return;
    }
    if (password != confirmPassword) {
      _showError('Password tidak cocok');
      return;
    }
    if (_selectedKeahlian.isEmpty) {
      _showError('Pilih minimal 1 keahlian');
      return;
    }

    setState(() => _isLoading = true);
    try {
      // 1. Sign up – kalau email sudah ada di Auth (gagal di tengah sebelumnya), sign in saja
      User? authUser;
      try {
        final res = await _supabase.auth.signUp(
          email: email,
          password: password,
          data: {'full_name': nama},
        );
        authUser = res.user;
      } on AuthApiException catch (e) {
        if (e.code == 'user_already_exists') {
          final res = await _supabase.auth.signInWithPassword(
            email: email,
            password: password,
          );
          authUser = res.user;
        } else {
          rethrow;
        }
      }

      if (authUser == null) throw Exception('Gagal membuat akun');

      // 2. Upsert ke tabel users (pakai UUID dari Auth sebagai id)
      await _supabase.from('users').upsert({
        'id': authUser.id,
        'name': nama,
        'email': email,
        'phone': whatsapp,
        'identity_number': nrp,
        'identity_type': 'ktm',
        'role': 'provider',
      }, onConflict: 'id');

      // 3. Upload foto KTM
      final fileName = 'ktm_mitra_${authUser.id}.jpg';
      await _supabase.storage.from('identity_photos').upload(
        fileName,
        _ktmImage!,
        fileOptions: const FileOptions(upsert: true),
      );
      final ktmUrl = _supabase.storage.from('identity_photos').getPublicUrl(fileName);

      await _supabase.from('users').update({
        'identity_photo_url': ktmUrl,
      }).eq('id', authUser.id);

      // 4. Upsert ke tabel providers
      await _supabase.from('providers').upsert({
        'user_id': authUser.id,
        'status': 'active',
      }, onConflict: 'user_id');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran Mitra berhasil!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MitraNavigationScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) _showError('Error: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
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
        title: const Text('Daftar Sebagai Mitra',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  _buildTabSelector(),
                  const SizedBox(height: 28),

                  // ── DATA DIRI ──
                  _buildSectionLabel('DATA DIRI'),
                  const SizedBox(height: 12),
                  _buildLabel('NAMA LENGKAP'),
                  const SizedBox(height: 8),
                  _buildTextField(controller: _namaController),
                  const SizedBox(height: 16),
                  _buildLabel('EMAIL'),
                  const SizedBox(height: 8),
                  _buildTextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 16),
                  _buildLabel('NOMOR WHATSAPP'),
                  const SizedBox(height: 8),
                  _buildTextField(
                      controller: _whatsappController,
                      keyboardType: TextInputType.phone),
                  const SizedBox(height: 16),
                  _buildLabel('JURUSAN / DEPARTEMEN'),
                  const SizedBox(height: 8),
                  _buildTextField(controller: _jurusanController),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('ANGKATAN'),
                            const SizedBox(height: 8),
                            _buildTextField(
                                controller: _angkatanController,
                                keyboardType: TextInputType.number),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('NRP'),
                            const SizedBox(height: 8),
                            _buildTextField(controller: _nrpController),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // ── VERIFIKASI KTM ──
                  _buildSectionLabel('VERIFIKASI KTM'),
                  const SizedBox(height: 12),
                  _buildUploadArea(),

                  const SizedBox(height: 28),

                  // ── PASSWORD ──
                  _buildSectionLabel('PASSWORD'),
                  const SizedBox(height: 12),
                  _buildLabel('PASSWORD'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('ULANGI PASSWORD'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () => setState(() =>
                          _obscureConfirmPassword = !_obscureConfirmPassword),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── PILIH KEAHLIAN ──
                  _buildSectionLabel('PILIH KEAHLIAN'),
                  const SizedBox(height: 4),
                  Text(
                    'Pilih minimal 1 peran yang bisa kamu kerjakan',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_keahlianList.length,
                      (i) => _buildKeahlianCard(_keahlianList[i])),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── TOMBOL DAFTAR ──
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _daftar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD54F),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        elevation: 2,
                      ),
                      child: const Text(
                        'DAFTAR',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const LoginMitraScreen())),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text('Masuk',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14, color: Colors.grey.shade500)),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Text('Daftar',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w800,
          color: Color(0xFF1565C0),
          letterSpacing: 0.5),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
          letterSpacing: 0.5),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFE3F2FD),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: Color(0xFF42A5F5), width: 1.5)),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildUploadArea() {
    return GestureDetector(
      onTap: _pickKtmImage,
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFF90CAF9), width: 1.5),
        ),
        child: _ktmImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(_ktmImage!, fit: BoxFit.cover))
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 32, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text('KLIK UNTUK UPLOAD KTM',
                      style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                          fontWeight: FontWeight.w500)),
                ],
              ),
      ),
    );
  }

  Widget _buildKeahlianCard(_KeahlianItem item) {
    final isSelected = _selectedKeahlian.contains(item.title);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => setState(() => isSelected
            ? _selectedKeahlian.remove(item.title)
            : _selectedKeahlian.add(item.title)),
        borderRadius: BorderRadius.circular(14),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected
                ? item.color.withValues(alpha: 0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
                color: isSelected ? item.color : Colors.grey.shade200,
                width: isSelected ? 2 : 1),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.color, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: item.color)),
                    const SizedBox(height: 2),
                    Text(item.description,
                        style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                            height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? item.color : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                      color: isSelected ? item.color : Colors.grey.shade400,
                      width: 2),
                ),
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _KeahlianItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  _KeahlianItem(this.title, this.description, this.icon, this.color);
}
