import 'package:flutter/material.dart';

import '../../main.dart';
import '../../models/pengajuan_model.dart';
import '../../services/pengajuan_service.dart';
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
  bool isLoading = true;
  List<Pengajuan> listFaktur = [];

  @override
  void initState() {
    super.initState();
    _loadFaktur();
  }

  Future<void> _loadFaktur() async {
    setState(() {
      isLoading = true;
    });

    final data = await PengajuanService().getPengajuanUser();

    if (!mounted) return;

    setState(() {
      listFaktur = data.where((item) {
        return item.status == 'diproses' ||
            item.status == 'menunggu_aktivasi' ||
            item.status == 'aktif';
      }).toList();

      isLoading = false;
    });
  }

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
      _loadFaktur();
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

  Widget _invoiceCard(Pengajuan item) {
    final invoice = item.noInvoice.isNotEmpty
        ? item.noInvoice
        : "INV-${item.id}";
    final domain = "${item.domain}.desa.id";

    final bool buktiSudahDikirim =
        item.buktiPembayaranUrl.isNotEmpty ||
        item.fakturStatus == 'sudah_bayar' ||
        item.status == 'menunggu_aktivasi';

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailFakturPage(
              idPengajuan: item.id,
              fullName: widget.fullName,
              username: widget.username,
              invoiceNumber: invoice,
              tanggalTerbit: item.tanggal,
              tanggalKadaluarsa: "-",
              namaDomain: domain,
              jenisAplikasi: "Registrasi Domain",
              durasi: "1 Tahun",
              harga: item.totalFaktur.isNotEmpty
                  ? "Rp.${item.totalFaktur}"
                  : "Rp.50.000",
              buktiPembayaranUrl: item.buktiPembayaranUrl,
              fakturStatus: item.fakturStatus,
            ),
          ),
        );

        if (result == true) {
          _loadFaktur();
        }
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: buktiSudahDikirim ? Colors.grey.shade300 : Colors.white,
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
            Text("Nama Domain : $domain"),
            Text("Tanggal Terbit : ${item.tanggal}"),
            const SizedBox(height: 6),
            Text(
              buktiSudahDikirim
                  ? "Status : Bukti pembayaran sudah dikirim"
                  : "Status : Menunggu pembayaran",
              style: TextStyle(
                color: buktiSudahDikirim ? Colors.orange : Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadFaktur,
                    child: listFaktur.isEmpty
                        ? ListView(
                            children: const [
                              SizedBox(height: 260),
                              Center(
                                child: Text("Belum ada faktur pembayaran"),
                              ),
                            ],
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
                            itemCount: listFaktur.length,
                            itemBuilder: (context, index) {
                              return _invoiceCard(listFaktur[index]);
                            },
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
