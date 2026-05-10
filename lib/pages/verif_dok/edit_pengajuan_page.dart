import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../models/pengajuan_model.dart';
import '../../services/pengajuan_service.dart';

class EditPengajuanPage extends StatefulWidget {
  final Pengajuan data;

  const EditPengajuanPage({super.key, required this.data});

  @override
  State<EditPengajuanPage> createState() => _EditPengajuanPageState();
}

class _EditPengajuanPageState extends State<EditPengajuanPage> {
  late TextEditingController domainController;
  late TextEditingController namaDesaController;
  late TextEditingController teleponController;
  late TextEditingController faksimiliController;
  late TextEditingController alamatController;
  late TextEditingController provinsiController;
  late TextEditingController kabupatenController;
  late TextEditingController kecamatanController;
  late TextEditingController desaKelurahanController;
  late TextEditingController kodePosController;

  bool isLoading = false;

  final Map<String, String> filePaths = {};
  final Map<String, String> fileNames = {};

  @override
  void initState() {
    super.initState();

    domainController = TextEditingController(text: widget.data.domain);
    namaDesaController = TextEditingController(text: widget.data.namaDesa);
    teleponController = TextEditingController(text: widget.data.telepon);
    faksimiliController = TextEditingController(text: widget.data.faksimili);
    alamatController = TextEditingController(text: widget.data.alamat);
    provinsiController = TextEditingController(text: widget.data.provinsi);
    kabupatenController = TextEditingController(
      text: widget.data.kotaKabupaten,
    );
    kecamatanController = TextEditingController(text: widget.data.kecamatan);
    desaKelurahanController = TextEditingController(
      text: widget.data.desaKelurahan,
    );
    kodePosController = TextEditingController(text: widget.data.kodePos);
  }

  @override
  void dispose() {
    domainController.dispose();
    namaDesaController.dispose();
    teleponController.dispose();
    faksimiliController.dispose();
    alamatController.dispose();
    provinsiController.dispose();
    kabupatenController.dispose();
    kecamatanController.dispose();
    desaKelurahanController.dispose();
    kodePosController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(String key) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        filePaths[key] = result.files.single.path!;
        fileNames[key] = result.files.single.name;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.green,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.warning, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _simpanPerbaikan() async {
    if (domainController.text.trim().isEmpty ||
        namaDesaController.text.trim().isEmpty ||
        teleponController.text.trim().isEmpty ||
        alamatController.text.trim().isEmpty ||
        provinsiController.text.trim().isEmpty ||
        kabupatenController.text.trim().isEmpty ||
        kecamatanController.text.trim().isEmpty ||
        desaKelurahanController.text.trim().isEmpty ||
        kodePosController.text.trim().isEmpty) {
      _showErrorSnackBar('Data wajib tidak boleh kosong');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await PengajuanService().updatePengajuan(
        id: widget.data.id,
        domain: domainController.text.trim(),
        namaDesa: namaDesaController.text.trim(),
        telepon: teleponController.text.trim(),
        faksimili: faksimiliController.text.trim(),
        alamat: alamatController.text.trim(),
        provinsi: provinsiController.text.trim(),
        kotaKabupaten: kabupatenController.text.trim(),
        kecamatan: kecamatanController.text.trim(),
        desaKelurahan: desaKelurahanController.text.trim(),
        kodePos: kodePosController.text.trim(),
        files: filePaths,
      );

      if (!mounted) return;

      _showSuccessSnackBar('Perbaikan pengajuan berhasil dikirim');

      await Future.delayed(const Duration(milliseconds: 1200));

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      _showErrorSnackBar('Gagal menyimpan: $e');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _fileCard(String title, String key) {
    final newFile = fileNames[key];
    final oldFileAvailable = widget.data.dokumenUrls[key] != null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F2FA),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            newFile != null || oldFileAvailable
                ? Icons.check_circle
                : Icons.warning,
            color: newFile != null || oldFileAvailable
                ? Colors.green
                : Colors.orange,
            size: 30,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  newFile ??
                      (oldFileAvailable
                          ? 'File lama masih digunakan'
                          : 'Belum ada file'),
                  style: const TextStyle(fontSize: 13, color: Colors.black54),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.upload_file, color: Colors.blue),
            onPressed: () => _pickFile(key),
          ),
        ],
      ),
    );
  }

  Widget _editHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Perbaikan Pengajuan',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'Silakan perbaiki data sesuai catatan admin.',
          style: TextStyle(fontSize: 14, color: Colors.black54),
        ),
        SizedBox(height: 18),
        Divider(),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text('Edit Pengajuan'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _editHeader(),

            if (widget.data.catatanUmum.isNotEmpty)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 18),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Catatan Admin',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(widget.data.catatanUmum),
                  ],
                ),
              ),

            const Text(
              'Informasi Instansi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            _field(label: 'Nama Domain', controller: domainController),
            _field(label: 'Nama Desa', controller: namaDesaController),
            _field(
              label: 'Telepon',
              controller: teleponController,
              keyboardType: TextInputType.phone,
            ),
            _field(label: 'Faksimili', controller: faksimiliController),
            _field(label: 'Alamat', controller: alamatController, maxLines: 3),
            _field(label: 'Provinsi', controller: provinsiController),
            _field(label: 'Kabupaten', controller: kabupatenController),
            _field(label: 'Kecamatan', controller: kecamatanController),
            _field(
              label: 'Desa / Kelurahan',
              controller: desaKelurahanController,
            ),
            _field(
              label: 'Kode Pos',
              controller: kodePosController,
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            const Text(
              'Dokumen Persyaratan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 14),

            _fileCard('Surat Permohonan', 'surat_permohonan'),
            _fileCard('Perda Pembentukan Desa', 'perda_pembentukan_desa'),
            _fileCard('Surat Kuasa', 'surat_kuasa'),
            _fileCard('Surat Penunjukan Pejabat', 'surat_penunjukan_pejabat'),
            _fileCard('KTP ASN Pejabat', 'ktp_asn_pejabat'),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isLoading ? null : _simpanPerbaikan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.red.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Kirim Perbaikan',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
