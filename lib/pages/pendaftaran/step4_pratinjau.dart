import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../services/registration_data.dart';
import '../../widgets/step_form_layout.dart';

class Step4Pratinjau extends StatefulWidget {
  final RegistrationData data;

  const Step4Pratinjau({super.key, required this.data});

  @override
  State<Step4Pratinjau> createState() => _Step4PratinjauState();
}

class _Step4PratinjauState extends State<Step4Pratinjau> {
  bool _isLoading = false;

  Future<void> _submitData() async {
    setState(() => _isLoading = true);

    try {
      final result = await ApiService.submitPendaftaran(data: widget.data);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? "Pengajuan berhasil dikirim"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString().replaceAll("Exception: ", "")),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepFormLayout(
      activeStep: 3,
      onBack: () => Navigator.pop(context),
      onNext: _isLoading ? () {} : _submitData,
      nextButtonText: _isLoading ? "Mengirim..." : "Kirim",
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pratinjau Data",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _sectionTitle("Informasi Instansi"),
            _item("Nama Domain", widget.data.namaDomain),
            _item("Nama Desa", widget.data.namaDesa),
            _item("Kepala Desa", widget.data.namaKepalaDesa),
            _item("Telepon", widget.data.telepon),
            _item("Alamat", widget.data.alamat),
            _item("Kode Pos", widget.data.kodePos),

            const SizedBox(height: 16),

            _sectionTitle("Dokumen Persyaratan"),
            _fileItem("Surat Permohonan", widget.data.suratPermohonan),
            _fileItem("Surat Kuasa", widget.data.suratKuasa),
            _fileItem("Surat Penunjukan", widget.data.suratPenunjukan),
            _fileItem("Kartu Pegawai", widget.data.kartuPegawai),
            _fileItem("Dasar Hukum", widget.data.dasarHukum),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 13,
        ),
      ),
    );
  }

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
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

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