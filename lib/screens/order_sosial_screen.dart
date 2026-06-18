import 'package:flutter/material.dart';
import 'pilih_mitra_screen.dart';

class OrderSosialScreen extends StatefulWidget {
  const OrderSosialScreen({super.key});

  @override
  State<OrderSosialScreen> createState() => _OrderSosialScreenState();
}

class _OrderSosialScreenState extends State<OrderSosialScreen> {
  String _selectedKategori = 'Teman Makan';
  String _selectedPreferensi = 'Tidak ada preferensi';

  final _judulController = TextEditingController();
  final _detailController = TextEditingController();
  final _lokasiController = TextEditingController();
  final _waktuController = TextEditingController();
  final _hargaController = TextEditingController(text: '35.000');

  @override
  void dispose() {
    _judulController.dispose();
    _detailController.dispose();
    _lokasiController.dispose();
    _waktuController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF29B6F6),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'SOSIAL & LAINNYA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: Icon(Icons.people, size: 18, color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader('KATEGORI JASA'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        [
                              'Teman Makan',
                              'Teman Belajar',
                              'Titip Hewan',
                              'Lainnya',
                            ]
                            .map(
                              (k) => _buildChip(
                                k,
                                _selectedKategori == k,
                                (val) =>
                                    setState(() => _selectedKategori = val),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Pernah ada: cari kodok, cari kelabang, dll. Semua bisa!',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 28),

                  _buildSectionHeader('CERITAIN KEBUTUHANMU'),
                  const SizedBox(height: 12),
                  _buildLabel('JUDUL PERMINTAAN'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _judulController,
                    hintText: 'Contoh: Cari Teman Makan Siang di Kantin ITS',
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('DETAIL PERMINTAAN'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller: _detailController,
                    hintText: 'Ceritain lebih detail kebutuhanmu...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('PREFERENSI MITRA'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        ['Sesama cewek', 'Sesama cowok', 'Tidak ada preferensi']
                            .map(
                              (p) => _buildChip(
                                p,
                                _selectedPreferensi == p,
                                (val) =>
                                    setState(() => _selectedPreferensi = val),
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 28),

                  _buildSectionHeader('LOKASI & WAKTU'),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('LOKASI'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _lokasiController,
                              hintText: 'Contoh: Kantin TC ITS',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel('WAKTU'),
                            const SizedBox(height: 8),
                            _buildTextField(
                              controller: _waktuController,
                              hintText: 'Contoh: 12.00 WIB',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildLabel('BUDGET'),
                  const SizedBox(height: 8),
                  _buildPriceInput(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_judulController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Judul permintaan harus diisi'),
                        ),
                      );
                      return;
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PilihMitraScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD54F),
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'CARI MITRA',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1565C0),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Container(height: 1, color: Colors.blue.shade100)),
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(fontSize: 13),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF42A5F5), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildChip(String label, bool isSelected, Function(String) onTap) {
    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF29B6F6) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF29B6F6) : Colors.blue.shade200,
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

  Widget _buildPriceInput() {
    return Container(
      decoration: BoxDecoration(
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
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
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
