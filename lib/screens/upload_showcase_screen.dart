import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class UploadShowcaseScreen extends StatefulWidget {
  const UploadShowcaseScreen({super.key});

  @override
  State<UploadShowcaseScreen> createState() => _UploadShowcaseScreenState();
}

class _UploadShowcaseScreenState extends State<UploadShowcaseScreen> {
  final _keteranganController = TextEditingController();
  final _picker = ImagePicker();

  String? _selectedKategori;
  File? _selectedImage;       // ← foto yang dipilih user
  bool _isUploading = false;

  final List<_ShowcaseItem> _portofolio = [];

  final List<Map<String, dynamic>> _kategoriList = [
    {'label': 'Antar Jemput',     'icon': Icons.motorcycle,       'color': const Color(0xFF1565C0)},
    {'label': 'Tenaga & Logistik','icon': Icons.local_shipping,   'color': const Color(0xFFE65100)},
    {'label': 'Kebersihan',       'icon': Icons.cleaning_services,'color': const Color(0xFF2E7D32)},
    {'label': 'Jastip & Belanja', 'icon': Icons.shopping_bag,     'color': const Color(0xFF6A1B9A)},
    {'label': 'Perbaikan Ringan', 'icon': Icons.build,            'color': const Color(0xFFC62828)},
    {'label': 'Sosial & Lainnya', 'icon': Icons.people,           'color': const Color(0xFF00695C)},
  ];

  @override
  void dispose() {
    _keteranganController.dispose();
    super.dispose();
  }

