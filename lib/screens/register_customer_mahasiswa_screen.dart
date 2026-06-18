import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'main_navigation_screen.dart';

final supabase = Supabase.instance.client;

// Catatan untuk tim: karena login sekarang pakai Google OAuth,
// screen ini berfungsi sebagai "Lengkapi Profil" yang muncul
// setelah user login pertama kali (mengisi phone, identity_number, dan upload KTM/KTP).
class RegisterCustomerMahasiswaScreen extends StatefulWidget {
  const RegisterCustomerMahasiswaScreen({super.key});

  @override
  State<RegisterCustomerMahasiswaScreen> createState() =>
      _RegisterCustomerMahasiswaScreenState();
}

class _RegisterCustomerMahasiswaScreenState
    extends State<RegisterCustomerMahasiswaScreen> {
  final _namaController = TextEditingController();
  final _phoneController = TextEditingController();
  final _identityNumberController = TextEditingController(); // NRP/NIM
  final _scrollController = ScrollController();

  bool _isLoading = false;
  File? _ktmImage;

  @override
  void initState() {
    super.initState();
    final authUser = supabase.auth.currentUser;
    _namaController.text = authUser?.userMetadata?['full_name'] ?? '';
  }

  @override
  void dispose() {
    _namaController.dispose();
    _phoneController.dispose();
    _identityNumberController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _pickKtmImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _ktmImage = File(picked.path));
    }
  }

  Future<void> _saveProfile() async {
    final nama = _namaController.text.trim();
    final phone = _phoneController.text.trim();
    final identityNumber = _identityNumberController.text.trim();

    if (nama.isEmpty || phone.isEmpty || identityNumber.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field harus diisi')));
      return;
    }

    if (_ktmImage == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Harap upload foto KTM')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authUser = supabase.auth.currentUser;
      if (authUser == null) throw Exception('Belum login');

      // Cari baris user (dibuat saat login Google pertama kali)
      final userRow = await supabase
          .from('users')
          .select('id')
          .eq('email', authUser.email ?? '')
          .single();
      final userId = userRow['id'] as int;

      // Upload foto KTM ke bucket identity_photos
      final fileName = 'ktm_$userId.jpg';
      await supabase.storage
          .from('identity_photos')
          .upload(
            fileName,
            _ktmImage!,
            fileOptions: const FileOptions(upsert: true),
          );
      final ktmUrl = supabase.storage
          .from('identity_photos')
          .getPublicUrl(fileName);

      // Update data profil sesuai skema backend
      await supabase
          .from('users')
          .update({
            'name': nama,
            'phone': phone,
            'identity_number': identityNumber,
            'identity_type': 'ktm',
            'identity_photo_url': ktmUrl,
          })
          .eq('id', userId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profil berhasil disimpan!')),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
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
        backgroundColor: const Color(0xFFF48FB1),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Lengkapi Profil Mahasiswa',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              _buildLabel('NAMA LENGKAP'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _namaController,
                hintText: 'Masukkan nama lengkap',
              ),
              const SizedBox(height: 20),
              _buildLabel('NRP / NIM'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _identityNumberController,
                hintText: 'Masukkan NRP/NIM anda',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              _buildLabel('NOMOR WHATSAPP'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _phoneController,
                hintText: 'Contoh: 081234567890',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              _buildLabel('UPLOAD FOTO KTM'),
              const SizedBox(height: 8),
              _buildUploadArea(),
              const SizedBox(height: 32),
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildActionButton(
                      label: 'SIMPAN PROFIL',
                      color: const Color(0xFFFFD54F),
                      onPressed: _saveProfile,
                    ),
              const SizedBox(height: 32),
            ],
          ),
        ),
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
                child: Image.file(_ktmImage!, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 40,
                    color: Colors.blue.shade300,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap untuk upload foto KTM',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.blue.shade400,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400),
        filled: true,
        fillColor: const Color(0xFFE3F2FD),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
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
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}
