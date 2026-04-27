import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../services/registration_data.dart';
import '../../widgets/step_form_layout.dart';
import 'step4_pratinjau.dart';
import 'pdf_preview_page.dart';

class Step3PersyaratanDomain extends StatefulWidget {
  final RegistrationData data;

  const Step3PersyaratanDomain({super.key, required this.data});

  @override
  State<Step3PersyaratanDomain> createState() => _Step3PersyaratanDomainState();
}

class _Step3PersyaratanDomainState extends State<Step3PersyaratanDomain> {
  static const int maxFileSize = 2 * 1024 * 1024; // 2 MB

  Future<void> _pickFile(String type, String title) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;

    final file = result.files.single;

    if (file.extension?.toLowerCase() != 'pdf') {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hanya file PDF yang diperbolehkan'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (file.size > maxFileSize) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ukuran file maksimal 2 MB'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      widget.data.filePaths[type] = file.path ?? '';

      if (type == 'permohonan') {
        widget.data.suratPermohonan = file.name;
      } else if (type == 'kuasa') {
        widget.data.suratKuasa = file.name;
      } else if (type == 'penunjukan') {
        widget.data.suratPenunjukan = file.name;
      } else if (type == 'pegawai') {
        widget.data.kartuPegawai = file.name;
      } else if (type == 'hukum') {
        widget.data.dasarHukum = file.name;
      }
    });
  }

  void _openPreview(String type, String title) {
    final filePath = widget.data.filePaths[type];

    if (filePath == null || filePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File belum diunggah'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfPreviewPage(
          filePath: filePath,
          title: title,
        ),
      ),
    );
  }

  void _handleTap({
    required String type,
    required String title,
    required String fileName,
  }) {
    if (fileName.trim().isNotEmpty) {
      _openPreview(type, title);
    } else {
      _pickFile(type, title);
    }
  }

  bool _isAllFilesUploaded() {
    return widget.data.suratPermohonan.trim().isNotEmpty &&
        widget.data.suratKuasa.trim().isNotEmpty &&
        widget.data.suratPenunjukan.trim().isNotEmpty &&
        widget.data.kartuPegawai.trim().isNotEmpty &&
        widget.data.dasarHukum.trim().isNotEmpty;
  }

  void _goToNextStep() {
    if (!_isAllFilesUploaded()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harap unggah semua dokumen terlebih dahulu'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Step4Pratinjau(data: widget.data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StepFormLayout(
      activeStep: 2,
      onBack: () => Navigator.pop(context),
      onNext: _goToNextStep,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Unggah Dokumen Persyaratan",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            const Text(
              "Silakan unggah semua dokumen dalam format PDF. Maksimal 2 MB tiap file.",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),

            _uploadCard(
              title: "Surat Permohonan",
              fileName: widget.data.suratPermohonan,
              type: "permohonan",
            ),
            _uploadCard(
              title: "Surat Kuasa",
              fileName: widget.data.suratKuasa,
              type: "kuasa",
            ),
            _uploadCard(
              title: "Surat Penunjukan",
              fileName: widget.data.suratPenunjukan,
              type: "penunjukan",
            ),
            _uploadCard(
              title: "Kartu Pegawai",
              fileName: widget.data.kartuPegawai,
              type: "pegawai",
            ),
            _uploadCard(
              title: "Dasar Hukum",
              fileName: widget.data.dasarHukum,
              type: "hukum",
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _uploadCard({
    required String title,
    required String fileName,
    required String type,
  }) {
    final bool isUploaded = fileName.trim().isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isUploaded ? const Color(0xFFEFFAF0) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isUploaded ? Colors.green : Colors.grey.shade300,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: Icon(
          isUploaded ? Icons.check_circle : Icons.picture_as_pdf,
          color: isUploaded ? Colors.green : Colors.red,
          size: 28,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            isUploaded ? fileName : "Belum ada file PDF",
            style: TextStyle(
              fontSize: 12,
              color: isUploaded ? Colors.green : Colors.grey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: Icon(
          isUploaded ? Icons.remove_red_eye : Icons.arrow_forward_ios,
          size: 18,
          color: isUploaded ? Colors.green : Colors.grey,
        ),
        onTap: () => _handleTap(
          type: type,
          title: title,
          fileName: fileName,
        ),
      ),
    );
  }
}