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
      backgroundColor: const Color(0xFFF5F5F5), // Light background to make cards pop
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
      padding: const EdgeInsets.fromLTRB(24, 28, 20, 32),
      decoration: const BoxDecoration(
        color: Color(0xFF1572BD), // Solid blue background
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  const TextSpan(
                    children: [
                      TextSpan(
                        text: 'ITS ',
                        style: TextStyle(color: Colors.white),
                      ),
                      TextSpan(
                        text: 'SERABUTAN',
                        style: TextStyle(color: Color(0xFFFFD54F)),
                      ),
                    ],
                  ),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Kerja Apa Aja yang Bisa Dikerjain di Sekitar ITS!',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ClipOval(
            child: Transform.scale(
              scale: 1.4,
              child: Image.asset(
                'assets/images/mascot.jpg',
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
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
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Cari jasa apa hari ini? kami siap bantu dengan sepenuh hati!',
            hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400, fontWeight: FontWeight.w400),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 12, right: 8),
              child: Icon(Icons.search, color: Colors.grey.shade400, size: 22),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: 40,
              minHeight: 40,
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Color(0xFF1572BD),
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
        imagePath: 'assets/images/antar_jemput.png',
        label: 'Antar Jemput',
      ),
      _ServiceItem(
        imagePath: 'assets/images/tenaga_logistik.png',
        label: 'Tenaga & Logistik',
      ),
      _ServiceItem(
        imagePath: 'assets/images/kebersihan.png',
        label: 'Kebersihan',
      ),
      _ServiceItem(
        imagePath: 'assets/images/jastip_belanja.png',
        label: 'Jastip & Belanja',
      ),
      _ServiceItem(
        imagePath: 'assets/images/perbaikan_ringan.png',
        label: 'Perbaikan Ringan',
      ),
      _ServiceItem(
        imagePath: 'assets/images/sosial_lainnya.png',
        label: 'Sosial & Lainnya',
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 0.82,
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
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.grey.shade100),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Image.asset(
                    service.imagePath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                service.label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1572BD), // Blue color from screenshot
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _ServiceItem {
  final String imagePath;
  final String label;
  _ServiceItem({
    required this.imagePath,
    required this.label,
  });
}
