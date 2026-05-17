import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 12),
              _buildAppHeader(),
              const SizedBox(height: 8),
              _buildTabBar(),
              const Divider(height: 1),
              Expanded(
                child: TabBarView(
                  children: [
                    _UserHomeTab(),
                    _MitraHomeTab(),
                    _CategoryDetailTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'ITS Serabutan Mockup',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0C447C),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.phone_iphone,
              color: Colors.white,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return const TabBar(
      labelColor: Color(0xFF0C447C),
      unselectedLabelColor: Color(0xFF7E9FB8),
      indicatorColor: Color(0xFF0C447C),
      tabs: [
        Tab(text: 'Pengguna'),
        Tab(text: 'Mitra'),
        Tab(text: 'Detail'),
      ],
    );
  }
}

class _UserHomeTab extends StatelessWidget {
  const _UserHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F8FD),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildStatusBar(),
                  _buildUserHeader(),
                  _buildSearchBox(),
                  _buildCategorySection(),
                  _buildActiveOrderCard(),
                ],
              ),
            ),
          ),
          _buildBottomNav(isActiveHome: true),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF185FA5),
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Icon(Icons.wifi, size: 14, color: Color(0xFF185FA5)),
              SizedBox(width: 4),
              Icon(Icons.battery_full, size: 14, color: Color(0xFF185FA5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF042C53),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Selamat datang,',
                      style: TextStyle(fontSize: 11, color: Color(0xFF85B7EB)),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Salsabila A.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE6F1FB),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0C447C),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Icon(
                          Icons.notifications,
                          color: Color(0xFF85B7EB),
                          size: 15,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF09595),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: const Color(0xFF042C53),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF185FA5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        'SA',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFE6F1FB),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF0C447C),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Butuh bantuan hari ini?',
                  style: TextStyle(fontSize: 11, color: Color(0xFF85B7EB)),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Minta jasa sekarang',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFE6F1FB),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF185FA5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(Icons.add, color: Color(0xFFB5D4F4), size: 13),
                      SizedBox(width: 6),
                      Text(
                        'Buat pesanan baru',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFE6F1FB),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBox() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFE),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB5D4F4)),
      ),
      child: Row(
        children: const [
          Icon(Icons.search, size: 14, color: Color(0xFF85B7EB)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Cari jasa, misal: antar jemput...',
              style: TextStyle(fontSize: 11, color: Color(0xFF85B7EB)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Kategori jasa',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF042C53),
                ),
              ),
              Text(
                'Lihat semua',
                style: TextStyle(fontSize: 11, color: Color(0xFF378ADD)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            crossAxisSpacing: 7,
            mainAxisSpacing: 7,
            childAspectRatio: 0.82,
            children: const [
              _CategoryCard(icon: Icons.motorcycle, label: 'Antar-Jemput'),
              _CategoryCard(
                icon: Icons.shopping_bag,
                label: 'Jastip & Belanja',
              ),
              _CategoryCard(
                icon: Icons.local_shipping,
                label: 'Tenaga & Logistik',
              ),
              _CategoryCard(
                icon: Icons.cleaning_services,
                label: 'Pembersihan',
              ),
              _CategoryCard(icon: Icons.build, label: 'Perbaikan Ringan'),
              _CategoryCard(icon: Icons.more_horiz, label: 'Lainnya'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrderCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 0, 18, 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6F1FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB5D4F4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Antar jemput ke Keputih',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF042C53),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Mitra: Ghaly R.',
                      style: TextStyle(fontSize: 10, color: Color(0xFF185FA5)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF0C447C),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 5,
                      height: 5,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Color(0xFF85B7EB),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    SizedBox(width: 3),
                    Text(
                      'Dikerjakan',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE6F1FB),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C447C),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C447C),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB5D4F4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Sedang dikerjakan',
                style: TextStyle(fontSize: 10, color: Color(0xFF185FA5)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav({required bool isActiveHome}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE6F1FB))),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Beranda', active: true),
          _buildNavItem(Icons.list, 'Pesanan'),
          _buildNavItem(Icons.message, 'Chat', badge: true),
          _buildNavItem(Icons.person, 'Profil'),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    IconData icon,
    String label, {
    bool active = false,
    bool badge = false,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                size: 19,
                color: active
                    ? const Color(0xFF0C447C)
                    : const Color(0xFF85B7EB),
              ),
              if (badge)
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF09595),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: active ? const Color(0xFF0C447C) : const Color(0xFF85B7EB),
            ),
          ),
        ],
      ),
    );
  }
}

