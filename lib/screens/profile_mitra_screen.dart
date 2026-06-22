import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pilih_role_screen.dart';
import 'edit_profile_screen.dart';
import 'keamanan_akun_screen.dart';
import 'notifikasi_screen.dart';

final supabase = Supabase.instance.client;

class ProfileMitraScreen extends StatefulWidget {
  const ProfileMitraScreen({super.key});

  @override
  State<ProfileMitraScreen> createState() => _ProfileMitraScreenState();
}

class _ProfileMitraScreenState extends State<ProfileMitraScreen> {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final email = supabase.auth.currentUser?.email;
      if (email == null) return;

      final data = await supabase
          .from('users')
          .select()
          .eq('email', email)
          .single();

      if (mounted) {
        setState(() {
          _userData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _logout(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari Akun'),
        content: const Text('Apakah Anda yakin ingin keluar?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Keluar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await supabase.auth.signOut();
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const PilihRoleScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final nama = _userData?['name'] ?? supabase.auth.currentUser?.email ?? 'Mitra';
    final email = _userData?['email'] ?? supabase.auth.currentUser?.email ?? '-';
    final phone = _userData?['phone'] ?? '-';
    final identityNumber = _userData?['identity_number'] ?? '-';
    final isVerified = _userData?['identity_photo_url'] != null;
    final department = _userData?['department'] ?? _userData?['jurusan'] ?? '-';
    final year = _userData?['year'] ?? _userData?['angkatan'] ?? '-';

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),
          _buildAvatar(nama),
          const SizedBox(height: 16),
          Text(
            nama,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 4),
          if (isVerified)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, size: 14, color: Color(0xFF4CAF50)),
                  SizedBox(width: 4),
                  Text(
                    'Mitra Terverifikasi',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24),
          _buildStatsRow(),
          const SizedBox(height: 24),
          _buildInformasiAkun(email, phone, identityNumber, department, year),
          const SizedBox(height: 20),
          _buildKeahlianSection(),
          const SizedBox(height: 20),
          _buildMenuSection(context),
          const SizedBox(height: 20),
          _buildLogoutButton(context),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildAvatar(String nama) {
    final initial = nama.isNotEmpty ? nama[0].toUpperCase() : 'M';
    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade200,
        border: Border.all(color: const Color(0xFFFFD54F), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initial,
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1565C0),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildStatItem('47', 'ORDER', Icons.assignment_turned_in_outlined),
            _buildDivider(),
            _buildStatItem('44', 'SELESAI', Icons.check_circle_outline),
            _buildDivider(),
            _buildStatItem('Rp 1.2jt', 'PENDAPATAN', Icons.account_balance_wallet_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF1565C0)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1565C0),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(width: 1, height: 40, color: Colors.grey.shade200);
  }

  Widget _buildInformasiAkun(
    String email,
    String phone,
    String identityNumber,
    String department,
    String year,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('INFORMASI AKUN'),
            const SizedBox(height: 16),
            _buildInfoRow(Icons.email_outlined, 'Email', email),
            const SizedBox(height: 14),
            _buildInfoRow(Icons.phone_android, 'WhatsApp', phone),
            const SizedBox(height: 14),
            _buildInfoRow(Icons.badge_outlined, 'NRP', identityNumber),
            const SizedBox(height: 14),
            _buildInfoRow(Icons.school_outlined, 'Departemen', department),
            const SizedBox(height: 14),
            _buildInfoRow(Icons.calendar_today_outlined, 'Angkatan', year),
          ],
        ),
      ),
    );
  }

  Widget _buildKeahlianSection() {
    final keahlian = [
      {'label': 'Antar Jemput', 'icon': Icons.motorcycle, 'color': const Color(0xFF1565C0)},
      {'label': 'Tenaga & Logistik', 'icon': Icons.local_shipping, 'color': const Color(0xFFE65100)},
      {'label': 'Kebersihan', 'icon': Icons.cleaning_services, 'color': const Color(0xFF2E7D32)},
      {'label': 'Jastip & Belanja', 'icon': Icons.shopping_bag, 'color': const Color(0xFF6A1B9A)},
      {'label': 'Perbaikan Ringan', 'icon': Icons.build, 'color': const Color(0xFFC62828)},
      {'label': 'Sosial & Lainnya', 'icon': Icons.people, 'color': const Color(0xFF00695C)},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('KEAHLIAN AKTIF'),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: keahlian.map((item) {
                final color = item['color'] as Color;
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: color.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(item['icon'] as IconData, size: 16, color: color),
                      const SizedBox(width: 6),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('MENU'),
            const SizedBox(height: 14),
            _buildMenuItem(
              Icons.history,
              'Riwayat Order',
              subtitle: 'Lihat semua order yang pernah dikerjakan',
              onTap: () => _showRiwayatOrder(context),
            ),
            _buildMenuItem(
              Icons.account_balance_wallet_outlined,
              'Penarikan Saldo',
              subtitle: 'Cairkan pendapatanmu ke rekening/e-wallet',
              onTap: () => _showPenarikanSaldo(context),
            ),
            _buildMenuItem(
              Icons.notifications_outlined,
              'Notifikasi',
              subtitle: 'Pengaturan dan riwayat notifikasi',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotifikasiScreen(),
                  ),
                );
              },
            ),
            _buildMenuItem(
              Icons.manage_accounts_outlined,
              'Pengaturan Akun',
              subtitle: 'Ubah profil, keamanan, dan preferensi',
              onTap: () => _showPengaturanAkun(context),
              showDivider: false,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String label, {
    required VoidCallback onTap,
    String subtitle = '',
    bool showDivider = true,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(icon, color: const Color(0xFF1565C0), size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (subtitle.isNotEmpty)
                        Text(
                          subtitle,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                        ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
              ],
            ),
          ),
        ),
        if (showDivider) Divider(height: 1, color: Colors.grey.shade100),
      ],
    );
  }

  void _showRiwayatOrder(BuildContext context) {
    final orders = [
      _RiwayatItem(
        nama: 'Wuli Silan',
        kategori: 'Tenaga & Logistik',
        harga: 'Rp 30.000',
        tanggal: '18 Jun 2026',
        status: 'Selesai',
        statusColor: const Color(0xFF2E7D32),
      ),
      _RiwayatItem(
        nama: 'Amalia F.',
        kategori: 'Sosial & Lainnya',
        harga: 'Rp 40.000',
        tanggal: '15 Jun 2026',
        status: 'Selesai',
        statusColor: const Color(0xFF2E7D32),
      ),
      _RiwayatItem(
        nama: 'Budi Santoso',
        kategori: 'Kebersihan',
        harga: 'Rp 50.000',
        tanggal: '10 Jun 2026',
        status: 'Dibatalkan',
        statusColor: const Color(0xFFC62828),
      ),
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.92,
        minChildSize: 0.4,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Icon(Icons.history, color: Color(0xFF1565C0), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Riwayat Order',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Total: ${orders.length} order',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: orders.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = orders[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.nama,
                                    style: const TextStyle(
                                        fontSize: 13, fontWeight: FontWeight.w700)),
                                const SizedBox(height: 2),
                                Text(item.kategori,
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.grey.shade500)),
                                const SizedBox(height: 2),
                                Text(item.tanggal,
                                    style: TextStyle(
                                        fontSize: 10, color: Colors.grey.shade400)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(item.harga,
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF1565C0))),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: item.statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(item.status,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: item.statusColor,
                                    )),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void _showPenarikanSaldo(BuildContext context) {
    final bankController = TextEditingController();
    final rekeningController = TextEditingController();
    final nominalController = TextEditingController();
    String selectedMetode = 'Bank Transfer';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: StatefulBuilder(
            builder: (context, setModalState) => Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40, height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Row(
                  children: [
                    Icon(Icons.account_balance_wallet, color: Color(0xFF1565C0), size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Penarikan Saldo',
                      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Saldo tersedia
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1565C0), Color(0xFF29B6F6)],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Saldo Tersedia',
                          style: TextStyle(fontSize: 11, color: Colors.white70)),
                      const SizedBox(height: 4),
                      const Text(
                        'Rp 1.200.000',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Min. penarikan Rp 50.000',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.white.withValues(alpha: 0.7))),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Metode
                const Text('Metode Pencairan',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Row(
                  children: ['Bank Transfer', 'GoPay', 'OVO', 'Dana'].map((m) {
                    final isSelected = selectedMetode == m;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setModalState(() => selectedMetode = m),
                        child: Container(
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF1565C0)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            m,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                if (selectedMetode == 'Bank Transfer') ...[
                  TextField(
                    controller: bankController,
                    decoration: _inputDecoration('Nama Bank (cth: BCA, BRI, Mandiri)'),
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: rekeningController,
                    keyboardType: TextInputType.number,
                    decoration: _inputDecoration('Nomor Rekening'),
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  TextField(
                    controller: rekeningController,
                    keyboardType: TextInputType.phone,
                    decoration: _inputDecoration('Nomor $selectedMetode'),
                    style: const TextStyle(fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                ],
                TextField(
                  controller: nominalController,
                  keyboardType: TextInputType.number,
                  decoration: _inputDecoration('Nominal Penarikan (Rp)'),
                  style: const TextStyle(fontSize: 13),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Permintaan penarikan berhasil dikirim!'),
                          backgroundColor: Color(0xFF2E7D32),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                      elevation: 0,
                    ),
                    child: const Text('Ajukan Penarikan',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showPengaturanAkun(BuildContext context) {
    showModalBottomSheet(
      context: context,
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
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Row(
              children: [
                Icon(Icons.manage_accounts, color: Color(0xFF1565C0), size: 20),
                SizedBox(width: 8),
                Text(
                  'Pengaturan Akun',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _pengaturanItem(
              icon: Icons.person_outline,
              label: 'Edit Profil',
              subtitle: 'Ubah nama, foto, dan data diri',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditProfileScreen(),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            _pengaturanItem(
              icon: Icons.lock_outline,
              label: 'Keamanan Akun',
              subtitle: 'Ganti password dan verifikasi',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KeamananAkunScreen(),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            _pengaturanItem(
              icon: Icons.workspace_premium_outlined,
              label: 'Keahlian & Layanan',
              subtitle: 'Kelola jenis jasa yang kamu tawarkan',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Fitur ini akan segera tersedia'),
                  ),
                );
              },
            ),
            const Divider(height: 1),
            _pengaturanItem(
              icon: Icons.help_outline,
              label: 'Bantuan & Dukungan',
              subtitle: 'Hubungi tim ITS Serabutan',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Menghubungkan ke dukungan...'),
                  ),
                );
              },
              showDivider: false,
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _pengaturanItem({
    required IconData icon,
    required String label,
    required String subtitle,
    required VoidCallback onTap,
    bool showDivider = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF1565C0), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
                  Text(subtitle,
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 22),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF29B6F6), width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      isDense: true,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _logout(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFCE4EC),
            foregroundColor: const Color(0xFFC62828),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          icon: const Icon(Icons.logout, size: 18),
          label: const Text(
            'Keluar dari Akun',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(width: 30, height: 1, color: Colors.grey.shade300),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Colors.grey.shade500,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: Container(height: 1, color: Colors.grey.shade300)),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFFE3F2FD),
            borderRadius: BorderRadius.circular(9),
          ),
          child: Icon(icon, color: const Color(0xFF1565C0), size: 18),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              const SizedBox(height: 1),
              Text(value,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87)),
            ],
          ),
        ),
      ],
    );
  }
}

class _RiwayatItem {
  final String nama;
  final String kategori;
  final String harga;
  final String tanggal;
  final String status;
  final Color statusColor;

  _RiwayatItem({
    required this.nama,
    required this.kategori,
    required this.harga,
    required this.tanggal,
    required this.status,
    required this.statusColor,
  });
}
