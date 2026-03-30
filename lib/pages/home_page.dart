import 'package:flutter/material.dart';
import '../main.dart';
import 'domain_page.dart';
import 'faktur_page.dart';
import 'profile_page.dart';
import 'pendaftaran_domain_page.dart';
import 'notifikasi_page.dart';

class HomePage extends StatefulWidget {
  final String fullName;
  final String username;

  const HomePage({super.key, required this.fullName, required this.username});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final TextEditingController domainController = TextEditingController();

  void _goToDomainPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) =>
            DomainPage(fullName: widget.fullName, username: widget.username),
      ),
    );
  }

  void _goToNotifikasiPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotifikasiPage()),
    );
  }

  void _goToPendaftaranDomainPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PendaftaranDomainPage()),
    );
  }

  @override
  void dispose() {
    domainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(24, topSafe + 10, 24, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE01925), Color(0xFF91131C)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(26)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.20),
                        borderRadius: BorderRadius.circular(21),
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        icon: const Icon(
                          Icons.notifications_none,
                          size: 23,
                          color: Colors.white,
                        ),
                        onPressed: _goToNotifikasiPage,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Selamat Datang\n${widget.fullName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -18),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.72,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF0E8E8),
                borderRadius: BorderRadius.circular(18),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Akun Login', style: TextStyle(fontSize: 14)),
                  const SizedBox(height: 8),
                  Text(
                    widget.username,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Cari Nama Domain',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: TextField(
                      controller: domainController,
                      decoration: InputDecoration(
                        hintText: 'Nama Domain',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.grey.shade500,
                          size: 22,
                        ),
                        suffixIcon: Container(
                          width: 82,
                          alignment: Alignment.center,
                          child: Text(
                            '.desa.id',
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 18,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      const Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: 'xxxx.desa.id ',
                            style: TextStyle(color: Colors.grey, fontSize: 14),
                            children: [
                              TextSpan(
                                text: 'Tersedia',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 110,
                        height: 42,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _goToPendaftaranDomainPage,
                          child: const Text(
                            'Daftar',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Informasi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),

                  _infoCard(
                    icon: Icons.menu_book_outlined,
                    title: 'Persyaratan Pendaftaran',
                    subtitle: 'lihat selengkapnya disini',
                  ),

                  const SizedBox(height: 14),

                  _sopCard(),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(
          0,
          12,
          0,
          bottomSafe > 0 ? bottomSafe : 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _navItem(Icons.home, 'Beranda', 0),
            _navItem(Icons.language, 'Domain', 1),
            _navItem(Icons.receipt_long, 'Faktur', 2),
            _navItem(Icons.person_outline, 'Profil', 3),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = currentIndex == index;

    return InkWell(
      onTap: () {
        if (index == currentIndex) return;

        if (index == 1) {
          _goToDomainPage();
        } else if (index == 0) {
          setState(() {
            currentIndex = 0;
          });
        } else if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => FakturPage(
                fullName: widget.fullName,
                username: widget.username,
              ),
            ),
          );
        } else if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilePage(
                fullName: widget.fullName,
                username: widget.username,
              ),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? kPrimary : Colors.grey, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? kPrimary : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: kPrimary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sopCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Standar Operasional Prosedur Pelayanan',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.radio_button_checked, size: 14, color: kPrimary),
              SizedBox(width: 8),
              Text(
                'Pendaftaran Nama Domain',
                style: TextStyle(color: kPrimary, fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.radio_button_checked, size: 14, color: kPrimary),
              SizedBox(width: 8),
              Text(
                'Perpanjangan Nama Domain',
                style: TextStyle(color: kPrimary, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
