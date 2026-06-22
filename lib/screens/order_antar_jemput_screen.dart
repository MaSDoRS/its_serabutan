import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'pilih_mitra_screen.dart';
import 'map_picker_screen.dart';
import '../models/order_data.dart';
import '../widgets/mini_route_map_widget.dart';

class OrderAntarJemputScreen extends StatefulWidget {
  const OrderAntarJemputScreen({super.key});

  @override
  State<OrderAntarJemputScreen> createState() => _OrderAntarJemputScreenState();
}

class _OrderAntarJemputScreenState extends State<OrderAntarJemputScreen> {
  int _selectedVehicleIndex = 0;
  String? _selectedDestination;
  final _titikJemputController = TextEditingController();
  final _tujuanController = TextEditingController();
  LatLng? _titikJemputLatLng;
  LatLng? _tujuanLatLng;

  final List<Map<String, dynamic>> _vehicles = [
    {'label': 'Motor', 'icon': Icons.two_wheeler},
    {'label': 'Mobil', 'icon': Icons.directions_car},
    {'label': 'Pickup', 'icon': Icons.local_shipping},
    {'label': 'Lainnya', 'icon': Icons.more_horiz},
  ];

  final List<Map<String, String>> _destinations = [
    {'name': 'Keputih, Mulyosari, Gebang', 'price': 'Rp 8.000'},
    {'name': 'Unair, Gubeng', 'price': 'Rp 15.000'},
    {'name': 'Surabaya Tengah', 'price': 'Rp 20.000'},
    {'name': 'Surabaya Barat', 'price': 'Rp 30.000'},
  ];

  @override
  void dispose() {
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
                  // ── PILIH KENDARAAN ──
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('PILIH KENDARAAN'),
                        const SizedBox(height: 16),
                        Row(
                          children: List.generate(_vehicles.length, (index) {
                            final isSelected = _selectedVehicleIndex == index;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: index == 0 ? 0 : 6,
                                  right: index == _vehicles.length - 1 ? 0 : 6,
                                ),
                                child: _buildVehicleOption(
                                  _vehicles[index]['label'],
                                  _vehicles[index]['icon'],
                                  isSelected,
                                  () => setState(() => _selectedVehicleIndex = index),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
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
                                    fillColor: const Color(0xFFE3F2FD),
                                    onPicker: _pickJemput,
                                  ),
                                  const SizedBox(height: 14),
                                  _buildLocationField(
                                    controller: _tujuanController,
                                    hintText: 'Pilih lokasi tujuan',
                                    fillColor: Colors.grey.shade50,
                                    onPicker: _pickTujuan,
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
                  const SizedBox(height: 16),

                  // ── LOKASI TUJUAN ──
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('LOKASI TUJUAN'),
                        const SizedBox(height: 16),
                        ..._destinations.map(
                          (dest) => _buildDestinationRow(dest['name']!, dest['price']!),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // ── Sticky CARI MITRA button ──
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
                    'CARI MITRA',
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
                  'Antar Jemput',
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
                  Icons.sports_motorsports,
                  color: Color(0xFF0288D1),
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

  Widget _buildVehicleOption(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE3F2FD) : const Color(0xFFE8F5FE),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF29B6F6) : Colors.blue.shade100,
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF29B6F6).withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF0288D1) : Colors.blue.shade200,
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: isSelected ? const Color(0xFF0288D1) : Colors.blue.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickJemput() async {
    final r = await Navigator.push<MapPickerResult>(context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen(title: 'Titik Jemput')));
    if (r != null) setState(() { _titikJemputController.text = r.address; _titikJemputLatLng = r.latLng; });
  }

  Future<void> _pickTujuan() async {
    final r = await Navigator.push<MapPickerResult>(context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen(title: 'Titik Tujuan')));
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

  Widget _buildDestinationRow(String name, String price) {
    final isSelected = _selectedDestination == name;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDestination = name;
          _tujuanController.text = name;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFE3F2FD).withValues(alpha: 0.5)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? const Color(0xFF29B6F6) : Colors.blue.shade100,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Text(
                price,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? const Color(0xFF0288D1) : const Color(0xFF1565C0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCariMitra() {
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
        builder: (context) => PilihMitraScreen(
          orderData: OrderData(
            jenisLayanan: 'Antar Jemput',
            jenisKendaraan: _vehicles[_selectedVehicleIndex]['label'] as String,
            titikJemput: _titikJemputController.text.trim(),
            tujuan: _selectedDestination ?? _tujuanController.text.trim(),
            hargaAntarJemput: _selectedDestination != null
                ? (_destinations.firstWhere(
                        (d) => d['name'] == _selectedDestination,
                        orElse: () => {'price': ''})['price'] ??
                    '')
                : '',
          ),
        ),
      ),
    );
  }
}
