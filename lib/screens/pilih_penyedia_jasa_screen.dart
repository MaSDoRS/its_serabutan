import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';
import '../models/order_data.dart';

class PilihPenyediaJasaScreen extends StatelessWidget {
  final OrderData orderData;
  const PilihPenyediaJasaScreen({super.key, this.orderData = const OrderData()});

  static const List<Map<String, dynamic>> _penyediaList = [
    {
      'name': 'Yazid Alfarizy',
      'initial': 'Y',
      'services': ['Jastip & Belanja', 'Tenaga & Logistik'],
    },
    {
      'name': 'Mahmud Zulfa',
      'initial': 'M',
      'services': ['Tenaga & Logistik'],
    },
    {
      'name': 'Hanafiarsyah',
      'initial': 'H',
      'services': ['Jastip & Belanja', 'Tenaga & Logistik'],
    },
    {
      'name': 'Ridho Ahmad',
      'initial': 'R',
      'services': ['Jastip & Belanja'],
    },
  ];

  List<Map<String, dynamic>> _filteredPenyedia() {
    if (orderData.jenisLayanan.isEmpty) return _penyediaList;
    return _penyediaList.where((p) {
      final services = List<String>.from(p['services'] as List);
      return services.any((s) => s.contains(orderData.jenisLayanan));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredPenyedia();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      '${filtered.length} Penyedia Jasa Sedang Aktif',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF29B6F6),
                      ),
                    ),
                  ),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(
                        child: Text(
                          'Belum ada penyedia jasa tersedia\nuntuk layanan ini.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                      ),
                    ),
                  ...filtered.map(
                    (penyedia) => _buildMitraCard(
                      context,
                      name: penyedia['name'] as String,
                      initial: penyedia['initial'] as String,
                      services: List<String>.from(penyedia['services'] as List),
                    ),
                  ),
                ],
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
                  'Penyedia Jasa Tersedia',
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

  Widget _buildMitraCard(
    BuildContext context, {
    required String name,
    required String initial,
    required List<String> services,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 160,
            decoration: const BoxDecoration(
              color: Color(0xFFFFD54F),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 18, 18, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: const BoxDecoration(
                          color: Color(0xFF29B6F6),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            initial,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: services.map((s) => _buildServiceTag(s)).toList(),
                  ),
                  const SizedBox(height: 14),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatDetailScreen(
                            mitraName: name,
                            mitraInitial: initial,
                            orderData: orderData,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1565C0),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Chat',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF29B6F6), width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: Color(0xFF0288D1),
        ),
      ),
    );
  }
}
