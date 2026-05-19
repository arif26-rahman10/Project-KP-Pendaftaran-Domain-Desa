import 'package:flutter/material.dart';
import 'package:pendaftaran_domain_desa/pages/admin/notifikasi_page.dart';

import '../../services/dashboard_service.dart';
import '../../widgets/admin_bottom_nav.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int totalAktif = 0;
  int totalPengajuan = 0;
  int totalAktivasi = 0;
  int totalVerifikasi = 0;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    final data = await DashboardService().getDashboard();

    setState(() {
      totalAktif = data['domain_aktif'] ?? 0;
      totalPengajuan = data['tahap_proses'] ?? 0;
      totalAktivasi = data['menunggu_aktivasi'] ?? 0;
      totalVerifikasi = data['perlu_verifikasi'] ?? 0;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      bottomNavigationBar: const AdminBottomNav(currentIndex: 0),

      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  _buildHeroHeader(context),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
                      child: _buildStats(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 26),

      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color.fromARGB(255, 110, 24, 23), Color(0xFFB71C1C)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),

        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),

      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,

            child: Opacity(
              opacity: .18,

              child: Padding(
                padding: const EdgeInsets.only(top: 10),

                child: Image.asset(
                  'assets/images/logo_diskominfotik.png',
                  height: 120,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Spacer(),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.14),
                      borderRadius: BorderRadius.circular(16),
                    ),

                    child: IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const NotifikasiPage(),
                          ),
                        );
                      },

                      icon: const Icon(
                        Icons.notifications_none_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              const Text(
                "Selamat Datang",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),

              const SizedBox(height: 6),

              const Text(
                "Admin Diskominfo",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 14),

              Text(
                "Kelola pengajuan domain desa, proses aktivasi dan verifikasi data dalam satu dashboard terintegrasi.",
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.white.withOpacity(.88),
                  fontSize: 14,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Column(
      children: [
        StatCard(
          title: "Domain Aktif",
          value: totalAktif.toString(),
          subtitle: "Jumlah domain desa aktif",
          color: Colors.green,
        ),

        const SizedBox(height: 14),

        StatCard(
          title: "Pengajuan Diproses",
          value: totalPengajuan.toString(),
          subtitle: "Pengajuan sedang diproses",
          color: Colors.blue,
        ),

        const SizedBox(height: 14),

        StatCard(
          title: "Menunggu Aktivasi",
          value: totalAktivasi.toString(),
          subtitle: "Domain siap diaktivasi",
          color: Colors.orange,
        ),

        const SizedBox(height: 14),

        StatCard(
          title: "Perlu Verifikasi",
          value: totalVerifikasi.toString(),
          subtitle: "Data memerlukan verifikasi",
          color: Colors.red,
        ),
      ],
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final Color color;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 5,
            height: 70,

            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: color,
                    height: 1,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
