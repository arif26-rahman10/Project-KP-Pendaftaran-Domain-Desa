import 'package:flutter/material.dart';
import '../../widgets/admin_bottom_nav.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),

      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              const SizedBox(height: 20),
              _buildStats(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🔴 HEADER
  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFE53935), Color(0xFF8E0000)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔔 Notifikasi
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Icon(Icons.notifications, color: Colors.white),
            ],
          ),

          const SizedBox(height: 10),

          const Text(
            "Selamat Datang di",
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),

          const SizedBox(height: 5),

          const Text(
            "Domain Desa",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // 🔥 LOGO
          Center(
            child: Image.asset(
              'assets/images/logo_diskominfotik.png',
              height: 60,
            ),
          ),
        ],
      ),
    );
  }

  // 📊 STATISTIK
  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: const [
          StatCard(title: "Domain Aktif", value: "10"),
          StatCard(title: "Pengajuan Domain", value: "5"),
          StatCard(title: "Menunggu Pembayaran", value: "3"),
          StatCard(title: "Perlu Verifikasi", value: "2"),
        ],
      ),
    );
  }
}

// ================= CARD =================
class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEDE7E7),
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 5, offset: Offset(2, 3)),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
