import 'package:flutter/material.dart';
import '../../models/pengajuan_model.dart';
import '../../services/pengajuan_service.dart';

class DetailDomainPage extends StatefulWidget {
  final Pengajuan data;

  const DetailDomainPage({super.key, required this.data});

  @override
  State<DetailDomainPage> createState() => _DetailDomainPageState();
}

class _DetailDomainPageState extends State<DetailDomainPage> {
  String selectedStatus = '';
  final TextEditingController catatan = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedStatus = widget.data.status;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.data;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Pengajuan"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
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
            _fileTile("Surat Permohonan"),
            _fileTile("Surat Kuasa"),
            _fileTile("Kartu Pegawai"),
            _fileTile("Dasar Hukum"),
            _fileTile("Surat Penunjukan"),

            const SizedBox(height: 20),

            // ================= VERIFIKASI =================
            Container(
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

                  // STATUS AKTIF (LOCK)
                  if (item.status == 'aktif') ...[
                    const Text(
                      "Domain sudah aktif dan tidak dapat diubah",
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ] else ...[
                    //RADIO STATUS
                    RadioListTile(
                      value: "diproses",
                      groupValue: selectedStatus,
                      onChanged: (val) {
                        setState(() => selectedStatus = val!);
                      },
                      title: const Text("Diproses"),
                    ),
                    RadioListTile(
                      value: "perbaikan",
                      groupValue: selectedStatus,
                      onChanged: (val) {
                        setState(() => selectedStatus = val!);
                      },
                      title: const Text("Perlu Perbaikan"),
                    ),

                    const SizedBox(height: 10),

                    //CATATAN
                    TextField(
                      controller: catatan,
                      decoration: const InputDecoration(
                        hintText: "Catatan...",
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),

                    const SizedBox(height: 20),

                    //BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                if (selectedStatus.isEmpty) return;

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

                                  Navigator.pop(context, true); // refresh list
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text("Gagal: $e")),
                                  );
                                } finally {
                                  setState(() => isLoading = false);
                                }
                              },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text("Kirim"),
                      ),
                    ),
                  ],
                ],
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
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget _infoTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.blue)),
      trailing: Text(value),
    );
  }

  Widget _fileTile(String title) {
    return ListTile(
      title: Text(title),
      trailing: const Text("Lihat", style: TextStyle(color: Colors.blue)),
      onTap: () {},
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
