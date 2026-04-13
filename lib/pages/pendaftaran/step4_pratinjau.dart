import 'package:flutter/material.dart';
import '../../services/registration_data.dart';
import '../../widgets/step_form_layout.dart';

class Step4Pratinjau extends StatelessWidget {
  final RegistrationData data;

  const Step4Pratinjau({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return StepFormLayout(
      activeStep: 3,
      onBack: () => Navigator.pop(context),
      onNext: () {
        // nanti bisa kirim ke API
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pengajuan berhasil dikirim")),
        );

        Navigator.popUntil(context, (route) => route.isFirst);
      },

      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pratinjau Data",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // ================= DATA INSTANSI =================
            _sectionTitle("Informasi Instansi"),
            _item("Nama Desa", data.namaDesa),
            _item("Kepala Desa", data.namaKepalaDesa),
            _item("Telepon", data.telepon),
            _item("Alamat", data.alamat),
            _item("Kode Pos", data.kodePos),

            const SizedBox(height: 16),

            // ================= DOKUMEN =================
            _sectionTitle("Dokumen Persyaratan"),

            _fileItem("Surat Permohonan", data.suratPermohonan),
            _fileItem("Surat Kuasa", data.suratKuasa),
            _fileItem("Surat Penunjukan", data.suratPenunjukan),
            _fileItem("Kartu Pegawai", data.kartuPegawai),
            _fileItem("Dasar Hukum", data.dasarHukum),
          ],
        ),
      ),
    );
  }

  // ================= TITLE =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
      ),
    );
  }

  // ================= TEXT ITEM =================
  Widget _item(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(label, style: const TextStyle(fontSize: 12)),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value.isEmpty ? "-" : value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  // ================= FILE ITEM =================
  Widget _fileItem(String title, String fileName) {
    final isUploaded = fileName.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(
          isUploaded ? Icons.check_circle : Icons.cancel,
          color: isUploaded ? Colors.green : Colors.red,
        ),
        title: Text(title),
        subtitle: Text(
          isUploaded ? fileName : "Belum diupload",
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
