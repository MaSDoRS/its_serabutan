import 'package:flutter/material.dart';

class UlasanScreen extends StatefulWidget {
  const UlasanScreen({super.key});

  @override
  State<UlasanScreen> createState() => _UlasanScreenState();
}

class _UlasanScreenState extends State<UlasanScreen> {
  final List<_ReviewItem> _reviews = [
    _ReviewItem(
      mitraName: 'Ridho Ahmad',
      mitraInitial: 'R',
      layanan: 'Antar Jemput ke RS Siloam',
      tanggal: '22 Mei 2026',
      komentar: 'Mitra sangat ramah, tepat waktu, dan perjalanan nyaman. Recommended banget!',
      avatarColor: const Color(0xFF81D4FA),
    ),
    _ReviewItem(
      mitraName: 'Laksamana M.',
      mitraInitial: 'L',
      layanan: 'Jastip Mie Gacoan',
      tanggal: '18 Mei 2026',
      komentar: 'Pesanan lengkap dan cepat. Hanya sedikit telat dari estimasi tapi overall oke.',
      avatarColor: const Color(0xFFEF9A9A),
    ),
  ];

  final List<_PendingItem> _pending = [
    _PendingItem(
      layanan: 'Perbaikan Kipas Kamar',
      mitraName: 'Arya Duta',
      mitraInitial: 'A',
      tanggal: '20 Mei 2026',
      avatarColor: const Color(0xFF80CBC4),
    ),
  ];

  void _submitUlasan(_PendingItem item, String komentar) {
    if (komentar.trim().isEmpty) return;
    setState(() {
      _pending.remove(item);
      _reviews.insert(0, _ReviewItem(
        mitraName: item.mitraName,
        mitraInitial: item.mitraInitial,
        layanan: item.layanan,
        tanggal: item.tanggal,
        komentar: komentar.trim(),
        avatarColor: item.avatarColor,
      ));
    });
  }

  void _showUlasanSheet(_PendingItem item) {
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Ulas ${item.layanan}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(item.mitraName, style: TextStyle(fontSize: 13, color: Colors.grey.shade500)),
              const SizedBox(height: 20),
              TextField(
                controller: commentController,
                maxLines: 4,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Bagaimana pengalamanmu dengan mitra ini?',
                  hintStyle: TextStyle(fontSize: 13, color: Colors.grey.shade400),
                  filled: true,
                  fillColor: const Color(0xFFE3F2FD),
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final teks = commentController.text.trim();
                    if (teks.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tulis ulasan dulu ya!')),
                      );
                      return;
                    }
                    Navigator.pop(ctx);
                    _submitUlasan(item, teks);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ulasan berhasil dikirim!'),
                        backgroundColor: Color(0xFF43A047),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0288D1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 0,
                  ),
                  child: const Text('Kirim Ulasan', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
                  if (_pending.isNotEmpty) ...[
                    _buildSectionLabel('BELUM DIULAS'),
                    const SizedBox(height: 10),
                    ..._pending.map((p) => _buildPendingCard(p)),
                    const SizedBox(height: 20),
                  ],
                  _buildSectionLabel('ULASAN SAYA'),
                  const SizedBox(height: 10),
                  if (_reviews.isEmpty)
                    _buildEmpty()
                  else
                    ..._reviews.map((r) => _buildReviewCard(r)),
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
                  'Ulasan Saya',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Color(0xFF0288D1), letterSpacing: 0.5),
    );
  }

  Widget _buildPendingCard(_PendingItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFD54F), width: 1.5),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(color: item.avatarColor, shape: BoxShape.circle),
            child: Center(
              child: Text(item.mitraInitial,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.layanan,
                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
                const SizedBox(height: 2),
                Text('${item.mitraName}  ·  ${item.tanggal}',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => _showUlasanSheet(item),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text('Ulas', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Colors.black87)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(_ReviewItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40, height: 40,
                decoration: BoxDecoration(color: item.avatarColor, shape: BoxShape.circle),
                child: Center(
                  child: Text(item.mitraInitial,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.mitraName,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.black87)),
                    Text(item.layanan, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Text(item.tanggal, style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F8FC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '"${item.komentar}"',
              style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.5, fontStyle: FontStyle.italic),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          children: [
            Icon(Icons.chat_bubble_outline_rounded, size: 64, color: Colors.grey.shade300),
            const SizedBox(height: 12),
            Text('Belum ada ulasan', style: TextStyle(fontSize: 14, color: Colors.grey.shade400)),
          ],
        ),
      ),
    );
  }
}

class _ReviewItem {
  final String mitraName;
  final String mitraInitial;
  final String layanan;
  final String tanggal;
  final String komentar;
  final Color avatarColor;

  _ReviewItem({
    required this.mitraName,
    required this.mitraInitial,
    required this.layanan,
    required this.tanggal,
    required this.komentar,
    required this.avatarColor,
  });
}

class _PendingItem {
  final String layanan;
  final String mitraName;
  final String mitraInitial;
  final String tanggal;
  final Color avatarColor;

  _PendingItem({
    required this.layanan,
    required this.mitraName,
    required this.mitraInitial,
    required this.tanggal,
    required this.avatarColor,
  });
}
