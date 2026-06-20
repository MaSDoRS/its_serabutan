import 'package:flutter/material.dart';
import 'pilih_mitra_screen.dart';

class OrderAntarJemputScreen extends StatefulWidget {
  const OrderAntarJemputScreen({super.key});

  @override
  State<OrderAntarJemputScreen> createState() => _OrderAntarJemputScreenState();
}

class _OrderAntarJemputScreenState extends State<OrderAntarJemputScreen> {
  String _selectedKendaraan = 'Motor';
  final _hargaController = TextEditingController(text: '35.000');
  final _catatanController = TextEditingController();
  final _titikJemputController = TextEditingController();
  final _tujuanController = TextEditingController();

  @override
  void dispose() {
    _hargaController.dispose();
    _catatanController.dispose();
    _titikJemputController.dispose();
    _tujuanController.dispose();
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
                        'ANTAR JEMPUT',
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
                  // Pilih Kendaraan
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
                        _buildPillLabel('Pilih Kendaraan'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _buildVehicleOption('Motor', Icons.two_wheeler),
                            const SizedBox(width: 10),
                            _buildVehicleOption('Mobil', Icons.directions_car),
                            const SizedBox(width: 10),
                            _buildVehicleOption('Pickup', Icons.local_shipping),
                            const SizedBox(width: 10),
                            _buildVehicleOption('Lainnya', Icons.more_horiz),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Titik Jemput & Tujuan
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
                        _buildPillLabel('Titik Jemput & Tujuan'),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.circle, size: 14, color: Color(0xFFFFD54F)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _titikJemputController,
                                style: const TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: 'Masukkan titik jemput...',
                                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                                  filled: true,
                                  fillColor: const Color(0xFFE3F2FD),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 7),
                          child: Container(width: 2, height: 12, color: Colors.grey.shade300),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: Color(0xFFE53935)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                controller: _tujuanController,
                                style: const TextStyle(fontSize: 13),
                                decoration: InputDecoration(
                                  hintText: 'Masukkan tujuan...',
                                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                                  filled: true,
                                  fillColor: const Color(0xFFE3F2FD),
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                          ],
                        ),
                        const SizedBox(height: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildHistoryChip('RSUD Dr. Soetomo'),
                              const SizedBox(width: 8),
                              _buildHistoryChip('ITS Sukolilo'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Text(
                    'CATATAN UNTUK DRIVER',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _catatanController,
                    style: const TextStyle(fontSize: 13),
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Contoh: bawa barang 1 tas, helm ada...',
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
                    'TAWARKAN BUDGET KAMU',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  _buildPriceInput(),
                  const SizedBox(height: 4),
                  Text(
                    'Driver bisa menerima atau menawar harga kamu',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 40),

                  SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_titikJemputController.text.trim().isEmpty ||
                              _tujuanController.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Titik jemput dan tujuan harus diisi')),
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
                              'CARI DRIVER',
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

  Widget _buildVehicleOption(String label, IconData icon) {
    final isSelected = _selectedKendaraan == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedKendaraan = label),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE3F2FD) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? const Color(0xFF1565C0) : Colors.blue.shade100,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: isSelected ? const Color(0xFF1565C0) : Colors.blue.shade200,
                  size: 28,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? const Color(0xFF1565C0) : Colors.blue.shade300,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryChip(String label) {
    return GestureDetector(
      onTap: () => setState(() => _tujuanController.text = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.blue.shade100),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF1565C0)),
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
