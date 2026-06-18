import 'package:flutter/material.dart';
import 'order_antar_jemput_screen.dart';
import 'order_kebersihan_screen.dart';
import 'order_sosial_screen.dart';
import 'order_logistik_screen.dart';
import 'order_perbaikan_screen.dart';
import 'order_jastip_screen.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 16),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildServiceGrid(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF29B6F6), Color(0xFF03A9F4), Color(0xFF0288D1)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'ITS ',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: 'SERABUTAN',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFFFD54F),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Kerja Apa Aja yang Bisa Dikerjain di Sekitar ITS!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(Icons.pets, size: 36, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.15),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Cari jasa apa hari ini?',
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: Color(0xFF42A5F5),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceGrid(BuildContext context) {
    final services = [
      _ServiceItem(
        icon: Icons.motorcycle,
        label: 'Antar Jemput',
        color: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1565C0),
      ),
      _ServiceItem(
        icon: Icons.local_shipping,
        label: 'Tenaga & Logistik',
        color: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFE65100),
      ),
      _ServiceItem(
        icon: Icons.cleaning_services,
        label: 'Kebersihan',
        color: const Color(0xFFE8F5E9),
        iconColor: const Color(0xFF2E7D32),
      ),
      _ServiceItem(
        icon: Icons.shopping_bag,
        label: 'Jastip & Belanja',
        color: const Color(0xFFF3E5F5),
        iconColor: const Color(0xFF6A1B9A),
      ),
      _ServiceItem(
        icon: Icons.build,
        label: 'Perbaikan Ringan',
        color: const Color(0xFFFCE4EC),
        iconColor: const Color(0xFFC62828),
      ),
      _ServiceItem(
        icon: Icons.people,
        label: 'Sosial & Lainnya',
        color: const Color(0xFFE0F7FA),
        iconColor: const Color(0xFF00695C),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) =>
            _buildServiceCard(context, services[index]),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, _ServiceItem service) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Widget? screen;
          switch (service.label) {
            case 'Antar Jemput':
              screen = const OrderAntarJemputScreen();
              break;
            case 'Tenaga & Logistik':
              screen = const OrderLogistikScreen();
              break;
            case 'Kebersihan':
              screen = const OrderKebersihanScreen();
              break;
            case 'Jastip & Belanja':
              screen = const OrderJastipScreen();
              break;
            case 'Perbaikan Ringan':
              screen = const OrderPerbaikanScreen();
              break;
            case 'Sosial & Lainnya':
              screen = const OrderSosialScreen();
              break;
          }
          if (screen != null) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => screen!));
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: service.color,
                  shape: BoxShape.circle,
                ),
                child: Icon(service.icon, size: 30, color: service.iconColor),
              ),
              const SizedBox(height: 10),
              Text(
                service.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String label;
  final Color color;
  final Color iconColor;
  _ServiceItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.iconColor,
  });
}
