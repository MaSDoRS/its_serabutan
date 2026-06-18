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
  final _deskripsiController = TextEditingController(
      text: 'Contoh: Kamar 3x4m, ada 1 kamar mandi, sudah 2 minggu tidak dibersihkan...');
  final _alamatController = TextEditingController(
      text: 'Jl. Keputih No. 999, Blok ZZ, Kos Mawar...');
  int _jumlahOrang = 1;
  final _hargaController = TextEditingController(text: '35.000');

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
          'KEBERSIHAN',
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
              child: Icon(
                Icons.cleaning_services,
                size: 18,
                color: Colors.grey.shade600,
              ),
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
                  // Detail Pekerjaan
                  _buildSectionHeader('DETAIL PEKERJAAN'),
                  const SizedBox(height: 12),
                  const Text(
                    'JENIS KEBERSIHAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChip('Kamar Kos', _selectedJenis == 'Kamar Kos', (val) => setState(() => _selectedJenis = val)),
                      _buildChip('Tempat Usaha', _selectedJenis == 'Tempat Usaha', (val) => setState(() => _selectedJenis = val)),
                      _buildChip('Cuci Motor', _selectedJenis == 'Cuci Motor', (val) => setState(() => _selectedJenis = val)),
                      _buildChip('Lainnya', _selectedJenis == 'Lainnya', (val) => setState(() => _selectedJenis = val)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'DESKRIPSI TAMBAHAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _deskripsiController,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'KONDISI LOKASI',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildChip('Kotor Ringan', _selectedKondisi == 'Kotor Ringan', (val) => setState(() => _selectedKondisi = val)),
                      _buildChip('Kotor Sedang', _selectedKondisi == 'Kotor Sedang', (val) => setState(() => _selectedKondisi = val)),
                      _buildChip('Kotor Berat', _selectedKondisi == 'Kotor Berat', (val) => setState(() => _selectedKondisi = val)),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Lokasi & Waktu
                  _buildSectionHeader('LOKASI & WAKTU'),
                  const SizedBox(height: 12),
                  const Text(
                    'ALAMAT LENGKAP',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _alamatController,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 13),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.blue.shade200),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'JADWAL PENGERJAAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: _buildChip('Sabtu, 25 Mei', true, (val) {})),
                      const SizedBox(width: 8),
                      Expanded(child: _buildChip('08.00 WIB', false, (val) {})),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'JUMLAH ORANG YANG DIBUTUHKAN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildCounter(),
                  const SizedBox(height: 28),

                  // Penawaran Harga
                  _buildSectionHeader('PENAWARAN HARGA'),
                  const SizedBox(height: 12),
                  const Text(
                    'BUDGET KAMU (MODEL INDRIVE)',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildPriceInput(),
                  const SizedBox(height: 4),
                  Text(
                    'Mitra bisa menerima atau menawar harga kamu',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          // Sticky button
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
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
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'CARI MITRA KEBERSIHAN',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 20),
                  ],
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

  Widget _buildCounter() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue.shade200),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.remove, color: Color(0xFF1565C0)),
            onPressed: () {
              if (_jumlahOrang > 1) {
                setState(() => _jumlahOrang--);
              }
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
            onPressed: () {
              setState(() => _jumlahOrang++);
            },
          ),
        ],
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
