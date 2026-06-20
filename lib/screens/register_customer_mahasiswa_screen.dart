import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login_customer_screen.dart';
import 'register_customer_umum_screen.dart';

final supabase = Supabase.instance.client;

// Halaman Daftar Customer - tampilan sesuai mockup
// Halaman 1: Data diri (Nama, Email, WA, Institut, Jurusan, Angkatan, NRP/NIM)
// Halaman 2: Upload KTM, Password, Ulangi Password, tombol DAFTAR
class RegisterCustomerMahasiswaScreen extends StatefulWidget {
  const RegisterCustomerMahasiswaScreen({super.key});

  @override
  State<RegisterCustomerMahasiswaScreen> createState() =>
      _RegisterCustomerMahasiswaScreenState();
}

class _RegisterCustomerMahasiswaScreenState
    extends State<RegisterCustomerMahasiswaScreen> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _institutController = TextEditingController();
  final _jurusanController = TextEditingController();
  final _angkatanController = TextEditingController();
  final _nrpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _scrollController = ScrollController();

  int _currentPage = 1; // 1 = data diri, 2 = verifikasi & password
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  File? _ktmImage;

  @override
  void dispose() {
    _namaController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _institutController.dispose();
    _jurusanController.dispose();
    _angkatanController.dispose();
    _nrpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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

  void _goToPage2() {
    final nama = _namaController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final institut = _institutController.text.trim();
    final jurusan = _jurusanController.text.trim();
    final angkatan = _angkatanController.text.trim();
    final nrp = _nrpController.text.trim();

    if (nama.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        institut.isEmpty ||
        jurusan.isEmpty ||
        angkatan.isEmpty ||
        nrp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua field harus diisi')),
      );
      return;
    }
    setState(() => _currentPage = 2);
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _daftar() async {
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak boleh kosong')),
      );
      return;
    }
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password minimal 6 karakter')),
      );
      return;
    }
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password tidak cocok')),
      );
      return;
    }
    if (_ktmImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap upload foto KTM terlebih dahulu')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final nama = _namaController.text.trim();

      // Register ke Supabase Auth
      final authResponse = await supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': nama},
      );

      if (authResponse.user == null) throw Exception('Gagal membuat akun');

      final authUser = authResponse.user!;

      // Upload foto KTM
      final fileName = 'ktm_${authUser.id}.jpg';
      await supabase.storage
          .from('identity_photos')
          .upload(
            fileName,
            _ktmImage!,
            fileOptions: const FileOptions(upsert: true),
          );
      final ktmUrl =
          supabase.storage.from('identity_photos').getPublicUrl(fileName);

      // Insert ke tabel users
      await supabase.from('users').upsert({
        'auth_uid': authUser.id,
        'name': nama,
        'email': email,
        'phone': _phoneController.text.trim(),
        'identity_number': _nrpController.text.trim(),
        'identity_type': 'ktm',
        'identity_photo_url': ktmUrl,
        'role': 'customer',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pendaftaran berhasil! Silakan masuk.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginCustomerScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
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
          onPressed: () {
            if (_currentPage == 2) {
              setState(() => _currentPage = 1);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Daftar Sebagai Customer',
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
              const SizedBox(height: 20),
              // Tab Masuk / Daftar
              _buildTabSelector(),
              const SizedBox(height: 20),
              // Kategori Akun (radio button)
              _buildKategoriAkun(),
              const SizedBox(height: 20),

              if (_currentPage == 1) ..._buildPage1(),
              if (_currentPage == 2) ..._buildPage2(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPage1() {
    return [
      _buildLabel('NAMA LENGKAP'),
      const SizedBox(height: 8),
      _buildTextField(
        controller: _namaController,
        hintText: '',
      ),
      const SizedBox(height: 20),
      _buildLabel('EMAIL'),
      const SizedBox(height: 8),
      _buildTextField(
        controller: _emailController,
        hintText: '',
        keyboardType: TextInputType.emailAddress,
      ),
      const SizedBox(height: 20),
      _buildLabel('NOMOR WHATSAPP'),
      const SizedBox(height: 8),
      _buildTextField(
        controller: _phoneController,
        hintText: '',
        keyboardType: TextInputType.phone,
      ),
      const SizedBox(height: 20),
      _buildLabel('INSTITUT / UNIVERSITAS'),
      const SizedBox(height: 8),
      _buildTextField(
        controller: _institutController,
        hintText: '',
      ),
      const SizedBox(height: 20),
      _buildLabel('JURUSAN / DEPARTEMEN'),
      const SizedBox(height: 8),
      _buildTextField(
        controller: _jurusanController,
        hintText: '',
      ),
      const SizedBox(height: 20),
      // Angkatan dan NRP/NIM sejajar
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
                  hintText: '',
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildLabel('NRP / NIM'),
                const SizedBox(height: 8),
                _buildTextField(
                  controller: _nrpController,
                  hintText: '',
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 32),
      // Tombol lanjut ke halaman 2 (tidak ada tombol lanjut - langsung scroll ke bawah dan tombol ini lanjut)
      ElevatedButton(
        onPressed: _goToPage2,
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
          'LANJUT',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildPage2() {
    return [
      _buildLabel('VERIFIKASI KTM'),
      const SizedBox(height: 8),
      _buildUploadArea(
        image: _ktmImage,
        label: 'KLIK UNTUK UPLOAD KTM',
        onTap: _pickKtmImage,
      ),
      const SizedBox(height: 20),
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
          onPressed: () =>
              setState(() => _obscurePassword = !_obscurePassword),
        ),
      ),
      const SizedBox(height: 20),
      _buildLabel('ULANGI PASSWORD'),
      const SizedBox(height: 8),
      _buildTextField(
        controller: _confirmPasswordController,
        hintText: '',
        obscureText: _obscureConfirmPassword,
        suffixIcon: IconButton(
          icon: Icon(
            _obscureConfirmPassword
                ? Icons.visibility_off
                : Icons.visibility,
            color: Colors.grey,
            size: 20,
          ),
          onPressed: () => setState(
              () => _obscureConfirmPassword = !_obscureConfirmPassword),
        ),
      ),
      const SizedBox(height: 32),
      _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor:
                    AlwaysStoppedAnimation<Color>(Color(0xFF4FC3F7)),
              ),
            )
          : ElevatedButton(
              onPressed: _daftar,
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
                'DAFTAR',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
            ),
    ];
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
          // Tab Masuk
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginCustomerScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Masuk',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ),
          // Tab Daftar (aktif)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Text(
                'Daftar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKategoriAkun() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel('KATEGORI AKUN'),
        const SizedBox(height: 8),
        Row(
          children: [
            // Mahasiswa (selected)
            GestureDetector(
              onTap: () {}, // Already on Mahasiswa page
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFF4FC3F7), width: 2),
                      color: const Color(0xFF4FC3F7),
                    ),
                    child: const Center(
                      child: Icon(Icons.circle, size: 8, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'MAHASISWA',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            // Umum (tidak selected)
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RegisterCustomerUmumScreen(),
                  ),
                );
              },
              child: Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: Colors.grey.shade400, width: 2),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'UMUM',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUploadArea({
    required File? image,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF90CAF9),
            width: 1.5,
          ),
        ),
        child: image != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(image, fit: BoxFit.cover),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
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
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade400,
        ),
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
          borderSide: const BorderSide(
            color: Color(0xFF42A5F5),
            width: 1.5,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
