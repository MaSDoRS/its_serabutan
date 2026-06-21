import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'order_jastip_osm_route_screen.dart';
import 'map_picker_screen.dart';
import '../models/order_data.dart';
import '../widgets/mini_route_map_widget.dart';

class OrderJastipScreen extends StatefulWidget {
  const OrderJastipScreen({super.key});

  @override
  State<OrderJastipScreen> createState() => _OrderJastipScreenState();
}

class _OrderJastipScreenState extends State<OrderJastipScreen> {
  String _selectedKategori = 'Makanan & Minuman';
  String? _selectedToko;
  final List<_BelanjItem> _items = [_BelanjItem()];
  final _catatanController = TextEditingController();
  final _alamatController = TextEditingController();
  final _tokoCustomController = TextEditingController();
  final _hargaJasaController = TextEditingController(text: '5.000');
  LatLng? _alamatLatLng;

  static const _tokoPerKategori = {
    'Makanan & Minuman': [
      _TokoSaran("McDonald's Keputih", LatLng(-7.2872, 112.8020)),
      _TokoSaran('Warteg ITS', LatLng(-7.2820, 112.7960)),
      _TokoSaran('Geprek Bensu', LatLng(-7.2850, 112.7990)),
      _TokoSaran('Mixue ITS', LatLng(-7.2860, 112.8010)),
      _TokoSaran('Warkop Sekitar ITS', LatLng(-7.2830, 112.7970)),
    ],
    'Alat Tulis': [
      _TokoSaran('Koperasi ITS', LatLng(-7.2818, 112.7957)),
      _TokoSaran('Togamas Rungkut', LatLng(-7.2760, 112.7910)),
      _TokoSaran('Gramedia Tunjungan', LatLng(-7.2574, 112.7382)),
      _TokoSaran('Toko ATK Sekitar ITS', LatLng(-7.2840, 112.7975)),
    ],
    'Kebutuhan Sehari-hari': [
      _TokoSaran('Indomaret Keputih', LatLng(-7.2890, 112.8040)),
      _TokoSaran('Alfamart ITS', LatLng(-7.2800, 112.7970)),
      _TokoSaran('Giant Maspion', LatLng(-7.2927, 112.7786)),
      _TokoSaran('Hypermart Pakuwon', LatLng(-7.2940, 112.6630)),
    ],
    'Obat-obatan': [
      _TokoSaran('Apotek K24 Keputih', LatLng(-7.2850, 112.7980)),
      _TokoSaran('Kimia Farma Sukolilo', LatLng(-7.2810, 112.7960)),
      _TokoSaran('Guardian Rungkut', LatLng(-7.2780, 112.8000)),
    ],
    'Lainnya': <_TokoSaran>[],
  };

  List<_TokoSaran> get _tokoSaranList =>
      _tokoPerKategori[_selectedKategori] ?? [];

  LatLng get _destinasiLatLng {
    if (_selectedToko != null) {
      final match = _tokoSaranList.where((t) => t.nama == _selectedToko);
      if (match.isNotEmpty) return match.first.latLng;
    }
    return const LatLng(-7.2794, 112.7973);
  }

  String get _namaDestinasi =>
      _selectedToko ??
      (_tokoCustomController.text.trim().isNotEmpty
          ? _tokoCustomController.text.trim()
          : 'Lokasi Toko');

