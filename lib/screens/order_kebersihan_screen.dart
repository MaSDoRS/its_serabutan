import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'pilih_mitra_screen.dart';
import 'map_picker_screen.dart';
import '../models/order_data.dart';
import '../widgets/mini_route_map_widget.dart';

class OrderKebersihanScreen extends StatefulWidget {
  const OrderKebersihanScreen({super.key});

  @override
  State<OrderKebersihanScreen> createState() => _OrderKebersihanScreenState();
}

class _OrderKebersihanScreenState extends State<OrderKebersihanScreen> {
  String _selectedJenis = 'Kamar Kos';
  String _selectedKondisi = 'Kotor Sedang';
  int _jumlahMitra = 1;
  final _deskripsiController = TextEditingController();
  final _alamatController = TextEditingController();
  LatLng? _alamatLatLng;

  final List<String> _jenisKebersihan = [
    'Kamar Kos',
    'Tempat Usaha',
    'Cuci Motor',
    'Lainnya',
  ];

  final List<String> _kondisiOptions = [
    'Kotor Ringan',
    'Kotor Sedang',
    'Kotor Berat',
  ];

  @override
  void dispose() {
    _deskripsiController.dispose();
    _alamatController.dispose();
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
                  // ── DETAIL PEKERJAAN ──
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('DETAIL PEKERJAAN'),
                        const SizedBox(height: 20),
                        const Text(
                          'JENIS KEBERSIHAN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _jenisKebersihan
                              .map((jenis) => _buildSelectableChip(
                                    label: jenis,
                                    isSelected: _selectedJenis == jenis,
                                    onTap: () => setState(() => _selectedJenis = jenis),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'DESKRIPSI TAMBAHAN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _deskripsiController,
                          maxLines: 4,
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                          decoration: InputDecoration(
                            hintText:
                                'Masukkan detail lengkap..\nContoh: Kamar 3×4m, ada 1 kamar mandi,\nsudah 2 minggu tidak dibersihkan.',
                            hintStyle: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                              fontWeight: FontWeight.w400,
                              height: 1.5,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                              borderSide: const BorderSide(color: Color(0xFF42A5F5), width: 1.5),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'KONDISI',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: _kondisiOptions
                              .map((kondisi) => _buildSelectableChip(
                                    label: kondisi,
                                    isSelected: _selectedKondisi == kondisi,
                                    onTap: () => setState(() => _selectedKondisi = kondisi),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── LOKASI ──
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader('LOKASI'),
                        const SizedBox(height: 20),
                        const Text(
                          'ALAMAT LENGKAP',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildAlamatField(),
                        const SizedBox(height: 24),
                        const Text(
                          'JUMLAH MITRA YANG DIBUTUHKAN',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildMitraCounter(),
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
                  'Kebersihan',
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
                  Icons.cleaning_services,
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

  Widget _buildSelectableChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF29B6F6) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? const Color(0xFF29B6F6) : Colors.blue.shade200,
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF29B6F6).withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildMitraCounter() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.blue.shade100, width: 1.5),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              if (_jumlahMitra > 1) setState(() => _jumlahMitra--);
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(9),
                  bottomLeft: Radius.circular(9),
                ),
              ),
              child: Center(
                child: Text(
                  '–',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: _jumlahMitra > 1 ? Colors.black87 : Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                '$_jumlahMitra Orang',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1565C0),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _jumlahMitra++),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(9),
                  bottomRight: Radius.circular(9),
                ),
              ),
              child: const Center(
                child: Text(
                  '+',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.black87),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openMapPicker() async {
    final r = await Navigator.push<MapPickerResult>(context,
      MaterialPageRoute(builder: (_) => const MapPickerScreen(title: 'Pilih Lokasi Kebersihan')));
    if (r != null) setState(() { _alamatController.text = r.address; _alamatLatLng = r.latLng; });
  }

  Widget _buildAlamatField() {
    return Column(
      children: [
        TextField(
          controller: _alamatController,
          maxLines: 3,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            hintText: 'Masukkan detail lengkap alamat lokasi',
            hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400, fontWeight: FontWeight.w400),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 16, right: 4, top: 14, bottom: 14),
            suffixIcon: IconButton(
              icon: const Icon(Icons.map_outlined, size: 20, color: Color(0xFF0288D1)),
              tooltip: 'Pilih di peta',
              onPressed: _openMapPicker,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.blue.shade100)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.blue.shade100)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF42A5F5), width: 1.5)),
          ),
        ),
        if (_alamatLatLng != null) ...[
          const SizedBox(height: 10),
          MiniRouteMapWidget(
            pointA: _alamatLatLng,
            labelA: 'Lokasi',
            onEditA: _openMapPicker,
            height: 170,
          ),
        ],
      ],
    );
  }

  void _onCariMitra() {
    if (_alamatController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Alamat lengkap harus diisi'),
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
            jenisLayanan: 'Kebersihan',
            kategori: _selectedJenis,
            deskripsi: '${_selectedKondisi} — ${_deskripsiController.text.trim()}',
            alamat: _alamatController.text.trim(),
            jumlahMitra: _jumlahMitra,
          ),
        ),
      ),
    );
  }
}
