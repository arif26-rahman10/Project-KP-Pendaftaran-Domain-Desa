import 'package:flutter/material.dart';
import '../../widgets/support_logo.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: SingleChildScrollView(
          // 🔥 scroll semua
          child: Column(
            children: [
              _buildHeader(context),
              const SizedBox(height: 20),
              _buildStats(),
              const SizedBox(height: 20),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // 🔴 HEADER
  Widget _buildHeader(BuildContext context) {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
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
            "Nama Aplikasi",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          // 🔥 LOGO
          Center(
            child: Column(
              children: [
                Image.asset('assets/images/logo_diskominfotik.png', height: 60),
                const SizedBox(height: 8),
              ],
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
        shrinkWrap: true, // 🔥 wajib
        physics: const NeverScrollableScrollPhysics(), // 🔥 penting
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: const [
          StatCard(title: "Domain Aktif", value: "10"),
          StatCard(title: "Pengajuan Domain", value: "5"),
          StatCard(title: "Menunggu Pembayaran", value: "3"),
          StatCard(title: "Dokumen Perlu Verifikasi", value: "2"),
        ],
      ),
    );
  }

  // 🔻 BOTTOM NAV
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.red,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed, // 🔥 biar stabil
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.public), label: "Domain"),
        BottomNavigationBarItem(icon: Icon(Icons.receipt), label: "Faktur"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profil"),
      ],
    );
  }
}

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
