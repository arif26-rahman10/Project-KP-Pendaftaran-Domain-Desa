import 'package:flutter/material.dart';
import '../../models/pengajuan_model.dart';
import '../admin/domain/pdf_network_page.dart';
// import halaman edit nanti kalau sudah ada
// import 'edit_pengajuan_page.dart';

class DetailVerifikasiPage extends StatelessWidget {
  final Pengajuan data;

  const DetailVerifikasiPage({super.key, required this.data});

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

            _sectionTitle("Informasi Instansi"),
            _info("Nama Desa", item.namaDesa),
            _info("Domain", item.domain),
            _info("Tanggal", item.tanggal),

            _sectionTitle("Dokumen"),
            _file("Surat Permohonan", item, "surat_permohonan", context),
            _file("Perda", item, "perda_pembentukan_desa", context),
            _file("Surat Kuasa", item, "surat_kuasa", context),
            _file(
              "Surat Penunjukan",
              item,
              "surat_penunjukan_pejabat",
              context,
            ),
            _file("KTP ASN", item, "ktp_asn_pejabat", context),

            const SizedBox(height: 20),

            if (item.status == "perlu_perbaikan" || item.status == "draft")
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  onPressed: () {
                    // TODO: arahkan ke halaman edit
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => EditPengajuanPage(data: item),
                    //   ),
                    // );
                  },
                  child: const Text("Edit Pengajuan"),
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
    return ListTile(title: Text(label), trailing: Text(value));
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
      case 'aktif':
        return "Domain Aktif";
      case 'draft':
        return "Draft";
      default:
        return status;
    }
  }
}
