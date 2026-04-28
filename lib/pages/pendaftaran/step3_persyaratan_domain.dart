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
  static const int maxFileSize = 2 * 1024 * 1024;

  // ================= PICK FILE =================
  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;

    final file = result.files.single;

    if (file.extension?.toLowerCase() != 'pdf') {
      _showError('Hanya file PDF yang diperbolehkan');
      return;
    }

    if (file.size > maxFileSize) {
      _showError('Ukuran file maksimal 2 MB');
      return;
    }

    setState(() {
      widget.data.filePaths[type] = file.path ?? '';

      switch (type) {
        case 'surat_permohonan':
          widget.data.suratPermohonan = file.name;
          break;
        case 'perda_pembentukan_desa':
          widget.data.perdaPembentukanDesa = file.name;
          break;
        case 'surat_kuasa':
          widget.data.suratKuasa = file.name;
          break;
        case 'surat_penunjukan_pejabat':
          widget.data.suratPenunjukan = file.name;
          break;
        case 'ktp_asn_pejabat':
          widget.data.ktpAsnPejabat = file.name;
          break;
      }
    });
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  // ================= PREVIEW =================
  void _openPreview(String type, String title) {
    final path = widget.data.filePaths[type];

    if (path == null || path.isEmpty) {
      _showError('File belum dipilih');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfPreviewPage(filePath: path, title: title),
      ),
    );
  }

  // ================= VALIDASI =================
  bool _isAllFilesUploaded() {
    return widget.data.suratPermohonan.isNotEmpty &&
        widget.data.perdaPembentukanDesa.isNotEmpty &&
        widget.data.suratKuasa.isNotEmpty &&
        widget.data.suratPenunjukan.isNotEmpty &&
        widget.data.ktpAsnPejabat.isNotEmpty;
  }

  void _nextStep() {
    if (!_isAllFilesUploaded()) {
      _showError('Semua dokumen wajib diupload');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => Step4Pratinjau(data: widget.data)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StepFormLayout(
      activeStep: 2,
      onBack: () => Navigator.pop(context),
      onNext: _nextStep,
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Upload Dokumen (PDF, max 2MB)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            _uploadItem(
              "Surat Permohonan",
              widget.data.suratPermohonan,
              "surat_permohonan",
            ),
            _uploadItem(
              "Perda Pembentukan Desa",
              widget.data.perdaPembentukanDesa,
              "perda_pembentukan_desa",
            ),
            _uploadItem("Surat Kuasa", widget.data.suratKuasa, "surat_kuasa"),
            _uploadItem(
              "Surat Penunjukan Pejabat",
              widget.data.suratPenunjukan,
              "surat_penunjukan_pejabat",
            ),
            _uploadItem(
              "KTP ASN Pejabat",
              widget.data.ktpAsnPejabat,
              "ktp_asn_pejabat",
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI CARD =================
  Widget _uploadItem(String title, String fileName, String type) {
    final isUploaded = fileName.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: isUploaded ? const Color(0xFFE8F5E9) : Colors.white,
      child: ListTile(
        leading: Icon(
          isUploaded ? Icons.check_circle : Icons.upload_file,
          color: isUploaded ? Colors.green : Colors.grey,
        ),
        title: Text(title),
        subtitle: Text(
          isUploaded ? fileName : "Belum ada file",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isUploaded)
              IconButton(
                icon: const Icon(Icons.visibility, color: Colors.blue),
                onPressed: () => _openPreview(type, title),
              ),
            IconButton(
              icon: const Icon(Icons.upload_file),
              onPressed: () => _pickFile(type),
            ),
          ],
        ),
      ),
    );
  }
}