class _MitraHomeTab extends StatelessWidget {
  const _MitraHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F8FD),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildStatusBar(),
                  _buildMitraHeader(),
                  _buildAvailableOrders(),
                ],
              ),
            ),
          ),
          _buildBottomNav(isActiveHome: false),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF185FA5),
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Icon(Icons.wifi, size: 14, color: Color(0xFF185FA5)),
              SizedBox(width: 4),
              Icon(Icons.battery_full, size: 14, color: Color(0xFF185FA5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMitraHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF042C53),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Mode mitra aktif',
                    style: TextStyle(fontSize: 11, color: Color(0xFF85B7EB)),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Ghaly Rakha',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE6F1FB),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0C447C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    child: Row(
                      children: const [
                        SizedBox(
                          width: 6,
                          height: 6,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: Color(0xFF85B7EB),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Online',
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xFFB5D4F4),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: const Color(0xFF185FA5),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Center(
                      child: Text(
                        'GR',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFE6F1FB),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildMitraStatCard('Rp48k', 'Hari ini')),
              const SizedBox(width: 7),
              Expanded(
                child: _buildMitraStatCard('4.8', 'Rating', icon: Icons.star),
              ),
              const SizedBox(width: 7),
              Expanded(child: _buildMitraStatCard('12', 'Selesai')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMitraStatCard(String value, String label, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF0C447C),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE6F1FB),
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 4),
                Icon(icon, size: 10, color: const Color(0xFFB5D4F4)),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Color(0xFF85B7EB)),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableOrders() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 16, 18, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Pesanan tersedia',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF042C53),
                ),
              ),
              Text(
                '3 baru',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF0C447C),
                  fontWeight: FontWeight.w500,
                  backgroundColor: Color(0xFFE6F1FB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildMitraOrderCard(
            Icons.motorcycle,
            'Antar jemput ke Mulyos',
            'Sekarang',
            'Keputih',
            'Rp 8k',
          ),
          const SizedBox(height: 8),
          _buildMitraOrderCard(
            Icons.shopping_bag,
            'Jastip mie gacoan',
            '30 menit',
            'Jastip',
            'Rp 12k',
          ),
        ],
      ),
    );
  }

  Widget _buildMitraOrderCard(
    IconData icon,
    String title,
    String time,
    String label,
    String price,
  ) {
    return Container(
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB5D4F4)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F1FB),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, size: 14, color: const Color(0xFF0C447C)),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF042C53),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 10,
                          color: Color(0xFF185FA5),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          time,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF185FA5),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '• $label',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF185FA5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0C447C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFB5D4F4)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Ajukan harga lain',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10, color: Color(0xFF185FA5)),
                  ),
                ),
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0C447C),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Terima budget',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFE6F1FB),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav({required bool isActiveHome}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE6F1FB))),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Beranda', active: true),
          _buildNavItem(Icons.list_alt, 'Pesanan'),
          _buildNavItem(Icons.bar_chart, 'Penghasilan'),
          _buildNavItem(Icons.person, 'Profil'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool active = false}) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 19,
            color: active ? const Color(0xFF0C447C) : const Color(0xFF85B7EB),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: active ? const Color(0xFF0C447C) : const Color(0xFF85B7EB),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryDetailTab extends StatelessWidget {
  const _CategoryDetailTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF4F8FD),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildStatusBar(),
                  _buildDetailHeader(),
                  _buildFilterChips(),
                  _buildMitraList(),
                  _buildActionButton(),
                ],
              ),
            ),
          ),
          _buildBottomNav(),
        ],
      ),
    );
  }

  Widget _buildStatusBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Text(
            '9:41',
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF185FA5),
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Icon(Icons.wifi, size: 14, color: Color(0xFF185FA5)),
              SizedBox(width: 4),
              Icon(Icons.battery_full, size: 14, color: Color(0xFF185FA5)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
      decoration: BoxDecoration(
        color: const Color(0xFF042C53),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.arrow_back, size: 18, color: Color(0xFF85B7EB)),
              const SizedBox(width: 8),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: const Color(0xFF0C447C),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Icon(
                  Icons.motorcycle,
                  size: 13,
                  color: Color(0xFFB5D4F4),
                ),
              ),
              const SizedBox(width: 7),
              const Text(
                'Antar-Jemput',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE6F1FB),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: const Color(0xFF0C447C),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Tarif referensi wilayah',
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF85B7EB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'ab. Rp 8k',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE6F1FB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Mulyos / Keputih / Gebang',
                      style: TextStyle(fontSize: 11, color: Color(0xFFB5D4F4)),
                    ),
                    Text(
                      'ab. Rp 8k',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE6F1FB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Unair / Gubeng',
                      style: TextStyle(fontSize: 11, color: Color(0xFFB5D4F4)),
                    ),
                    Text(
                      'ab. Rp 15k',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE6F1FB),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Surabaya Barat',
                      style: TextStyle(fontSize: 11, color: Color(0xFFB5D4F4)),
                    ),
                    Text(
                      'ab. Rp 25k',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFFE6F1FB),
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

  Widget _buildFilterChips() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip('Semua mitra', selected: true),
            const SizedBox(width: 6),
            _buildFilterChip('Rating tinggi'),
            const SizedBox(width: 6),
            _buildFilterChip('Online sekarang'),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF0C447C) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB5D4F4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          color: selected ? const Color(0xFFE6F1FB) : const Color(0xFF185FA5),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMitraList() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      child: Column(
        children: [
          _buildMitraCard(
            'GR',
            'Ghaly Rakha',
            '4.9 (24)',
            'Antar-Jemput • Jastip • 12 selesai',
          ),
          const SizedBox(height: 7),
          _buildMitraCard(
            'AM',
            'Arya Muhammad',
            '4.7 (18)',
            'Antar-Jemput • Tenaga • 9 selesai',
          ),
        ],
      ),
    );
  }

  Widget _buildMitraCard(
    String initials,
    String name,
    String rating,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFB5D4F4)),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFF0C447C),
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                initials,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFE6F1FB),
                ),
              ),
            ),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF042C53),
                      ),
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 10,
                          color: Color(0xFFBA7517),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          rating,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xFF185FA5),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 10,
                    color: Color(0xFF185FA5),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Container(
      margin: const EdgeInsets.fromLTRB(18, 10, 18, 18),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF0C447C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          'Buat pesanan antar-jemput',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFFE6F1FB),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 9),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE6F1FB))),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, 'Beranda', active: true),
          _buildNavItem(Icons.list, 'Pesanan'),
          _buildNavItem(Icons.message, 'Chat'),
          _buildNavItem(Icons.person, 'Profil'),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, {bool active = false}) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 19,
            color: active ? const Color(0xFF0C447C) : const Color(0xFF85B7EB),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: active ? const Color(0xFF0C447C) : const Color(0xFF85B7EB),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CategoryCard({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(11),
        border: Border.all(color: const Color(0xFFB5D4F4)),
      ),
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFE6F1FB),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(icon, size: 16, color: const Color(0xFF0C447C)),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Color(0xFF042C53),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
