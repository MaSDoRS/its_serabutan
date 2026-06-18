import 'package:flutter/material.dart';

class UploadShowcaseScreen extends StatelessWidget {
  const UploadShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Upload Hasil Kerja / Portofolio - Area 1
          _buildUploadSection(
            context: context,
            title: 'Upload Hasil Kerja / Portofolio',
            subtitle: 'Tampilkan hasil kerja terbaikmu',
            height: 180,
          ),
          const SizedBox(height: 24),
          // Upload KTM
          _buildUploadSection(
            context: context,
            title: 'Upload Hasil Kerja / Portofolio',
            subtitle: 'KLIK UNTUK UPLOAD KTM',
            height: 120,
            showPlusIcon: true,
          ),
          const SizedBox(height: 32),
          // Gallery grid (improvisasi)
          const Text(
            'Portofolio Saya',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Belum ada portofolio yang diunggah',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 16),
          // Empty state placeholder
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.photo_library_outlined,
                  size: 48,
                  color: Colors.grey.shade300,
                ),
                const SizedBox(height: 10),
                Text(
                  'Upload hasil kerjamu agar\ncustomer lebih yakin',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadSection({
    required BuildContext context,
    required String title,
    required String subtitle,
    required double height,
    bool showPlusIcon = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Fitur upload akan segera tersedia'),
              ),
            );
          },
          child: Container(
            width: double.infinity,
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (showPlusIcon)
                  Icon(
                    Icons.add,
                    size: 32,
                    color: Colors.grey.shade400,
                  ),
                if (showPlusIcon) const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
