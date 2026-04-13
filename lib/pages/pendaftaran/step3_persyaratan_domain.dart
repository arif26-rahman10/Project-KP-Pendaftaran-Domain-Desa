import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../services/registration_data.dart';
import '../../widgets/step_form_layout.dart';
import 'step4_pratinjau.dart';

class Step3PersyaratanDomain extends StatefulWidget {
  final RegistrationData data;

  const Step3PersyaratanDomain({super.key, required this.data});

  @override
  State<Step3PersyaratanDomain> createState() => _Step3PersyaratanDomainState();
}

class _Step3PersyaratanDomainState extends State<Step3PersyaratanDomain> {
  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      final file = result.files.single;

      if (file.size > 1024 * 1024) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('File maksimal 1MB')));
        return;
      }

      setState(() {
        widget.data.filePaths[type] = file.path!;
        if (type == 'permohonan') widget.data.suratPermohonan = file.name;
        if (type == 'kuasa') widget.data.suratKuasa = file.name;
        if (type == 'penunjukan') widget.data.suratPenunjukan = file.name;
        if (type == 'pegawai') widget.data.kartuPegawai = file.name;
        if (type == 'hukum') widget.data.dasarHukum = file.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepFormLayout(
      activeStep: 2,
      onBack: () => Navigator.pop(context),
      onNext: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Step4Pratinjau(data: widget.data)),
        );
      },

      // 🔥 ISI HALAMAN
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Unggah Dokumen Persyaratan",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          const Text(
            "Silakan unggah semua dokumen yang diperlukan",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),

          const SizedBox(height: 16),

          _uploadCard(
            "Surat Permohonan",
            widget.data.suratPermohonan,
            "permohonan",
          ),
          _uploadCard("Surat Kuasa", widget.data.suratKuasa, "kuasa"),
          _uploadCard(
            "Surat Penunjukan",
            widget.data.suratPenunjukan,
            "penunjukan",
          ),
          _uploadCard("Kartu Pegawai", widget.data.kartuPegawai, "pegawai"),
          _uploadCard("Dasar Hukum", widget.data.dasarHukum, "hukum"),
        ],
      ),
    );
  }

  // ================= UI CARD =================
  Widget _uploadCard(String title, String fileName, String type) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const Icon(Icons.upload_file, color: Colors.red),
        title: Text(title),
        subtitle: Text(
          fileName.isEmpty ? "Belum ada file" : fileName,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14),
        onTap: () => _pickFile(type),
      ),
    );
  }
}
