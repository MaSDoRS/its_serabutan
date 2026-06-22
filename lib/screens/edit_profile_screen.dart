import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _supabase = Supabase.instance.client;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _namaController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _nrpController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String _initial = 'U';
  String _email = '';
  String? _identityType;
  bool _isVerified = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final email = _supabase.auth.currentUser?.email;
      if (email == null) return;
      final data = await _supabase
          .from('users')
          .select()
          .eq('email', email)
          .single();
      if (mounted) {
        final nama = (data['name'] ?? '') as String;
        setState(() {
          _email = email;
          _namaController.text = nama;
          _whatsappController.text = (data['phone'] ?? '') as String;
          _nrpController.text = (data['identity_number'] ?? '') as String;
          _initial = nama.isNotEmpty ? nama[0].toUpperCase() : 'U';
          _identityType = data['identity_type'] as String?;
          _isVerified = data['identity_photo_url'] != null;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _simpan() async {
    final nama = _namaController.text.trim();
    final phone = _whatsappController.text.trim();
    final nrp = _nrpController.text.trim();

    if (nama.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final uid = _supabase.auth.currentUser!.id;
      // Cover customer (auth_uid) dan mitra (id)
      await _supabase.from('users').update({
        'name': nama,
        'phone': phone,
        'identity_number': nrp,
      }).or('auth_uid.eq.$uid,id.eq.$uid');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil diperbarui'),
            backgroundColor: Color(0xFF43A047),
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menyimpan: $e')),
        );
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _whatsappController.dispose();
    _nrpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildAppBar(context),
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 24),
                      _buildAvatar(),
                      const SizedBox(height: 28),
                      _buildSectionHeader('DATA DIRI'),
                      const SizedBox(height: 20),
                      _buildLabel('NAMA LENGKAP'),
                      const SizedBox(height: 8),
                      _buildTextField(controller: _namaController),
                      const SizedBox(height: 18),
                      _buildLabel('EMAIL'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: TextEditingController(text: _email),
                        enabled: false,
                      ),
                      const SizedBox(height: 18),
                      _buildLabel('NOMOR WHATSAPP'),
                      const SizedBox(height: 8),
                      _buildTextField(
                        controller: _whatsappController,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 18),
                      _buildLabel('NRP / NIM'),
                      const SizedBox(height: 8),
                      _buildTextField(controller: _nrpController),
                      const SizedBox(height: 28),
                      if (_isVerified) _buildVerifikasiIdentitas(),
                      const SizedBox(height: 28),
                      _buildSaveButton(),
                      const SizedBox(height: 32),
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
                  'Edit Profil',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Column(
      children: [
        Container(
          width: 88,
          height: 88,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF0288D1),
            border: Border.all(color: const Color(0xFFFFD54F), width: 3),
          ),
          child: Center(
            child: Text(
              _initial,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _email,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1565C0),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: Colors.black87,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    bool enabled = true,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      style: TextStyle(fontSize: 14, color: enabled ? Colors.black87 : Colors.grey.shade500),
      decoration: InputDecoration(
        filled: true,
        fillColor: enabled ? const Color(0xFFE3F2FD) : Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        disabledBorder: OutlineInputBorder(
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

  Widget _buildVerifikasiIdentitas() {
    final label = _identityType == 'ktm' ? 'KTM Terverifikasi' : 'KTP Terverifikasi';
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'VERIFIKASI IDENTITAS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFFFFB300),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1565C0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.credit_card, color: Colors.white, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 14),
                      SizedBox(width: 4),
                      Text('Valid',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4CAF50))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Identitas tidak dapat diubah setelah diverifikasi',
            style: TextStyle(fontSize: 11, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton(
      onPressed: _isSaving ? null : _simpan,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF0288D1),
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey.shade300,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
      ),
      child: _isSaving
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
            )
          : const Text(
              'Simpan Perubahan',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
            ),
    );
  }
}
