import 'package:flutter/material.dart';
import '../../../widgets/admin_bottom_nav.dart';
import 'admin_domain_page.dart';
import 'perpanjangan_domain_page.dart';

class AdminDomainMenu extends StatelessWidget {
  const AdminDomainMenu({super.key});

  Widget _menuCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
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
      backgroundColor: const Color(0xfff5f5f5),

      body: Column(
        children: [
          SizedBox(height: topSafe + 12),

          // HEADER
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Admin Domain',
                    style: TextStyle(
                      color: Color(0xFF6F1717),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
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
                children: [
                  const SizedBox(height: 20),

                  // ================= PENGAJUAN =================
                  _menuCard(
                    icon: Icons.assignment_outlined,
                    title: 'Pengajuan Domain',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const DomainPage()),
                      );
                    },
                  ),

                  const SizedBox(height: 30),

                  // ================= PERPANJANGAN =================
                  _menuCard(
                    icon: Icons.update,
                    title: 'Perpanjangan Domain',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const PerpanjanganDomainPage(),
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

      // NAVBAR ADMIN
      bottomNavigationBar: const AdminBottomNav(currentIndex: 1),
    );
  }
}
