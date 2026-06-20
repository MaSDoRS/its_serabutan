import 'package:flutter/material.dart';
import 'pilih_mitra_screen.dart';

class OrderKebersihanScreen extends StatefulWidget {
  const OrderKebersihanScreen({super.key});

  @override
  State<OrderKebersihanScreen> createState() => _OrderKebersihanScreenState();
}

class _OrderKebersihanScreenState extends State<OrderKebersihanScreen> {
  String _selectedJenis = 'Kamar Kos';
  String _selectedKondisi = 'Kotor Sedang';
  final _deskripsiController = TextEditingController();
  final _alamatController = TextEditingController();
  final _hargaController = TextEditingController(text: '35.000');
  int _jumlahOrang = 1;

  @override
  void dispose() {
    _deskripsiController.dispose();
    _alamatController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: Column(
        children: [
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: const BoxDecoration(color: Color(0xFF1565C0)),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'KEBERSIHAN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Jenis & Kondisi
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPillLabel('Jenis Kebersihan'),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['Kamar Kos', 'Tempat Usaha', 'Cuci Motor', 'Lainnya']
                              .map((k) => _buildChip(k, _selectedJenis == k,
                                  () => setState(() => _selectedJenis = k)))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        _buildPillLabel('Kondisi Lokasi'),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: ['Kotor Ringan', 'Kotor Sedang', 'Kotor Berat']
                              .map((k) => _buildChip(k, _selectedKondisi == k,
                                  () => setState(() => _selectedKondisi = k)))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                        _buildPillLabel('Deskripsi Tambahan'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _deskripsiController,
                          maxLines: 3,
                          style: const TextStyle(fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Isi deskripsi kondisi kebersihan disini...',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.black45),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'ALAMAT LENGKAP',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _alamatController,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Masukkan alamat lokasi kebersihan...',
                      hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                      filled: true,
                      fillColor: const Color(0xFFE3F2FD),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFF42A5F5), width: 1.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Jadwal & Jumlah Orang
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildPillLabel('Jadwal Pengerjaan'),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(child: _buildChip('Pilih Tanggal', false, () {})),
                            const SizedBox(width: 8),
                            Expanded(child: _buildChip('Pilih Waktu', false, () {})),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildPillLabel('Jumlah Orang Dibutuhkan'),
                        const SizedBox(height: 10),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.blue.shade100),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove, color: Color(0xFF1565C0)),
                                onPressed: () {
                                  if (_jumlahOrang > 1) setState(() => _jumlahOrang--);
                                },
                              ),
                              Text(
                                '$_jumlahOrang Orang',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add, color: Color(0xFF1565C0)),
                                onPressed: () => setState(() => _jumlahOrang++),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Row(
                    children: [
                      Text(
                        'PENAWARAN HARGA',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'BUDGET KAMU',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  _buildPriceInput(),
                  const SizedBox(height: 4),
                  Text(
                    'Mitra bisa menerima atau menawar harga kamu',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 40),

                  SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_alamatController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Alamat harus diisi')),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PilihMitraScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBE122),
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'CARI MITRA KEBERSIHAN',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillLabel(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1565C0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Colors.white),
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1565C0) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF1565C0) : Colors.blue.shade200,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : Colors.blue.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildPriceInput() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(9),
                bottomLeft: Radius.circular(9),
              ),
            ),
            child: const Text(
              'Rp',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _hargaController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1565C0),
              ),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 30);
    path.quadraticBezierTo(size.width / 2, size.height + 10, size.width, size.height - 30);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
