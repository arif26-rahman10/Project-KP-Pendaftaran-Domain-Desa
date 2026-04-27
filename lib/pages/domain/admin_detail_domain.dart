import 'package:flutter/material.dart';
import '../../models/pengajuan_model.dart';
import '../../widgets/admin_bottom_nav.dart';

class DetailDomainPage extends StatefulWidget {
  final Pengajuan data;

  const DetailDomainPage({super.key, required this.data});

  @override
  State<DetailDomainPage> createState() => _DetailDomainPageState();
}

class _DetailDomainPageState extends State<DetailDomainPage> {
  String selectedStatus = "disetujui";
  bool kirimEmail = true;
  TextEditingController catatan = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final item = widget.data;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Dokumen"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ================= INFORMASI INSTANSI =================
            sectionTitle("Informasi Instansi"),
            infoTile("Nama Instansi", item.namaDesa),
            infoTile("Nama Domain", item.domain),
            infoTile("Tanggal Pengajuan", item.tanggal),

            // ================= DOKUMEN =================
            sectionTitle("Dokumen Persyaratan"),
            fileTile("Surat Permohonan"),
            fileTile("Surat Kuasa"),
            fileTile("Kartu Pegawai"),
            fileTile("Dasar Hukum"),
            fileTile("Surat Penunjukan"),

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

                  // RADIO BUTTON
                  Row(
                    children: [
                      Radio(
                        value: "disetujui",
                        groupValue: selectedStatus,
                        onChanged: (val) {
                          setState(() {
                            selectedStatus = val!;
                          });
                        },
                      ),
                      const Text("Disetujui"),

                      Radio(
                        value: "perbaikan",
                        groupValue: selectedStatus,
                        onChanged: (val) {
                          setState(() {
                            selectedStatus = val!;
                          });
                        },
                      ),
                      const Text("Perlu Perbaikan"),
                    ],
                  ),

                  // CHECKBOX
                  CheckboxListTile(
                    value: kirimEmail,
                    onChanged: (val) {
                      setState(() {
                        kirimEmail = val!;
                      });
                    },
                    title: const Text("Kirim konfirmasi pembayaran"),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),

                  // CATATAN
                  TextField(
                    controller: catatan,
                    decoration: const InputDecoration(hintText: "Catatan..."),
                  ),

                  const SizedBox(height: 20),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: () {
                        // TODO: kirim ke API
                        print("Status: $selectedStatus");
                        print("Catatan: ${catatan.text}");
                      },
                      child: const Text("Kirim"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= WIDGET =================

  Widget sectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      color: Colors.red,
      child: Text(title, style: const TextStyle(color: Colors.white)),
    );
  }

  Widget infoTile(String label, String value) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.blue)),
      trailing: Text(value),
    );
  }

  Widget fileTile(String title) {
    return ListTile(
      title: Text(title),
      trailing: const Text("Lihat", style: TextStyle(color: Colors.blue)),
      onTap: () {},
    );
  }
}
