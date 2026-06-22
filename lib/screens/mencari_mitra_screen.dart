import 'package:flutter/material.dart';
import 'chat_detail_screen.dart';

class MencariMitraScreen extends StatefulWidget {
  const MencariMitraScreen({super.key});

  @override
  State<MencariMitraScreen> createState() => _MencariMitraScreenState();
}

class _MencariMitraScreenState extends State<MencariMitraScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF29B6F6),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'PILIH MITRA',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 16,
              child: Icon(
                Icons.cleaning_services,
                size: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Container(),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Column(
        children: [
          // Order summary card (overflowing from appbar conceptually)
          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Motor',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Keputih ➔ RSUD',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                  const Text(
                    'Rp 15.000',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1565C0),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Searching status card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.blue.shade100),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.radar,
                  size: 32,
                  color: Colors.blue.shade300,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Mencari driver terdekat...',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Pesanan dikirim ke 12 driver aktif',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
                const SizedBox(height: 16),
                AnimatedBuilder(
                  animation: _progressController,
                  builder: (context, child) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _progressController.value,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF29B6F6),
                        ),
                        minHeight: 6,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Drivers responded label
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Driver Merespons (2)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Colors.blue.shade400,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          
          // List of responded drivers
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildDriverCard(context, 'Arya Duta'),
                _buildDriverCard(context, 'Budi Santoso'),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'Setelah memilih driver, kamu akan masuk ke room\nchat otomatis',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildDriverCard(BuildContext context, String nama) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 110,
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
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            nama[0],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nama,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '500m - Aktif',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Rp 35.000',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1565C0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Selesai 23x',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1565C0),
                          ),
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF29B6F6),
                          side: const BorderSide(color: Color(0xFF29B6F6)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size.zero,
                        ),
                        child: const Text(
                          'Tawar',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatDetailScreen(
                                mitraName: nama,
                                mitraInitial: nama[0],
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1565C0),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          minimumSize: Size.zero,
                          elevation: 0,
                        ),
                        child: const Text(
                          'Chat',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