  @override
  void dispose() {
    _catatanController.dispose();
    _alamatController.dispose();
    _tokoCustomController.dispose();
    _hargaJasaController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Kategori Belanja
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('KATEGORI BELANJA', Icons.category_outlined),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (_tokoPerKategori.keys.toList())
                              .map((k) => _buildChip(
                                    k,
                                    _selectedKategori == k,
                                    () => setState(() {
                                      _selectedKategori = k;
                                      _selectedToko = null;
                                    }),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Lokasi Toko
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('LOKASI TOKO / RESTO', Icons.store_outlined),
                        const SizedBox(height: 12),
                        if (_tokoSaranList.isNotEmpty) ...[
                          Text(
                            'Pilih tempat yang ingin dijasakan:',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _tokoSaranList
                                .map((t) => _buildChipToko(
                                      t.nama,
                                      _selectedToko == t.nama,
                                      () => setState(() => _selectedToko = t.nama),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 12),
                          const Row(children: [
                            Expanded(child: Divider()),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              child: Text('atau ketik sendiri',
                                  style: TextStyle(fontSize: 11, color: Colors.grey)),
                            ),
                            Expanded(child: Divider()),
                          ]),
                          const SizedBox(height: 10),
                        ],
                        TextField(
                          controller: _tokoCustomController,
                          style: const TextStyle(fontSize: 13),
                          decoration: _inputDecoration(
                            hint: 'Nama toko / alamat tempat beli...',
                            icon: Icons.location_on_outlined,
                          ),
                          onChanged: (_) => setState(() => _selectedToko = null),
                        ),
                        const SizedBox(height: 12),
                        // Tombol lihat rute di peta
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderJastipOsmRouteScreen(
                                destinasiLatLng: _destinasiLatLng,
                                namaDestinasi: _namaDestinasi,
                                orderData: _buildOrderData(),
                              ),
                            ),
                          ),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3F2FD),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.blue.shade200),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.map_outlined, size: 18, color: Color(0xFF0288D1)),
                                SizedBox(width: 8),
                                Text(
                                  'Lihat Rute di Peta',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF0288D1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Daftar Belanjaan
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('DAFTAR BELANJAAN', Icons.shopping_basket_outlined),
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
                                Icon(Icons.add, size: 16, color: Color(0xFF0288D1)),
                                SizedBox(width: 6),
                                Text(
                                  'Tambah Item',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0288D1),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Lokasi Pengantaran + Catatan
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('LOKASI PENGANTARAN', Icons.home_outlined),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _alamatController,
                          maxLines: 3,
                          style: const TextStyle(fontSize: 13),
                          decoration: _inputDecoration(hint: 'Alamat tujuan pengantaran kamu...').copyWith(
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.map_outlined, size: 18, color: Color(0xFF0288D1)),
                              tooltip: 'Pilih di peta',
                              onPressed: () async {
                                final r = await Navigator.push<MapPickerResult>(context,
                                  MaterialPageRoute(builder: (_) => const MapPickerScreen(title: 'Pilih Lokasi Pengantaran')));
                                if (r != null) setState(() { _alamatController.text = r.address; _alamatLatLng = r.latLng; });
                              },
                            ),
                          ),
                        ),
                        if (_alamatLatLng != null) ...[
                          const SizedBox(height: 8),
                          MiniRouteMapWidget(
                            pointA: _alamatLatLng,
                            labelA: 'Antarkan',
                            onEditA: () async {
                              final r = await Navigator.push<MapPickerResult>(context,
                                MaterialPageRoute(builder: (_) => const MapPickerScreen(title: 'Pilih Lokasi Pengantaran')));
                              if (r != null) setState(() { _alamatController.text = r.address; _alamatLatLng = r.latLng; });
                            },
                            height: 170,
                          ),
                        ],
                        const SizedBox(height: 14),
                        _buildSectionLabel('CATATAN TAMBAHAN', Icons.note_outlined),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _catatanController,
                          maxLines: 2,
                          style: const TextStyle(fontSize: 13),
                          decoration: _inputDecoration(
                              hint: 'Contoh: pilih yang fresh, jangan yang manis...'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Biaya Jasa
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionLabel('TAWARKAN BIAYA JASA', Icons.attach_money_outlined),
                        const SizedBox(height: 4),
                        Text(
                          'Biaya jasa di luar harga barang yang dibeli',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic),
                        ),
                        const SizedBox(height: 12),
                        _buildPriceInput(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),

                  // CTA
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        final hasItem = _items.any(
                            (i) => i.namaController.text.trim().isNotEmpty);
                        if (!hasItem) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Minimal isi 1 item belanjaan')),
                          );
                          return;
                        }
                        if (_alamatController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content:
                                    Text('Alamat pengantaran harus diisi')),
                          );
                          return;
                        }
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrderJastipOsmRouteScreen(
                              destinasiLatLng: _destinasiLatLng,
                              namaDestinasi: _namaDestinasi,
                              orderData: _buildOrderData(),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD54F),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('CARI PENYEDIA JASTIP',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w800)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, size: 20),
                        ],
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
          padding:
              const EdgeInsets.only(left: 8, right: 16, top: 8, bottom: 20),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.shopping_bag_outlined,
                  color: Colors.white, size: 22),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Jastip & Belanja',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionLabel(String text, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF0288D1)),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0288D1),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0288D1) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF0288D1) : Colors.blue.shade200,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : const Color(0xFF0288D1),
          ),
        ),
      ),
    );
  }

  Widget _buildChipToko(String label, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFFD54F) : const Color(0xFFF5F8FC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFFB300) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.place_outlined,
                size: 13,
                color: isSelected ? Colors.black87 : Colors.grey.shade500),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.black87 : Colors.grey.shade700,
              ),
            ),
          ],
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
                color: Color(0xFF0288D1), shape: BoxShape.circle),
            child: Center(
              child: Text('${index + 1}',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 3,
            child: TextField(
              controller: item.namaController,
              style: const TextStyle(fontSize: 13),
              decoration: _inputDecoration(hint: 'Nama barang...'),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 60,
            child: TextField(
              controller: item.jumlahController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13),
              decoration: _inputDecoration(hint: 'Jml'),
            ),
          ),
          if (_items.length > 1) ...[
            const SizedBox(width: 6),
            GestureDetector(
              onTap: () => setState(() {
                _items[index].dispose();
                _items.removeAt(index);
              }),
              child: const Icon(Icons.remove_circle_outline,
                  color: Colors.red, size: 22),
            ),
          ],
        ],
      ),
    );
  }

  InputDecoration _inputDecoration({String hint = '', IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
      prefixIcon: icon != null
          ? Icon(icon, size: 18, color: Colors.grey.shade400)
          : null,
      filled: true,
      fillColor: const Color(0xFFE3F2FD),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(9),
                bottomLeft: Radius.circular(9),
              ),
            ),
            child: const Text('Rp',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87)),
          ),
          Expanded(
            child: TextField(
              controller: _hargaJasaController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0288D1)),
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

// Helper method dipanggil dari state
extension _OrderHelper on _OrderJastipScreenState {
  OrderData _buildOrderData() {
    return OrderData(
      jenisLayanan: 'Jastip',
      kategori: _selectedKategori,
      namaLokasi: _namaDestinasi,
      items: _items
          .map((i) => '${i.namaController.text.trim()} (${i.jumlahController.text})')
          .where((s) => s.isNotEmpty && !s.startsWith(' '))
          .toList(),
      alamat: _alamatController.text.trim(),
      catatan: _catatanController.text.trim(),
      hargaJasa: _hargaJasaController.text.trim(),
    );
  }
}

class _TokoSaran {
  final String nama;
  final LatLng latLng;
  const _TokoSaran(this.nama, this.latLng);
}

class _BelanjItem {
  final namaController = TextEditingController();
  final jumlahController = TextEditingController(text: '1');

  void dispose() {
    namaController.dispose();
    jumlahController.dispose();
  }
}
