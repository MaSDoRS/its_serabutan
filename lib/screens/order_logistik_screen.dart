import 'package:flutter/material.dart';
import 'pilih_penyedia_jasa_screen.dart';

class OrderLogistikScreen extends StatefulWidget {
  const OrderLogistikScreen({super.key});

  @override
  State<OrderLogistikScreen> createState() => _OrderLogistikScreenState();
}

class _OrderLogistikScreenState extends State<OrderLogistikScreen> {
  final _deskripsiController = TextEditingController();
  final _namaPenerimaController = TextEditingController();
  final _hpPenerimaController = TextEditingController();
  final _titikJemputController = TextEditingController();
  final _titikAntarController = TextEditingController();
  int _beratBarang = 0;
  int _jumlahBarang = 0;

  @override
  void dispose() {
    _deskripsiController.dispose();
    _namaPenerimaController.dispose();
    _hpPenerimaController.dispose();
    _titikJemputController.dispose();
    _titikAntarController.dispose();
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
                        'LOGISTIK',
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
                  // Deskripsi Barang
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
                        _buildPillLabel('Deskripsi Barang'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _deskripsiController,
                          maxLines: 3,
                          style: const TextStyle(fontSize: 13),
                          decoration: const InputDecoration(
                            hintText: 'Masukkan deskripsi barang yang dikirim...',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.black45),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Titik Jemput
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
                        _buildPillLabel('Titik Jemput Barang'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _titikJemputController,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Masukkan alamat titik jemput...',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                            filled: true,
                            fillColor: const Color(0xFFE3F2FD),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            prefixIcon: const Icon(Icons.circle, size: 14, color: Color(0xFFFFD54F)),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Titik Antar
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
                        _buildPillLabel('Titik Antar Barang'),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _titikAntarController,
                          style: const TextStyle(fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Masukkan alamat tujuan pengiriman...',
                            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                            filled: true,
                            fillColor: const Color(0xFFE3F2FD),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            prefixIcon: const Icon(Icons.location_on, size: 14, color: Color(0xFFE53935)),
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
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nama & HP Penerima
                  Row(
                    children: [
                      Expanded(
                        child: Container(
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
                              _buildPillLabel('Nama Penerima'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _namaPenerimaController,
                                style: const TextStyle(fontSize: 12),
                                decoration: const InputDecoration(
                                  hintText: 'Nama penerima...',
                                  hintStyle: TextStyle(fontSize: 11, color: Colors.black38),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
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
                              _buildPillLabel('No. HP Penerima'),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _hpPenerimaController,
                                keyboardType: TextInputType.phone,
                                style: const TextStyle(fontSize: 12),
                                decoration: const InputDecoration(
                                  hintText: 'No. HP...',
                                  hintStyle: TextStyle(fontSize: 11, color: Colors.black38),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Berat & Jumlah
                  Row(
                    children: [
                      Expanded(
                        child: _buildCounterCard(
                          label: 'Berat Barang (KG)',
                          value: _beratBarang,
                          onIncrement: () => setState(() => _beratBarang++),
                          onDecrement: () {
                            if (_beratBarang > 0) setState(() => _beratBarang--);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCounterCard(
                          label: 'Jumlah Barang',
                          value: _jumlahBarang,
                          onIncrement: () => setState(() => _jumlahBarang++),
                          onDecrement: () {
                            if (_jumlahBarang > 0) setState(() => _jumlahBarang--);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_titikJemputController.text.trim().isEmpty ||
                              _titikAntarController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Titik jemput dan titik antar harus diisi')),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PilihPenyediaJasaScreen()),
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
                              'CARI PENYEDIA JASA LOGISTIK',
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

  Widget _buildCounterCard({
    required String label,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          _buildPillLabel(label),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  value.toString(),
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: value > 0 ? const Color(0xFF1565C0) : Colors.black38,
                  ),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: onIncrement,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFBE122)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.keyboard_arrow_up, size: 14, color: Color(0xFFFBE122)),
                    ),
                  ),
                  const SizedBox(height: 4),
                  GestureDetector(
                    onTap: onDecrement,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFBE122)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Icon(Icons.keyboard_arrow_down, size: 14, color: Color(0xFFFBE122)),
                    ),
                  ),
                ],
              ),
            ],
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
