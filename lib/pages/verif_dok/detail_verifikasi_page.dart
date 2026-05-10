import 'package:flutter/material.dart';
import '../../models/pengajuan_model.dart';
import '../../services/local_auth_service.dart';
import '../admin/domain/pdf_network_page.dart';
import '../faktur/detail_faktur_page.dart';
import 'edit_pengajuan_page.dart';

class DetailVerifikasiPage extends StatelessWidget {
  final Pengajuan data;

  const DetailVerifikasiPage({super.key, required this.data});

  Future<void> _lanjutPembayaran(BuildContext context, Pengajuan item) async {
    final user = await LocalAuthService.getRegisteredUser();

    final fullName = user['fullName']?.toString() ?? item.namaDesa;
    final username = user['username']?.toString() ?? '-';

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Lanjutkan Pembayaran"),
          content: const Text(
            "Apakah Anda ingin melanjutkan ke proses pembayaran?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Tidak"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DetailFakturPage(
                      idPengajuan: item.id,
                      fullName: fullName,
                      username: username,
                      invoiceNumber: "INV-${item.id}",
                      tanggalTerbit: item.tanggal,
                      tanggalKadaluarsa: "-",
                      namaDomain: "${item.domain}.desa.id",
                      jenisAplikasi: "Registrasi Domain",
                      durasi: "1 Tahun",
                      harga: "Rp.50.000",
                    ),
                  ),
                );
              },
              child: const Text("Ya"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = data;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Dokumen"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _sectionTitle("Status Verifikasi"),
            ListTile(
              title: const Text("Status"),
              trailing: Text(_statusText(item.status)),
            ),

            if (item.status == "perlu_perbaikan")
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Catatan Perbaikan",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.catatanUmum.isEmpty
                          ? "Tidak ada catatan"
                          : item.catatanUmum,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

            if (item.status == "diproses")
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: const Text(
                  "Dokumen sudah diproses. Silakan lanjutkan pembayaran untuk melanjutkan aktivasi domain.",
                  style: TextStyle(fontSize: 14),
                ),
              ),

            _sectionTitle("Informasi Instansi"),
            _info("Nama Desa", item.namaDesa),
            _info("Domain", item.domain),
            _info("Tanggal", item.tanggal),

            _sectionTitle("Dokumen"),
            _file("Surat Permohonan", item, "surat_permohonan", context),
            _file("Perda", item, "perda_pembentukan_desa", context),
            _file("Surat Kuasa", item, "surat_kuasa", context),
            _file("Surat Penunjukan", item, "surat_penunjukan_pejabat", context),
            _file("KTP ASN", item, "ktp_asn_pejabat", context),

            const SizedBox(height: 20),

            if (item.status == "diproses")
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    _lanjutPembayaran(context, item);
                  },
                  child: const Text(
                    "Lanjutkan Pembayaran",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),

            if (item.status == "perlu_perbaikan" || item.status == "draft")
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditPengajuanPage(data: item),
                      ),
                    );

                    if (result == true && context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text(
                    "Edit Pengajuan",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.red,
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 14),
      ),
    );
  }

  Widget _info(String label, String value) {
    return ListTile(
      title: Text(label),
      trailing: Text(value.isEmpty ? "-" : value),
    );
  }

  Widget _file(String title, Pengajuan item, String key, BuildContext context) {
    final url = item.dokumenUrls[key];
    final isAvailable = url != null && url.isNotEmpty;

    return ListTile(
      title: Text(title),
      trailing: Text(
        isAvailable ? "Lihat" : "Tidak ada",
        style: TextStyle(color: isAvailable ? Colors.blue : Colors.grey),
      ),
      onTap: isAvailable
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PdfNetworkPage(url: url!, title: title),
                ),
              );
            }
          : null,
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'ditinjau':
        return "Menunggu Verifikasi";
      case 'diproses':
        return "Sedang Diproses";
      case 'perlu_perbaikan':
        return "Perlu Perbaikan";
      case 'menunggu_aktivasi':
        return "Menunggu Aktivasi";
      case 'aktif':
        return "Domain Aktif";
      case 'draft':
        return "Draft";
      default:
        return status;
    }
  }
}