import 'package:flutter/material.dart';

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  final List<_NotifItem> _notifs = [
    _NotifItem(
      icon: Icons.check_circle_outline_rounded,
      iconColor: const Color(0xFF43A047),
      iconBg: const Color(0xFFE8F5E9),
      title: 'Pesanan Selesai',
      body: 'Jastip Mie Gacoan oleh Laksamana M. telah selesai. Yuk kasih ulasan!',
      waktu: '2 jam lalu',
      isRead: false,
    ),
    _NotifItem(
      icon: Icons.access_time_rounded,
      iconColor: const Color(0xFFFF9800),
      iconBg: const Color(0xFFFFF3E0),
      title: 'Mitra Sedang Dalam Perjalanan',
      body: 'Ghaly Rakha sedang menuju lokasi untuk layanan Bersih-bersih Kamar Kos kamu.',
      waktu: '5 jam lalu',
      isRead: false,
    ),
    _NotifItem(
      icon: Icons.payments_outlined,
      iconColor: const Color(0xFF0288D1),
      iconBg: const Color(0xFFE3F2FD),
      title: 'Pembayaran Berhasil',
      body: 'Pembayaran Rp 23.000 untuk Antar Jemput ke RS Siloam berhasil dikonfirmasi.',
      waktu: 'Kemarin, 14:30',
      isRead: true,
    ),
    _NotifItem(
      icon: Icons.person_add_outlined,
      iconColor: const Color(0xFF7E57C2),
      iconBg: const Color(0xFFEDE7F6),
      title: 'Mitra Menerima Pesanan',
      body: 'Ridho Ahmad menerima pesanan Antar Jemput kamu. Segera lakukan pembayaran!',
      waktu: 'Kemarin, 09:15',
      isRead: true,
    ),
    _NotifItem(
      icon: Icons.campaign_outlined,
      iconColor: const Color(0xFFEF5350),
      iconBg: const Color(0xFFFFEBEE),
      title: 'Promo Terbatas!',
      body: 'Gratis ongkos jasa untuk 3 pengguna pertama hari ini. Yuk gunakan sekarang!',
      waktu: '3 hari lalu',
      isRead: true,
    ),
    _NotifItem(
      icon: Icons.verified_user_outlined,
      iconColor: const Color(0xFF29B6F6),
      iconBg: const Color(0xFFE3F2FD),
      title: 'Akun Terverifikasi',
      body: 'Selamat! Identitas kamu telah berhasil diverifikasi. Kamu bisa menikmati semua fitur.',
      waktu: '1 minggu lalu',
      isRead: true,
    ),
  ];

  int get _unreadCount => _notifs.where((n) => !n.isRead).length;

  void _markAllRead() => setState(() {
        for (final n in _notifs) {
          n.isRead = true;
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FC),
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: _notifs.isEmpty
                ? _buildEmpty()
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _notifs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) => _buildNotifCard(_notifs[index], index),
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
              Expanded(
                child: Row(
                  children: [
                    const Text(
                      'Notifikasi',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                    ),
                    if (_unreadCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD54F),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$_unreadCount baru',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black87),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (_unreadCount > 0)
                TextButton(
                  onPressed: _markAllRead,
                  child: const Text('Tandai Baca', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotifCard(_NotifItem item, int index) {
    return GestureDetector(
      onTap: () => setState(() => item.isRead = true),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isRead ? Colors.white : const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: item.isRead ? Colors.grey.shade100 : Colors.blue.shade200,
          ),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(color: item.iconBg, borderRadius: BorderRadius.circular(12)),
              child: Icon(item.icon, color: item.iconColor, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (!item.isRead)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(color: Color(0xFF0288D1), shape: BoxShape.circle),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(item.body, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, height: 1.4)),
                  const SizedBox(height: 6),
                  Text(item.waktu, style: TextStyle(fontSize: 10, color: Colors.grey.shade400, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 64, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text('Tidak ada notifikasi', style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
        ],
      ),
    );
  }
}

class _NotifItem {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final String body;
  final String waktu;
  bool isRead;

  _NotifItem({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.body,
    required this.waktu,
    required this.isRead,
  });
}
