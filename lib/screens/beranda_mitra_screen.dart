import 'package:flutter/material.dart';
import 'chat_mitra_screen.dart';

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
            nama: 'Wuli Silan',
            instansi: 'ITS – Teknologi Kedokteran',
            pesan: 'Mas, minta tolong angkut triplek dari Gebang ke FKK.',
            waktu: '2 menit lalu',
          ),
          _buildOrderCard(
            context: context,
            kategori: 'Jastip & Belanja',
            kategoriColor: const Color(0xFF6A1B9A),
            harga: 'Rp 20.000',
            nama: 'Ziyadatur R.',
            instansi: 'Umum',
            pesan: 'Lokasi: Razan Seafood, Pujas KTT\nList: Nasi Cumi Asam Manis (1)',
            waktu: '5 menit lalu',
          ),
          _buildOrderCard(
            context: context,
            kategori: 'Kebersihan',
            kategoriColor: const Color(0xFF2E7D32),
            harga: 'Rp 50.000',
            nama: 'Mahendra P.',
            instansi: 'ITS – Teknik Informatika',
            pesan: 'Mas, baru pindah kos, minta tolong sapu dan pel kamar kos.',
            waktu: '12 menit lalu',
          ),
          _buildOrderCard(
            context: context,
            kategori: 'Sosial & Lainnya',
            kategoriColor: const Color(0xFF00695C),
            harga: 'Rp 40.000',
            nama: 'Amalia F.',
            instansi: 'Unair – Fakultas Kedokteran',
            pesan: 'Mas, temenin saya antri dan war Dubai Chewy Cookie di TP.',
            waktu: '20 menit lalu',
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
    required String instansi,
    required String pesan,
    required String waktu,
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
          // Baris atas: badge kategori + harga + waktu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: kategoriColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: kategoriColor.withValues(alpha: 0.3)),
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
              Row(
                children: [
                  Text(
                    waktu,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade400),
                  ),
                  const SizedBox(width: 10),
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
            ],
          ),
          const SizedBox(height: 12),
          // Identitas customer
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(0xFFE3F2FD),
                child: Text(
                  nama[0].toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1565C0),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nama,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      instansi,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Detail pesan
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Text(
              pesan,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade700,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 14),
          // Tombol aksi
          Row(
            children: [
              // Tombol Lihat Detail
              Expanded(
                flex: 2,
                child: OutlinedButton(
                  onPressed: () => _showDetailOrder(context, nama, kategori, harga, pesan),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1565C0),
                    side: const BorderSide(color: Color(0xFF1565C0)),
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    'Lihat Detail',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              // Tombol Ambil Order
              Expanded(
                flex: 3,
                child: ElevatedButton.icon(
                  onPressed: () => _konfirmasiAmbilOrder(context, nama, kategori, harga),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD54F),
                    foregroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 16),
                  label: const Text(
                    'Ambil & Chat',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showDetailOrder(
    BuildContext context,
    String nama,
    String kategori,
    String harga,
    String pesan,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
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
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Detail Order',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 16),
            _detailRow(Icons.person_outline, 'Customer', nama),
            const SizedBox(height: 10),
            _detailRow(Icons.category_outlined, 'Kategori', kategori),
            const SizedBox(height: 10),
            _detailRow(Icons.payments_outlined, 'Tarif', harga),
            const SizedBox(height: 10),
            _detailRow(Icons.notes, 'Catatan', pesan),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _konfirmasiAmbilOrder(context, nama, kategori, harga);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD54F),
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Ambil Order Ini',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
                ),
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: const Color(0xFF1565C0)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }

  void _konfirmasiAmbilOrder(
    BuildContext context,
    String nama,
    String kategori,
    String harga,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.assignment_turned_in, color: Color(0xFF1565C0), size: 22),
            SizedBox(width: 8),
            Text(
              'Konfirmasi Ambil Order',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anda akan mengambil order dari:',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F7FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(nama,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w700, color: Colors.black87)),
                  const SizedBox(height: 4),
                  Text('$kategori  •  $harga',
                      style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Dengan mengambil order ini, Anda setuju untuk menyelesaikan jasa sesuai permintaan customer.',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade500, height: 1.4),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: Colors.grey.shade600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatMitraScreen(customerName: nama),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1565C0),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text('Ambil & Chat Sekarang',
                style: TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
