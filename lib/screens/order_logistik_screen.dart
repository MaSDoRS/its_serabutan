import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'pilih_penyedia_jasa_screen.dart';
import 'map_picker_screen.dart';
import '../models/order_data.dart';
import '../widgets/mini_route_map_widget.dart';

class OrderLogistikScreen extends StatefulWidget {
  const OrderLogistikScreen({super.key});

  @override
  State<OrderLogistikScreen> createState() => _OrderLogistikScreenState();
}

class _OrderLogistikScreenState extends State<OrderLogistikScreen> {
  final _deskripsiController = TextEditingController();
  final _titikJemputController = TextEditingController();
  final _tujuanController = TextEditingController();
  LatLng? _titikJemputLatLng;
  LatLng? _tujuanLatLng;

  double _beratBarang = 0;
  int _jumlahBarang = 0;

  @override
  void dispose() {
    _deskripsiController.dispose();
    _titikJemputController.dispose();
    _tujuanController.dispose();
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
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── DESKRIPSI BARANG ──
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('Deskripsi Barang'),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _deskripsiController,
                          maxLines: 5,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Masukkan deskripsi tenaga atau logistik',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w400,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue.shade100),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.blue.shade100),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                color: Color(0xFF42A5F5),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── BERAT & JUMLAH BARANG ──
                  Row(
                    children: [
                      Expanded(
                        child: _buildStepperCard(
                          label: 'Berat Barang (KG)',
                          value: _beratBarang.toStringAsFixed(
                              _beratBarang.truncateToDouble() == _beratBarang ? 0 : 1),
                          hint: 'Masukkan Berat',
                          onIncrement: () => setState(() => _beratBarang += 1),
                          onDecrement: () {
                            if (_beratBarang > 0) setState(() => _beratBarang -= 1);
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStepperCard(
                          label: 'Jumlah Barang',
                          value: _jumlahBarang.toString(),
                          hint: 'Masukkan Jumlah',
                          onIncrement: () => setState(() => _jumlahBarang += 1),
                          onDecrement: () {
                            if (_jumlahBarang > 0) setState(() => _jumlahBarang -= 1);
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── TITIK JEMPUT & TUJUAN ──
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('TITIK JEMPUT & TUJUAN'),
                        const SizedBox(height: 20),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Dot connector
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Column(
                                children: [
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFD54F),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFFD54F).withValues(alpha: 0.4),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 2,
                                    height: 36,
                                    margin: const EdgeInsets.symmetric(vertical: 2),
                                    color: Colors.grey.shade300,
                                  ),
                                  Container(
                                    width: 14,
                                    height: 14,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1565C0),
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF1565C0).withValues(alpha: 0.4),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                children: [
                                  _buildLocationField(
                                    controller: _titikJemputController,
                                    hintText: 'Pilih lokasi jemput',
                                    onPicker: _pickJemput,
                                    fillColor: const Color(0xFFE3F2FD),
                                  ),
                                  const SizedBox(height: 14),
                                  _buildLocationField(
                                    controller: _tujuanController,
                                    hintText: 'Pilih lokasi tujuan',
                                    onPicker: _pickTujuan,
                                    fillColor: Colors.grey.shade50,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (_titikJemputLatLng != null) ...[
                          const SizedBox(height: 16),
                          MiniRouteMapWidget(
                            pointA: _titikJemputLatLng,
                            pointB: _tujuanLatLng,
                            labelA: 'Jemput',
                            labelB: 'Tujuan',
                            onEditA: _pickJemput,
                            onEditB: _pickTujuan,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Sticky CARI PENYEDIA JASA button ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onCariMitra,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD54F),
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 2,
                    shadowColor: const Color(0xFFFFD54F).withValues(alpha: 0.4),
                  ),
                  child: const Text(
                    'CARI PENYEDIA JASA',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
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
                  'Tenaga & Logistik',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.inventory_2,
                  color: Color(0xFFFF8F00),
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade50, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
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
        const SizedBox(width: 10),
        Expanded(child: Container(height: 1.5, color: Colors.blue.shade100)),
      ],
    );
  }

  Widget _buildStepperCard({
    required String label,
    required String value,
    required String hint,
    required VoidCallback onIncrement,
    required VoidCallback onDecrement,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade50, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value == '0' ? hint : value,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: value == '0' ? FontWeight.w400 : FontWeight.w600,
                    color: value == '0' ? Colors.grey.shade400 : Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStepperArrow(
                icon: Icons.keyboard_arrow_up,
                onTap: onIncrement,
                color: const Color(0xFF66BB6A),
              ),
              const SizedBox(height: 2),
              _buildStepperArrow(
                icon: Icons.keyboard_arrow_down,
                onTap: onDecrement,
                color: const Color(0xFF66BB6A),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStepperArrow({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 20, color: color),
      ),
    );
  }

  Future<void> _pickJemput() async {
    final r = await Navigator.push<MapPickerResult>(context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen(title: 'Titik Jemput Barang')));
    if (r != null) setState(() { _titikJemputController.text = r.address; _titikJemputLatLng = r.latLng; });
  }

  Future<void> _pickTujuan() async {
    final r = await Navigator.push<MapPickerResult>(context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen(title: 'Tujuan Pengiriman')));
    if (r != null) setState(() { _tujuanController.text = r.address; _tujuanLatLng = r.latLng; });
  }

  Widget _buildLocationField({
    required TextEditingController controller,
    required String hintText,
    required Color fillColor,
    required VoidCallback onPicker,
  }) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.only(left: 16, right: 4, top: 14, bottom: 14),
        suffixIcon: IconButton(
          icon: const Icon(Icons.map_outlined, size: 20, color: Color(0xFF0288D1)),
          tooltip: 'Pilih di peta',
          onPressed: onPicker,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.blue.shade100)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.blue.shade100)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF42A5F5), width: 1.5)),
      ),
    );
  }

  void _onCariMitra() {
    if (_deskripsiController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Deskripsi barang harus diisi'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xFF0288D1),
        ),
      );
      return;
    }
    if (_titikJemputController.text.trim().isEmpty ||
        _tujuanController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Titik jemput dan tujuan harus diisi'),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          backgroundColor: const Color(0xFF0288D1),
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PilihPenyediaJasaScreen(
          orderData: OrderData(
            jenisLayanan: 'Logistik',
            deskripsi: _deskripsiController.text.trim(),
            titikJemput: _titikJemputController.text.trim(),
            tujuan: _tujuanController.text.trim(),
            berat: _beratBarang.toStringAsFixed(0),
            jumlahBarang: _jumlahBarang,
          ),
        ),
      ),
    );
  }
}
