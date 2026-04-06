import 'package:flutter/material.dart';
import '../../main.dart';
import 'detail_faktur_page.dart';
import '../home_page.dart';
import '../domain/domain_page.dart';
import '../users/profile_page.dart';
import '../notifikasi/notifikasi_page.dart';

class FakturPage extends StatefulWidget {
  final String fullName;
  final String username;

  const FakturPage({super.key, required this.fullName, required this.username});

  @override
  State<FakturPage> createState() => _FakturPageState();
}

class _FakturPageState extends State<FakturPage> {
  int currentIndex = 2;

  void _onTapNav(int index) {
    if (index == currentIndex) return;

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              HomePage(fullName: widget.fullName, username: widget.username),
        ),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              DomainPage(fullName: widget.fullName, username: widget.username),
        ),
      );
    } else if (index == 2) {
      setState(() {
        currentIndex = 2;
      });
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ProfilePage(fullName: widget.fullName, username: widget.username),
        ),
      );
    }
  }

  Widget _invoiceCard({
    required String invoice,
    required String tglTerbit,
    required String tglKadaluarsa,
    required String namaDomain,
    required String jenisAplikasi,
    required String durasi,
    required String harga,
    bool grey = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailFakturPage(
              fullName: widget.fullName,
              username: widget.username,
              invoiceNumber: invoice,
              tanggalTerbit: tglTerbit,
              tanggalKadaluarsa: tglKadaluarsa,
              namaDomain: namaDomain,
              jenisAplikasi: jenisAplikasi,
              durasi: durasi,
              harga: harga,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: grey ? Colors.grey.shade300 : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "INVOICE",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            const SizedBox(height: 6),
            Text(invoice, style: const TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Text("Tanggal Terbit : $tglTerbit"),
            Text("Tanggal Kadaluarsa : $tglKadaluarsa"),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, int index) {
    final isActive = currentIndex == index;

    return InkWell(
      onTap: () => _onTapNav(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? kPrimary : Colors.grey, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? kPrimary : Colors.grey,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          SizedBox(height: topSafe + 12),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Faktur',
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
                    icon: const Icon(
                      Icons.notifications_none,
                      size: 23,
                      color: Colors.black87,
                    ),
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
              child: Column(
                children: [
                  _invoiceCard(
                    invoice: "INV-023",
                    tglTerbit: "xx/xx/xxxx",
                    tglKadaluarsa: "xx/xx/xxxx",
                    namaDomain: "xxx.desa.id",
                    jenisAplikasi: "Registrasi",
                    durasi: "1 Tahun",
                    harga: "Rp.50.000",
                  ),
                  _invoiceCard(
                    invoice: "INV-022",
                    tglTerbit: "xx/xx/xxxx",
                    tglKadaluarsa: "xx/xx/xxxx",
                    namaDomain: "xxx.desa.id",
                    jenisAplikasi: "Registrasi",
                    durasi: "1 Tahun",
                    harga: "Rp.50.000",
                    grey: true,
                  ),
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
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
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
}
