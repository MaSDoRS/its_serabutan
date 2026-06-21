import 'package:flutter/material.dart';

class AktivitasScreen extends StatefulWidget {
  const AktivitasScreen({super.key});

  @override
  State<AktivitasScreen> createState() => _AktivitasScreenState();
}

class _AktivitasScreenState extends State<AktivitasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Semua data aktivitas — dipisah per status ke tab-nya masing-masing
  static const _allActivities = [
    _ActivityItem(
      title: 'Teman Belajar Ilmu Data Medis',
      mitra: 'Mitra: Iqbols',
      date: '25 Mei 2026',
      price: 'Rp 25.000',
      status: 'Diproses',
      tab: 'proses',
      icon: Icons.school_outlined,
      avatarColor: Color(0xFFFFCC80),
    ),
    _ActivityItem(
      title: 'Antar Jemput ke RS Siloam',
      mitra: 'Mitra: Ridho A.',
      date: '22 Mei 2026',
      price: 'Rp 23.000',
      status: 'Selesai',
      tab: 'riwayat',
      icon: Icons.directions_car_outlined,
      avatarColor: Color(0xFF81D4FA),
    ),
    _ActivityItem(
      title: 'Bersih-bersih Kamar Kos',
      mitra: 'Mitra: Ghaly Rakha',
      date: '24 Mei 2026, 15.00 WIB',
      price: 'Rp 60.000',
      status: 'Terjadwal',
      tab: 'terjadwal',
      icon: Icons.cleaning_services_outlined,
      avatarColor: Color(0xFFA5D6A7),
    ),
    _ActivityItem(
      title: 'Jastip Mie Gacoan',
      mitra: 'Mitra: Laksamana M.',
      date: '18 Mei 2026',
      price: 'Rp 40.000',
      status: 'Selesai',
      tab: 'riwayat',
      icon: Icons.shopping_bag_outlined,
      avatarColor: Color(0xFFEF9A9A),
    ),
    _ActivityItem(
      title: 'Perbaikan Kipas Kamar',
      mitra: 'Mitra: Arya Duta',
      date: '26 Mei 2026',
      price: 'Rp 35.000',
      status: 'Diproses',
      tab: 'proses',
      icon: Icons.build_outlined,
      avatarColor: Color(0xFFCE93D8),
    ),
    _ActivityItem(
      title: 'Logistik Pindah Kos',
      mitra: 'Draft tersimpan',
      date: '-',
      price: 'Rp -',
      status: 'Draft',
      tab: 'draft',
      icon: Icons.inventory_2_outlined,
      avatarColor: Color(0xFFB0BEC5),
    ),
  ];

  List<_ActivityItem> _byTab(String tab) =>
      _allActivities.where((a) => a.tab == tab).toList();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: Column(
        children: [
          _buildAppBar(context),
          const SizedBox(height: 12),
          _buildTabBar(),
          const SizedBox(height: 8),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildList(_byTab('riwayat'), emptyMessage: 'Belum ada riwayat pesanan'),
                _buildList(_byTab('proses'), emptyMessage: 'Tidak ada pesanan yang sedang diproses'),
                _buildList(_byTab('terjadwal'), emptyMessage: 'Tidak ada pesanan terjadwal'),
                _buildList(_byTab('draft'), emptyMessage: 'Tidak ada draft tersimpan'),
              ],
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
                  'Aktivitas Saya',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: const Color(0xFF0288D1),
            borderRadius: BorderRadius.circular(12),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade500,
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          labelPadding: EdgeInsets.zero,
          dividerColor: Colors.transparent,
          tabs: [
            _buildTab('Riwayat', _byTab('riwayat').length),
            _buildTab('Proses', _byTab('proses').length),
            _buildTab('Terjadwal', _byTab('terjadwal').length),
            _buildTab('Draft', _byTab('draft').length),
          ],
        ),
      ),
    );
  }

  Tab _buildTab(String label, int count) {
    return Tab(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          if (count > 0) ...[
            const SizedBox(width: 4),
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$count',
                  style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildList(List<_ActivityItem> items, {required String emptyMessage}) {
    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text(emptyMessage, style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: items.length,
      itemBuilder: (context, index) => _buildCard(items[index]),
    );
  }

  Widget _buildCard(_ActivityItem item) {
    final statusColor = _statusColor(item.status);
    final actionLabel = _actionLabel(item.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: item.avatarColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.icon, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item.status,
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: statusColor),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  '${item.mitra}  ·  ${item.date}',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.price,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0288D1)),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF0288D1), width: 1.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          actionLabel,
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF0288D1)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Diproses': return const Color(0xFFFF9800);
      case 'Selesai': return const Color(0xFF4CAF50);
      case 'Terjadwal': return const Color(0xFF29B6F6);
      case 'Dibatalkan': return const Color(0xFFEF5350);
      case 'Draft': return Colors.grey;
      default: return Colors.grey;
    }
  }

  String _actionLabel(String status) {
    switch (status) {
      case 'Diproses': return 'Lacak';
      case 'Selesai': return 'Pesan Lagi';
      case 'Terjadwal': return 'Detail';
      case 'Draft': return 'Lanjutkan';
      default: return 'Detail';
    }
  }
}

class _ActivityItem {
  final String title;
  final String mitra;
  final String date;
  final String price;
  final String status;
  final String tab;
  final IconData icon;
  final Color avatarColor;

  const _ActivityItem({
    required this.title,
    required this.mitra,
    required this.date,
    required this.price,
    required this.status,
    required this.tab,
    required this.icon,
    required this.avatarColor,
  });
}
