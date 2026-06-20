import 'package:flutter/material.dart';
import 'order_jastip_osm_route_screen.dart';

class OrderJastipScreen extends StatefulWidget {
  const OrderJastipScreen({super.key});

  @override
  State<OrderJastipScreen> createState() => _OrderJastipScreenState();
}

class _OrderJastipScreenState extends State<OrderJastipScreen> {
  String _selectedKategori = 'Makanan & Minuman';
  final List<_BelanjItem> _items = [_BelanjItem()];
  final _catatanController = TextEditingController();
  final _alamatController = TextEditingController();
  final _hargaJasaController = TextEditingController(text: '5.000');

  @override
  void dispose() {
    _catatanController.dispose();
    _alamatController.dispose();
    _hargaJasaController.dispose();
    for (final item in _items) {
      item.dispose();
    }
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
                        'JASTIP & BELANJA',
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
                  // Kategori Belanja
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
                        _buildPillLabel('Kategori Belanja'),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            'Makanan & Minuman',
                            'Alat Tulis',
                            'Kebutuhan Sehari-hari',
                            'Obat-obatan',
                            'Lainnya',
                          ]
                              .map((k) => _buildChip(k, _selectedKategori == k,
                                  () => setState(() => _selectedKategori = k)))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Daftar Belanjaan
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
                        _buildPillLabel('Daftar Belanjaan'),
                        const SizedBox(height: 12),
                        ...List.generate(_items.length, (i) => _buildItemRow(i)),
                        const SizedBox(height: 8),
                        GestureDetector(
                          onTap: () => setState(() => _items.add(_BelanjItem())),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, size: 16, color: Color(0xFF1565C0)),
                                SizedBox(width: 6),
                                Text(
                                  'Tambah Item',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1565C0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Lokasi Pengantaran
                  const Text(
                    'LOKASI PENGANTARAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _alamatController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Masukkan alamat pengantaran...',
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
                  const SizedBox(height: 16),
                  const Text(
                    'CATATAN TAMBAHAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _catatanController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      hintText: 'Contoh: pilihkan yang fresh, jangan yang manis...',
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

                  const Row(
                    children: [
                      Text(
                        'BIAYA JASA',
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
                    'TAWARKAN BIAYA JASA',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  _buildPriceInput(),
                  const SizedBox(height: 4),
                  Text(
                    'Biaya jasa di luar harga barang yang dibeli',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 40),

                  SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final hasItem = _items.any((i) => i.namaController.text.trim().isNotEmpty);
                          if (!hasItem) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Minimal isi 1 item belanjaan')),
                            );
                            return;
                          }
                          if (_alamatController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Alamat pengantaran harus diisi')),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const OrderJastipOsmRouteScreen()),
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
                              'CARI PENYEDIA JASTIP',
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
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : Colors.blue.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildItemRow(int index) {
    final item = _items[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: Color(0xFF1565C0),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: TextField(
              controller: item.namaController,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Nama barang...',
                hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                filled: true,
                fillColor: const Color(0xFFE3F2FD),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 58,
            child: TextField(
              controller: item.jumlahController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Jml',
                hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                filled: true,
                fillColor: const Color(0xFFE3F2FD),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
          ),
          if (_items.length > 1) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => setState(() {
                _items[index].dispose();
                _items.removeAt(index);
              }),
              child: const Icon(Icons.remove_circle_outline, color: Colors.red, size: 22),
            ),
          ],
        ],
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
              controller: _hargaJasaController,
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

class _BelanjItem {
  final namaController = TextEditingController();
  final jumlahController = TextEditingController(text: '1');

  void dispose() {
    namaController.dispose();
    jumlahController.dispose();
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
