import 'package:flutter/material.dart';

class AktivitasScreen extends StatefulWidget {
  const AktivitasScreen({super.key});

  @override
  State<AktivitasScreen> createState() => _AktivitasScreenState();
}

class _AktivitasScreenState extends State<AktivitasScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF48FB1),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Aktivitas Saya',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implementasi search
            },
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
      body: Column(
        children: [
          const SizedBox(height: 12),
          // Tab bar
          _buildTabBar(),
          const SizedBox(height: 8),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildRiwayatList(),
                _buildEmptyState('Tidak ada proses aktif'),
                _buildEmptyState('Tidak ada aktivitas terjadwal'),
                _buildEmptyState('Tidak ada draft'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: const Color(0xFF29B6F6),
            borderRadius: BorderRadius.circular(12),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade500,
          labelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'Riwayat'),
            Tab(text: 'Proses'),
            Tab(text: 'Terjadwal'),
            Tab(text: 'Draft'),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatList() {
    final activities = [
      _ActivityItem(
        title: 'Teman Belajar Ilmu Data Medis',
        mitra: 'Mitra: Iqbols - 25 Mei 2026',
        price: 'Rp 25.000',
        status: 'Diproses',
        statusColor: const Color(0xFFFF9800),
        actionLabel: 'Lacak',
        actionColor: const Color(0xFF2196F3),
        avatarColor: const Color(0xFFFFCC80),
      ),
      _ActivityItem(
        title: 'Antar Jemput ke RS Siloam',
        mitra: 'Mitra: Ridho A. - 22 Mei 2026',
        price: 'Rp 23.000',
        status: 'Selesai',
        statusColor: const Color(0xFF4CAF50),
        actionLabel: 'Pesan Lagi',
        actionColor: const Color(0xFF2196F3),
        avatarColor: const Color(0xFF81D4FA),
      ),
      _ActivityItem(
        title: 'Bersih-bersih Kamar Kos',
        mitra: 'Jadwal: 24 Mei 2026 - 15.00 WIB',
        price: 'Rp 60.000',
        status: 'Terjadwal',
        statusColor: const Color(0xFF29B6F6),
        actionLabel: 'Detail',
        actionColor: const Color(0xFF2196F3),
        avatarColor: const Color(0xFFA5D6A7),
      ),
      _ActivityItem(
        title: 'Jastip Mie Gacoan',
        mitra: 'Mitra: Laksamana M. - 18 Mei 2026',
        price: 'Rp 40.000',
        status: 'Selesai',
        statusColor: const Color(0xFF4CAF50),
        actionLabel: 'Pesan Lagi',
        actionColor: const Color(0xFF2196F3),
        avatarColor: const Color(0xFFEF9A9A),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        return _buildActivityCard(activities[index]);
      },
    );
  }

  Widget _buildActivityCard(_ActivityItem activity) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: activity.avatarColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.work_outline,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Status badge
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: activity.statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        activity.status,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: activity.statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Mitra info
                Text(
                  activity.mitra,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 8),
                // Price + Action button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      activity.price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1565C0),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: activity.actionColor,
                          width: 1.2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        activity.actionLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: activity.actionColor,
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

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: 2,
        onTap: (index) {
          if (index != 2) {
            Navigator.pop(context);
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF29B6F6),
        unselectedItemColor: Colors.grey.shade400,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _ActivityItem {
  final String title;
  final String mitra;
  final String price;
  final String status;
  final Color statusColor;
  final String actionLabel;
  final Color actionColor;
  final Color avatarColor;

  _ActivityItem({
    required this.title,
    required this.mitra,
    required this.price,
    required this.status,
    required this.statusColor,
    required this.actionLabel,
    required this.actionColor,
    required this.avatarColor,
  });
}