  // ── Pilih foto: tampilkan bottom sheet galeri / kamera ───────────────────
  Future<void> _showImageSourceSheet() async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pilih Sumber Foto',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.photo_library_outlined,
                      label: 'Galeri',
                      color: const Color(0xFF1565C0),
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.gallery);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSourceOption(
                      icon: Icons.camera_alt_outlined,
                      label: 'Kamera',
                      color: const Color(0xFF0288D1),
                      onTap: () {
                        Navigator.pop(ctx);
                        _pickImage(ImageSource.camera);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Jalankan image_picker ─────────────────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1920,
      );
      if (picked == null) return;
      setState(() => _selectedImage = File(picked.path));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memilih foto: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // ── Upload (simulasi) ─────────────────────────────────────────────────────
  Future<void> _pickAndUpload() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih foto terlebih dahulu'),
          backgroundColor: Color(0xFFE65100),
        ),
      );
      return;
    }
    if (_selectedKategori == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pilih kategori layanan terlebih dahulu'),
          backgroundColor: Color(0xFFE65100),
        ),
      );
      return;
    }
    if (_keteranganController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tulis keterangan foto terlebih dahulu'),
          backgroundColor: Color(0xFFE65100),
        ),
      );
      return;
    }

    setState(() => _isUploading = true);

    // TODO: ganti dengan upload ke Supabase Storage
    // final fileName = 'showcase_${authUser.id}_${DateTime.now().millisecondsSinceEpoch}.jpg';
    // await supabase.storage.from('showcase_photos').upload(fileName, _selectedImage!);
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;
    setState(() {
      _portofolio.insert(
        0,
        _ShowcaseItem(
          kategori: _selectedKategori!,
          keterangan: _keteranganController.text.trim(),
          tanggal: _formatTanggalHariIni(),
          imageFile: _selectedImage,
        ),
      );
      _selectedImage = null;
      _selectedKategori = null;
      _keteranganController.clear();
      _isUploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Portofolio berhasil diunggah!'),
        backgroundColor: Color(0xFF2E7D32),
      ),
    );
  }

  String _formatTanggalHariIni() {
    final now = DateTime.now();
    const bulan = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return '${now.day} ${bulan[now.month]} ${now.year}';
  }

  Color _getKategoriColor(String kategori) {
    final item = _kategoriList.firstWhere(
      (k) => k['label'] == kategori,
      orElse: () => {'color': const Color(0xFF1565C0)},
    );
    return item['color'] as Color;
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Upload Portofolio',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tampilkan hasil kerja terbaikmu agar customer semakin percaya.',
            style:
                TextStyle(fontSize: 12, color: Colors.grey.shade500, height: 1.4),
          ),
          const SizedBox(height: 20),

          // Card form upload
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.07),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFotoUploadArea(),
                const SizedBox(height: 20),

                const Text(
                  'Kategori Layanan',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
                const SizedBox(height: 10),
                _buildKategoriChips(),
                const SizedBox(height: 20),

                const Text(
                  'Keterangan Foto',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _keteranganController,
                  maxLines: 3,
                  maxLength: 200,
                  decoration: InputDecoration(
                    hintText:
                        'Contoh: Hasil bersih-bersih kos milik Mas Budi, Gebang...',
                    hintStyle:
                        TextStyle(fontSize: 12, color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: Color(0xFF29B6F6), width: 1.5),
                    ),
                    contentPadding: const EdgeInsets.all(14),
                    counterStyle:
                        TextStyle(fontSize: 10, color: Colors.grey.shade400),
                  ),
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 20),

                // Tips
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF8E1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color:
                            const Color(0xFFFFD54F).withValues(alpha: 0.5)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.lightbulb_outline,
                          size: 16, color: Color(0xFFE65100)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tips: Foto yang terang dan rapi meningkatkan kepercayaan customer. Hindari foto buram atau gelap.',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.orange.shade800,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Tombol Upload
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isUploading ? null : _pickAndUpload,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey.shade300,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    icon: _isUploading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Icon(Icons.cloud_upload_outlined, size: 20),
                    label: Text(
                      _isUploading ? 'Mengunggah...' : 'Upload Portofolio',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Daftar portofolio
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Portofolio Saya',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87),
              ),
              if (_portofolio.isNotEmpty)
                Text(
                  '${_portofolio.length} item',
                  style:
                      TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
            ],
          ),
          const SizedBox(height: 12),
          _portofolio.isEmpty
              ? _buildEmptyState()
              : _buildPortofolioList(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  // ── Area foto upload ──────────────────────────────────────────────────────
  Widget _buildFotoUploadArea() {
    return GestureDetector(
      onTap: _showImageSourceSheet,   // ← sekarang buka bottom sheet
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        height: 180,
        decoration: BoxDecoration(
          color: _selectedImage != null
              ? Colors.transparent
              : const Color(0xFFF0F7FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _selectedImage != null
                ? const Color(0xFF1565C0)
                : const Color(0xFF29B6F6).withValues(alpha: 0.4),
            width: _selectedImage != null ? 2 : 1.5,
          ),
        ),
        clipBehavior: Clip.hardEdge,
        child: _selectedImage != null
            ? _buildImagePreview()
            : _buildUploadPlaceholder(),
      ),
    );
  }

  // Preview foto yang sudah dipilih
  Widget _buildImagePreview() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
        ),
        // Overlay gelap tipis
        Container(
          color: Colors.black.withValues(alpha: 0.25),
        ),
        // Tombol ganti foto
        Center(
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.edit_outlined,
                    size: 16, color: Color(0xFF1565C0)),
                SizedBox(width: 6),
                Text(
                  'Ganti Foto',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Placeholder sebelum foto dipilih
  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0xFF1565C0).withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.add_photo_alternate_outlined,
            size: 30,
            color: Color(0xFF1565C0),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Ketuk untuk pilih foto',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1565C0),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Dari galeri atau kamera · Maks. 5 MB',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
      ],
    );
  }

  // ── Kategori chips ────────────────────────────────────────────────────────
  Widget _buildKategoriChips() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _kategoriList.map((item) {
        final isSelected = _selectedKategori == item['label'];
        final color = item['color'] as Color;
        return GestureDetector(
          onTap: () => setState(() {
            _selectedKategori =
                isSelected ? null : item['label'] as String;
          }),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? color : color.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? color
                    : color.withValues(alpha: 0.25),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item['icon'] as IconData,
                  size: 14,
                  color: isSelected ? Colors.white : color,
                ),
                const SizedBox(width: 6),
                Text(
                  item['label'] as String,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Empty state ───────────────────────────────────────────────────────────
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.photo_library_outlined,
              size: 48, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            'Belum ada portofolio',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Upload hasil kerjamu agar customer lebih yakin.',
            style:
                TextStyle(fontSize: 12, color: Colors.grey.shade400),
          ),
        ],
      ),
    );
  }

  // ── Daftar portofolio ─────────────────────────────────────────────────────
  Widget _buildPortofolioList() {
    return Column(
      children: _portofolio.map((item) {
        final color = _getKategoriColor(item.kategori);
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.06),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Thumbnail foto (asli jika ada)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: item.imageFile != null
                    ? Image.file(
                        item.imageFile!,
                        width: 68,
                        height: 68,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 68,
                        height: 68,
                        color: color.withValues(alpha: 0.1),
                        child: Icon(Icons.image_outlined,
                            size: 30,
                            color: color.withValues(alpha: 0.6)),
                      ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.kategori,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.keterangan,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.tanggal,
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey.shade400),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete_outline,
                    color: Colors.grey.shade400, size: 20),
                onPressed: () =>
                    setState(() => _portofolio.remove(item)),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _ShowcaseItem {
  final String kategori;
  final String keterangan;
  final String tanggal;
  final File? imageFile;         // ← simpan file asli untuk thumbnail

  _ShowcaseItem({
    required this.kategori,
    required this.keterangan,
    required this.tanggal,
    this.imageFile,
  });
}