import 'package:flutter/material.dart';
import 'pembayaran_screen.dart';

class BerandaMitraScreen extends StatelessWidget {
  const BerandaMitraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          _buildOrderCard(
            context: context,
            kategori: 'Tenaga & Logistik',
            kategoriColor: const Color(0xFFE65100),
            harga: 'Rp 30.000',
            nama: 'Wuli Silan (ITS, Teknologi Kedokteran)',
            pesan:
                '"Mas, minta tolong untuk angkut triplek dari Gebang ke FKK"',
          ),
          _buildOrderCard(
            context: context,
            kategori: 'Jastip & Belanja',
            kategoriColor: const Color(0xFF6A1B9A),
            harga: 'Rp 20.000',
            nama: 'Ziyadatur (Umum)',
            pesan:
                'Lokasi : Razan Seafood, Pujas KTT\nList Makanan : - Nasi Cumi Asam Manis (1)',
          ),
          _buildOrderCard(
            context: context,
            kategori: 'Kebersihan',
            kategoriColor: const Color(0xFF2E7D32),
            harga: 'Rp 50.000',
            nama: 'Mahendra (ITS, Teknik Informatika)',
            pesan:
                '"Mas, saya baru pindah kos minta tolong untuk sapu dan pel kamar kosnya ya"',
          ),
          _buildOrderCard(
            context: context,
            kategori: 'Sosial & Lainnya',
            kategoriColor: const Color(0xFF00695C),
            harga: 'Rp 40.000',
            nama: 'Amalia (Unair, FK)',
            pesan:
                '"Mas,temenin saya antri dan war dubai chewy cookie di TP"',
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard({
    required BuildContext context,
    required String kategori,
    required Color kategoriColor,
    required String harga,
    required String nama,
    required String pesan,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: kategori badge + harga
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: kategoriColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: kategoriColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  kategori,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: kategoriColor,
                  ),
                ),
              ),
              Text(
                harga,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1565C0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Nama
          Text(
            nama,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 6),
          // Pesan
          Text(
            pesan,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),
          // Tombol AMBIL ORDER
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PembayaranScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFD54F),
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
              ),
              child: const Text(
                'AMBIL ORDER JASA & CHAT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
