import 'package:flutter/material.dart';
import '../../../models/pengajuan_model.dart';
import '../../../services/pengajuan_service.dart';
import 'pdf_network_page.dart';

class DetailDomainPage extends StatefulWidget {
  final Pengajuan data;

  const DetailDomainPage({super.key, required this.data});

  @override
  State<DetailDomainPage> createState() => _DetailDomainPageState();
}

class _DetailDomainPageState extends State<DetailDomainPage> {
  late Future<Pengajuan> detailFuture;

  String selectedStatus = '';
  final TextEditingController catatan = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    detailFuture = PengajuanService().getDetail(widget.data.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pengajuan"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<Pengajuan>(
        future: detailFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final item = snapshot.data!;
          selectedStatus = item.status;

          return SingleChildScrollView(
            child: Column(
              children: [
                _sectionTitle("Informasi Instansi"),
                _infoTile("Nama Instansi", item.namaDesa),
                _infoTile("Nama Domain", item.domain),
                _infoTile("Tanggal", item.tanggal),
                _infoTile("Status", _statusText(item.status)),

                const SizedBox(height: 10),

                // ================= DOKUMEN =================
                _sectionTitle("Dokumen Persyaratan"),
                _fileTile("Surat Permohonan", "surat_permohonan", item),
                _fileTile(
                  "Perda Pembentukan Desa",
                  "perda_pembentukan_desa",
                  item,
                ),
                _fileTile("Surat Kuasa", "surat_kuasa", item),
                _fileTile(
                  "Surat Penunjukan Pejabat",
                  "surat_penunjukan_pejabat",
                  item,
                ),
                _fileTile("KTP ASN Pejabat", "ktp_asn_pejabat", item),

                const SizedBox(height: 20),

                _verifikasiSection(item),
              ],
            ),
          );
        },
      ),
    );
  }

  // ================= WIDGET =================

  Widget _sectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.red,
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _infoTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.blue)),
      trailing: Text(value),
    );
  }

  Widget _fileTile(String title, String type, Pengajuan item) {
    final url = item.dokumenUrls[type];
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
                  builder: (_) => PdfNetworkPage(url: url, title: title),
                ),
              );
            }
          : null,
    );
  }

  Widget _verifikasiSection(Pengajuan item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xfff5f5f5),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hasil Verifikasi",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),

          if (item.status == 'aktif') ...[
            const Text(
              "Domain sudah aktif dan tidak dapat diubah",
              style: TextStyle(color: Colors.green),
            ),
          ] else ...[
            RadioListTile(
              value: "diproses",
              groupValue: selectedStatus,
              onChanged: (val) {
                setState(() => selectedStatus = val!);
              },
              title: const Text("Diproses"),
            ),
            RadioListTile(
              value: "perlu_perbaikan", // 🔥 FIX
              groupValue: selectedStatus,
              onChanged: (val) {
                setState(() => selectedStatus = val!);
              },
              title: const Text("Perlu Perbaikan"),
            ),

            TextField(
              controller: catatan,
              decoration: const InputDecoration(
                hintText: "Catatan...",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(() => isLoading = true);

                        try {
                          await PengajuanService().verifikasiPengajuan(
                            id: item.id,
                            status: selectedStatus,
                            catatan: catatan.text,
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Berhasil verifikasi"),
                            ),
                          );

                          Navigator.pop(context, true);
                        } catch (e) {
                          ScaffoldMessenger.of(
                            context,
                          ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
                        } finally {
                          setState(() => isLoading = false);
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Kirim"),
              ),
            ),
          ],
        ],
      ),
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
      default:
        return status;
    }
  }
}
