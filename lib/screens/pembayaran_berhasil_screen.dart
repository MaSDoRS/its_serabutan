import 'package:flutter/material.dart';
import 'beranda_screen.dart';

class PembayaranBerhasilScreen extends StatelessWidget {
  final String metode;
  final String total;
  final String jenisLayanan;

  const PembayaranBerhasilScreen({
    super.key,
    this.metode = 'CASH',
    this.total = '00.000',
    this.jenisLayanan = '',
  });

  String get _transactionId {
    final now = DateTime.now();
    return 'ITS${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.millisecondsSinceEpoch % 100000}';
  }

  String get _timestamp {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    return '${now.day} ${months[now.month - 1]} ${now.year}, $hour:$minute WIB';
  }

  @override
  Widget build(BuildContext context) {
    final txId = _transactionId;
    final ts = _timestamp;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  // Success icon
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF66BB6A).withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.check_circle_outline_rounded,
                      size: 60,
                      color: Color(0xFF43A047),
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Pembayaran Berhasil!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF43A047),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Transaksi kamu telah berhasil diproses',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
                  ),
                  const SizedBox(height: 32),

                  // Bukti pembayaran card
                  Container(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        Row(
                          children: [
                            const Text(
                              'BUKTI PEMBAYARAN',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1565C0),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(child: Container(height: 1.5, color: Colors.blue.shade100)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        if (jenisLayanan.isNotEmpty) ...[
                          _buildReceiptRow('Layanan', jenisLayanan),
                          const SizedBox(height: 14),
                        ],
                        _buildReceiptRow('Metode Pembayaran', metode),
                        const SizedBox(height: 14),
                        _buildReceiptRow('ID Transaksi', txId),
                        const SizedBox(height: 14),
                        _buildReceiptRow('Waktu', ts),
                        const SizedBox(height: 14),
                        _buildReceiptRow('Status', 'Berhasil', valueColor: const Color(0xFF43A047)),
                        const SizedBox(height: 20),

                        // Total
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE3F2FD),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'TOTAL DIBAYAR',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1565C0),
                                ),
                              ),
                              Text(
                                'Rp $total',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0288D1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  // Kembali ke Beranda
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const BerandaScreen()),
                        (route) => false,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0288D1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 2,
                        shadowColor: const Color(0xFF0288D1).withValues(alpha: 0.4),
                      ),
                      child: const Text(
                        'Kembali ke Beranda',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
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
                  'Bukti Pembayaran',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 130,
          child: Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: valueColor ?? Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
