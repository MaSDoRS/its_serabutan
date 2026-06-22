import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import 'login_mitra_screen.dart';
import 'mitra_navigation_screen.dart';

final supabase = Supabase.instance.client;

class RegisterMitraKeahlianScreen extends StatefulWidget {
  final String nama;
  final String email;
  final String whatsapp;
  final String jurusan;
  final String angkatan;
  final String nrp;
  final String password;
  final File ktmImage;

  const RegisterMitraKeahlianScreen({
    super.key,
    required this.nama,
    required this.email,
    required this.whatsapp,
    required this.jurusan,
    required this.angkatan,
    required this.nrp,
    required this.password,
    required this.ktmImage,
  });

  @override
  State<RegisterMitraKeahlianScreen> createState() =>
      _RegisterMitraKeahlianScreenState();
}

class _RegisterMitraKeahlianScreenState
    extends State<RegisterMitraKeahlianScreen> {
  final Set<String> _selectedKeahlian = {};
  bool _isLoading = false;

  final List<_KeahlianItem> _keahlianList = [
    _KeahlianItem(
      title: 'Antar Jemput',
      description: 'Antar jemput, ojek keliling Surabaya!',
      icon: Icons.motorcycle,
      color: const Color(0xFF1565C0),
    ),
    _KeahlianItem(
      title: 'Tenaga & Logistik',
      description: 'Angkut barang pindahan, angkat barang beres, dsb.',
      icon: Icons.local_shipping,
      color: const Color(0xFFE65100),
    ),
    _KeahlianItem(
      title: 'Kebersihan',
      description:
          'Bersihkan kamar kos, kontrakan, rumah, cuci kendaraan, dsb.',
      icon: Icons.cleaning_services,
      color: const Color(0xFF2E7D32),
    ),
    _KeahlianItem(
      title: 'Jastip & Belanja',
      description:
          'Beli makan di warung atau resto dan belanja kebutuhan sehari hari.',
      icon: Icons.shopping_bag,
      color: const Color(0xFF6A1B9A),
    ),
    _KeahlianItem(
      title: 'Perbaikan Ringan',
      description: 'Perbaikan dan perlengkapan ringan.',
      icon: Icons.build,
      color: const Color(0xFFC62828),
    ),
    _KeahlianItem(
      title: 'Sosial & Lainnya',
      description:
          'Teman makan, belajar, curhat, keliling kota. Perawatan hewan untuk peliharaan, penitipan hewan, dsb.',
      icon: Icons.people,
      color: const Color(0xFF00695C),
    ),
  ];

  Future<void> _registerMitra() async {
    if (_selectedKeahlian.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih minimal 1 keahlian'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      // 1. Sign Up user in Supabase Auth
      final response = await supabase.auth.signUp(
        email: widget.email,
        password: widget.password,
        data: {'full_name': widget.nama},
      );

      final authUser = response.user;
      if (authUser == null) throw Exception('Gagal melakukan pendaftaran akun');

      // 2. Cek apakah row users sudah ada (mungkin dibuat trigger)
      final existing = await supabase
          .from('users')
          .select('id')
          .eq('auth_uid', authUser.id)
          .maybeSingle();

      int userId;
      if (existing != null) {
        // Row sudah ada → UPDATE saja
        await supabase.from('users').update({
          'name': widget.nama,
          'email': widget.email,
          'phone': widget.whatsapp,
          'identity_number': widget.nrp,
          'identity_type': 'ktm',
          'role': 'provider',
        }).eq('auth_uid', authUser.id);
        userId = existing['id'] as int;
      } else {
        // Belum ada → INSERT baru
        final insertResult = await supabase
            .from('users')
            .insert({
              'auth_uid': authUser.id,
              'name': widget.nama,
              'email': widget.email,
              'phone': widget.whatsapp,
              'identity_number': widget.nrp,
              'identity_type': 'ktm',
              'role': 'provider',
            })
            .select('id')
            .single();
        userId = insertResult['id'] as int;
      }

      // 3. Upload KTM image to Storage
      final fileName = 'ktm_mitra_${authUser.id}.jpg';
      await supabase.storage.from('identity_photos').upload(
            fileName,
            widget.ktmImage,
            fileOptions: const FileOptions(upsert: true),
          );
      final ktmUrl =
          supabase.storage.from('identity_photos').getPublicUrl(fileName);

      // 4. Update identity_photo_url
      await supabase
          .from('users')
          .update({'identity_photo_url': ktmUrl})
          .eq('auth_uid', authUser.id);

      // 5. Cek apakah row providers sudah ada
      final existingProvider = await supabase
          .from('providers')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      if (existingProvider != null) {
        // Sudah ada → UPDATE status saja
        await supabase
            .from('providers')
            .update({'status': 'aktif'})
            .eq('user_id', userId);
      } else {
        // Belum ada → INSERT baru
        await supabase.from('providers').insert({
          'user_id': userId,
          'status': 'aktif',
              }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran Mitra berhasil!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const MitraNavigationScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error Pendaftaran: $e'),
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
        title: const Text('Daftar Sebagai Mitra',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      _buildTabSelector(),
                      const SizedBox(height: 28),
                      const Text(
                        'Apa saja yang bisa kamu kerjakan?',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1565C0),
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Kamu bisa pilih minimal 1 peran dan centang semua jika bisa melakukan apa saja!',
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            height: 1.4),
                      ),
                      const SizedBox(height: 20),
                      ...List.generate(_keahlianList.length,
                          (index) => _buildKeahlianCard(_keahlianList[index])),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: SizedBox(
                width: double.infinity,
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed:
                            _selectedKeahlian.isEmpty ? null : _registerMitra,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFD54F),
                          foregroundColor: Colors.black87,
                          disabledBackgroundColor: Colors.grey.shade300,
                          disabledForegroundColor: Colors.grey.shade500,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          elevation: 2,
                        ),
                        child: const Text('DAFTAR',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.5)),
                      ),
              ),
            ),
          ],
        ),
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
              onTap: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const LoginMitraScreen()),
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text('Masuk',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade500)),
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

  Widget _buildKeahlianCard(_KeahlianItem item) {
    final isSelected = _selectedKeahlian.contains(item.title);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
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
      ),
    );
  }
}

class _KeahlianItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _KeahlianItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}