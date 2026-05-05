import 'package:flutter/material.dart';
import '../../services/registration_data.dart';
import '../../widgets/step_form_layout.dart';
import 'pdf_preview_page.dart';
import '../../services/pengajuan_service.dart';
import '../verif_dok/verifikasi_dokumen_page.dart';

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
      final service = PengajuanService();

      final success = await service.submitPengajuan(
        domain: widget.data.namaDomain,
        data: {
          "nama_desa": widget.data.namaDesa,
          "telepon": widget.data.telepon,
          "faksimili": widget.data.faksimili,
          "alamat": widget.data.alamat,
          "kode_pos": widget.data.kodePos,
          "provinsi": widget.data.provinsi,
          "kota_kabupaten": widget.data.kotaKabupaten,
          "kecamatan": widget.data.kecamatan,
          "desa_kelurahan": widget.data.desaKelurahan,
        },
        files: widget.data.filePaths,
      );

      if (!mounted) return;

      if (success) {
        await _showSuccessPopup();
      } else {
        await _showErrorPopup("Pengajuan gagal dikirim. Silakan coba lagi.");
      }
    } catch (e) {
      if (!mounted) return;

      await _showErrorPopup(e.toString().replaceAll("Exception: ", ""));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ================= PREVIEW FILE =================
  void _openFile(String type, String title) {
    final path = widget.data.filePaths[type];

    if (path == null || path.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfPreviewPage(filePath: path, title: title),
      ),
    );
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
            const SizedBox(height: 12),

            // ================= DATA INSTANSI =================
            _sectionTitle("Informasi Instansi"),
            _item("Nama Domain", widget.data.namaDomain),
            _item("Nama Desa", widget.data.namaDesa),
            _item("Telepon", widget.data.telepon),
            _item("Faksimili", widget.data.faksimili),
            _item("Alamat", widget.data.alamat),

            _item("Provinsi", widget.data.provinsi),
            _item("Kabupaten", widget.data.kotaKabupaten),
            _item("Kecamatan", widget.data.kecamatan),
            _item("Desa/Kelurahan", widget.data.desaKelurahan),

            _item("Kode Pos", widget.data.kodePos),

            const SizedBox(height: 16),

            // ================= DOKUMEN =================
            _sectionTitle("Dokumen Persyaratan"),

            _fileItem(
              "Surat Permohonan",
              widget.data.suratPermohonan,
              "surat_permohonan",
            ),
            _fileItem(
              "Perda Pembentukan Desa",
              widget.data.perdaPembentukanDesa,
              "perda_pembentukan_desa",
            ),
            _fileItem("Surat Kuasa", widget.data.suratKuasa, "surat_kuasa"),
            _fileItem(
              "Surat Penunjukan Pejabat",
              widget.data.suratPenunjukan,
              "surat_penunjukan_pejabat",
            ),
            _fileItem(
              "KTP ASN Pejabat",
              widget.data.ktpAsnPejabat,
              "ktp_asn_pejabat",
            ),
          ],
        ),
      ),
    );
  }

  // ================= UI =================
  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
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
          Expanded(flex: 4, child: Text(label)),
          Expanded(
            flex: 6,
            child: Text(
              value.isEmpty ? "-" : value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileItem(String title, String fileName, String type) {
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
        trailing: isUploaded
            ? IconButton(
                icon: const Icon(Icons.visibility, color: Colors.blue),
                onPressed: () => _openFile(type, title),
              )
            : null,
      ),
    );
  }

  // ================= SUCCESS POPUP =================
  Future<void> _showSuccessPopup() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 70),
                const SizedBox(height: 12),
                const Text(
                  "Berhasil!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Pengajuan domain berhasil dikirim.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const VerifikasiDokumenPage(),
                        ),
                        (route) => false,
                      );
                    },
                    child: const Text("Lanjut"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= ERROR POPUP =================
  Future<void> _showErrorPopup(String message) async {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error, color: Colors.red, size: 70),
                const SizedBox(height: 12),
                const Text(
                  "Gagal!",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Coba Lagi"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
