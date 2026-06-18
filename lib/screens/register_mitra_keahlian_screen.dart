import 'package:flutter/material.dart';
import 'login_mitra_screen.dart';

class RegisterMitraKeahlianScreen extends StatefulWidget {
  const RegisterMitraKeahlianScreen({super.key});

  @override
  State<RegisterMitraKeahlianScreen> createState() =>
      _RegisterMitraKeahlianScreenState();
}

class _RegisterMitraKeahlianScreenState
    extends State<RegisterMitraKeahlianScreen> {
  final Set<String> _selectedKeahlian = {};

  final List<_KeahlianItem> _keahlianList = [
    _KeahlianItem(
      title: 'Antar Jemput',
      description: 'Antar jemput, ojek keliling Surabaya!',
      icon: Icons.motorcycle,
      color: const Color(0xFF1565C0),
    ),
    _KeahlianItem(
      title: 'Tenaga & Logistik',
      description: 'Angkut barang pindahan, angkat batat beres, dsb.',
      icon: Icons.local_shipping,
      color: const Color(0xFFE65100),
    ),
    _KeahlianItem(
      title: 'Kebersihan',
      description:
          'Bersihih kamar kos, kontrakan, rumah, cuci kendaraan, dsb.',
      icon: Icons.cleaning_services,
      color: const Color(0xFF2E7D32),
    ),
    _KeahlianItem(
      title: 'Jastip & Belanja',
      description:
          'Beli makan di warung atau resto dan belanja kebutuhan sehari hari.',
      icon: Icons.shopping_bag,
      color: const Color(0xFF6A1B9A),
    ),
    _KeahlianItem(
      title: 'Perbaikan Ringan',
      description: 'Perbaikan dan perlengkapan ringan.',
      icon: Icons.build,
      color: const Color(0xFFC62828),
    ),
    _KeahlianItem(
      title: 'Sosial & Lainnya',
      description:
          'Teman makan, belajar, curhat, keliling kota. Perawatan hewan untuk peliharaan, penitipan hewan, dsb.',
      icon: Icons.people,
      color: const Color(0xFF00695C),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4FC3F7),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Daftar Sebagai Mitra',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    // Tab Masuk / Daftar
                    _buildTabSelector(),
                    const SizedBox(height: 28),
                    // Header text
                    const Text(
                      'Apa saja yang bisa kamu kerjakan?',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1565C0),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Kamu bisa pilih minimal 1 peran dan centang semua jika bisa melakukan apa saja!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // List keahlian
                    ...List.generate(_keahlianList.length, (index) {
                      final item = _keahlianList[index];
                      return _buildKeahlianCard(item);
                    }),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
          // Tombol Daftar (sticky bottom)
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedKeahlian.isEmpty
                    ? null
                    : () {
                        // TODO: Implementasi registrasi mitra
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Pendaftaran mitra akan segera tersedia'),
                            backgroundColor: Color(0xFF4CAF50),
                          ),
                        );
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD54F),
                  foregroundColor: Colors.black87,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade500,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: const Text(
                  'DAFTAR',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          // Tab Masuk
          Expanded(
            child: GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginMitraScreen(),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Masuk',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ),
          ),
          // Tab Daftar (aktif)
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: const Text(
                'Daftar',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeahlianCard(_KeahlianItem item) {
    final isSelected = _selectedKeahlian.contains(item.title);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedKeahlian.remove(item.title);
              } else {
                _selectedKeahlian.add(item.title);
              }
            });
          },
          borderRadius: BorderRadius.circular(14),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected
                  ? item.color.withValues(alpha: 0.06)
                  : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? item.color : Colors.grey.shade200,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: item.color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.icon,
                    color: item.color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                // Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: item.color,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.description,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                // Checkbox
                const SizedBox(width: 8),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? item.color : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: isSelected ? item.color : Colors.grey.shade400,
                      width: 2,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 16,
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _KeahlianItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  _KeahlianItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
