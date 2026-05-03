import 'package:flutter/material.dart';
import '../../main.dart';
import '../../widgets/app_bottom_nav.dart';
import '../notifikasi/notifikasi_page.dart';
import 'daftar_domain_page.dart';
import '../pendaftaran/step1_check_domain.dart';
import '../../services/registration_data.dart';
import '../verif_dok/verifikasi_dokumen_page.dart';

class DomainPage extends StatefulWidget {
  final String fullName;
  final String username;

  const DomainPage({super.key, required this.fullName, required this.username});

  @override
  State<DomainPage> createState() => _DomainPageState();
}

class _DomainPageState extends State<DomainPage> {
  Widget _domainCard({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 280),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFBE2A2A),
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(icon, color: Colors.white, size: 52),
                const SizedBox(height: 14),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          SizedBox(height: topSafe + 12),

          // HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Pendaftaran Domain',
                    style: TextStyle(
                      color: Color(0xFF6F1717),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.notifications_none),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotifikasiPage(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // CONTENT
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Layanan Domain',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),

                  const SizedBox(height: 30),

                  _domainCard(
                    icon: Icons.fact_check_outlined,
                    title: 'Pendaftaran Domain',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              Step1CheckDomain(data: RegistrationData()),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  _domainCard(
                    icon: Icons.update,
                    title: 'Perpanjangan Domain',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const DaftarDomainPage(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  //MENU VERIFIKASI DOKUMEN
                  _domainCard(
                    icon: Icons.verified_outlined,
                    title: 'Verifikasi Dokumen',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VerifikasiDokumenPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

      // NAVBAR
      // Index 1 aktif karena ini halaman Domain
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        fullName: widget.fullName,
        username: widget.username,
      ),
    );
  }
}
