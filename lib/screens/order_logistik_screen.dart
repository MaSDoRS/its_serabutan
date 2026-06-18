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
          // Header Curvy
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              width: double.infinity,
              height: 120,
              decoration: const BoxDecoration(color: Color(0xFF73C2DF)),
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
                        'Beranda Utama',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Title
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text(
              'Buat Pesanan Logistik',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFFE5D529),
                shadows: [
                  Shadow(
                    offset: Offset(0.5, 0.5),
                    color: Colors.black12,
                    blurRadius: 2,
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Column(
                children: [
                  // Deskripsi Barang
                  _buildInputCard(
                    title: 'Deskripsi Barang',
                    child: TextField(
                      controller: _deskripsiController,
                      maxLines: 3,
                      style: const TextStyle(fontSize: 13),
                      decoration: const InputDecoration(
                        hintText: 'Masukkan deskripsi barang',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.black38,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Titik Jemput — sekarang bisa diisi!
                  _buildInputCard(
                    title: 'Titik Jemput Barang',
                    child: TextField(
                      controller: _titikJemputController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Masukkan alamat titik jemput...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                        ),
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.circle,
                          size: 14,
                          color: Color(0xFFFFD54F),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Titik Antar — sekarang bisa diisi!
                  _buildInputCard(
                    title: 'Titik Antar Barang',
                    child: TextField(
                      controller: _titikAntarController,
                      style: const TextStyle(fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Masukkan alamat tujuan pengiriman...',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade400,
                        ),
                        border: InputBorder.none,
                        prefixIcon: const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Color(0xFFE53935),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Nama & No HP
                  Row(
                    children: [
                      Expanded(
                        child: _buildInputCard(
                          title: 'Nama Penerima',
                          child: TextField(
                            controller: _namaPenerimaController,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              hintText: 'Nama Penerima',
                              hintStyle: TextStyle(
                                fontSize: 10,
                                color: Colors.black38,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputCard(
                          title: 'No. HP Penerima',
                          child: TextField(
                            controller: _hpPenerimaController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              hintText: 'No. HP Penerima',
                              hintStyle: TextStyle(
                                fontSize: 10,
                                color: Colors.black38,
                              ),
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Berat & Jumlah Barang
                  Row(
                    children: [
                      Expanded(
                        child: _buildCounterCard(
                          title: 'Berat Barang (KG)',
                          value: _beratBarang,
                          onIncrement: () => setState(() => _beratBarang++),
                          onDecrement: () {
                            if (_beratBarang > 0)
                              setState(() => _beratBarang--);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildCounterCard(
                          title: 'Jumlah Barang',
                          value: _jumlahBarang,
                          onIncrement: () => setState(() => _jumlahBarang++),
                          onDecrement: () {
                            if (_jumlahBarang > 0)
                              setState(() => _jumlahBarang--);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // Button Cari
                  SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_titikJemputController.text.trim().isEmpty ||
                              _titikAntarController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Titik jemput dan titik antar harus diisi',
                                ),
                              ),
                            );
                            return;
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const PilihPenyediaJasaScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFBE122),
                          foregroundColor: Colors.black87,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'CARI PENYEDIA JASA',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w800,
                          ),
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

  Widget _buildInputCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF73C2DF),
              ),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildCounterCard({
    required String title,
    required int value,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: Color(0xFF73C2DF),
              ),
            ),
          ),
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
                      child: const Icon(
                        Icons.keyboard_arrow_up,
                        size: 14,
                        color: Color(0xFFFBE122),
                      ),
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
                      child: const Icon(
                        Icons.keyboard_arrow_down,
                        size: 14,
                        color: Color(0xFFFBE122),
                      ),
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
    path.quadraticBezierTo(
      size.width / 2,
      size.height + 10,
      size.width,
      size.height - 30,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
