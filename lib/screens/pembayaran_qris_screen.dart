import 'dart:async';
import 'package:flutter/material.dart';
import 'pembayaran_berhasil_screen.dart';

class PembayaranQrisScreen extends StatefulWidget {
  final String totalHarga;
  final String jenisLayanan;

  const PembayaranQrisScreen({
    super.key,
    this.totalHarga = '00.000',
    this.jenisLayanan = '',
  });

  @override
  State<PembayaranQrisScreen> createState() => _PembayaranQrisScreenState();
}

class _PembayaranQrisScreenState extends State<PembayaranQrisScreen> {
  int _remainingSeconds = 15 * 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String get _minutes => (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
  String get _seconds => (_remainingSeconds % 60).toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _buildAppBar(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Countdown timer
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Selesaikan dalam ',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          ),
                          _buildTimerBox(_minutes[0]),
                          _buildTimerBox(_minutes[1]),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Text(':', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Color(0xFF1565C0))),
                          ),
                          _buildTimerBox(_seconds[0]),
                          _buildTimerBox(_seconds[1]),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // QRIS title
                  const Text(
                    'QRIS',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                      color: Colors.black87,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Merchant badge
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD54F),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Column(
                        children: [
                          Text(
                            'ITS SERABUTAN',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF0288D1),
                              letterSpacing: 0.5,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'NMID : ID10893888838',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0288D1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // QR code
                  Center(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.blue.shade100, width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/qrisitsserabutan.jpeg',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Total bar
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0288D1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('QRIS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
                            SizedBox(height: 2),
                            Text('TOTAL', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white70)),
                          ],
                        ),
                        Text(
                          'Rp ${widget.totalHarga}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Konfirmasi sudah bayar
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PembayaranBerhasilScreen(
                            metode: 'QRIS',
                            total: widget.totalHarga,
                            jenisLayanan: widget.jenisLayanan,
                          ),
                        ),
                        (route) => route.isFirst,
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFD54F),
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Saya Sudah Bayar',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, letterSpacing: 0.5),
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
                  'Pembayaran QRIS',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimerBox(String digit) {
    return Container(
      width: 24,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: const Color(0xFF29B6F6),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(digit, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white)),
      ),
    );
  }
}
