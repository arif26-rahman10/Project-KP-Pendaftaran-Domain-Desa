import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../../services/pengajuan_service.dart';
import '../verif_dok/verifikasi_dokumen_page.dart';

class PendaftaranDomainPage extends StatefulWidget {
  const PendaftaranDomainPage({super.key});

  @override
  State<PendaftaranDomainPage> createState() => _PendaftaranDomainPageState();
}

class _PendaftaranDomainPageState extends State<PendaftaranDomainPage> {
  int currentStep = 1;

  final namaDomainController = TextEditingController();
  final namaOrganisasiController = TextEditingController();
  final teleponController = TextEditingController();
  final faksimiliController = TextEditingController();
  final alamatController = TextEditingController();
  final kodePosController = TextEditingController();

  String provinsi = 'Riau';
  String kotaKabupaten = 'Bengkalis';
  String kecamatan = 'Bengkalis';
  String desaKelurahan = 'Kelapapati';

  bool isChecking = false;
  String statusDomain = '';

  bool isLoading = false;

  Map<String, String> filePaths = {};

  String suratPermohonan = 'Upload Dokumen.pdf';
  String suratKuasa = 'Upload Dokumen.pdf';
  String suratPenunjukan = 'Upload Dokumen.pdf';
  String kartuPegawai = 'Upload Dokumen.pdf';
  String dasarHukum = 'Upload Dokumen.pdf';

  final service = PengajuanService();

  // ================= FILE PICKER =================
  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      final file = result.files.single;

      if (file.size > 1024 * 1024) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('File maksimal 1MB')));
        return;
      }

      setState(() {
        filePaths[type] = file.path!;

        if (type == 'permohonan') suratPermohonan = file.name;
        if (type == 'kuasa') suratKuasa = file.name;
        if (type == 'penunjukan') suratPenunjukan = file.name;
        if (type == 'pegawai') kartuPegawai = file.name;
        if (type == 'hukum') dasarHukum = file.name;
      });
    }
  }

  // ================= CHECK DOMAIN =================
  void _checkDomain() async {
    setState(() => isChecking = true);

    bool available = await service.checkDomain(namaDomainController.text);

    setState(() {
      statusDomain = available ? 'Tersedia' : 'Tidak tersedia';
      isChecking = false;
    });
  }

  // ================= SUBMIT =================
  void _submit() async {
    setState(() => isLoading = true);

    final success = await service.submitPengajuan(
      domain: namaDomainController.text,
      data: {
        "nama_desa": namaOrganisasiController.text,
        "telepon": teleponController.text,
        "faksimili": faksimiliController.text,
        "alamat": alamatController.text,
        "provinsi": provinsi,
        "kota_kabupaten": kotaKabupaten,
        "kecamatan": kecamatan,
        "desa_kelurahan": desaKelurahan,
        "kode_pos": kodePosController.text,
      },
      files: filePaths,
    );

    setState(() => isLoading = false);

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pengajuan berhasil')));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const VerifikasiDokumenPage()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal kirim pengajuan')));
    }
  }

  // ================= UI STEP 1 =================
  Widget _stepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Cari Nama Domain'),
        const SizedBox(height: 10),

        TextField(
          controller: namaDomainController,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Nama Domain',
          ),
        ),

        const SizedBox(height: 10),

        ElevatedButton(
          onPressed: isChecking ? null : _checkDomain,
          child: isChecking
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Cek Domain'),
        ),

        if (statusDomain.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              children: [
                Icon(
                  statusDomain == 'Tersedia'
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: statusDomain == 'Tersedia' ? Colors.green : Colors.red,
                ),
                const SizedBox(width: 6),
                Text(
                  "${namaDomainController.text}.desa.id $statusDomain",
                  style: TextStyle(
                    color: statusDomain == 'Tersedia'
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
              ],
            ),
          ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: statusDomain == 'Tersedia'
              ? () => setState(() => currentStep = 2)
              : null,
          child: const Text('Daftar'),
        ),
      ],
    );
  }

  // ================= UI STEP 2 =================
  Widget _stepTwo() {
    return Column(
      children: [
        TextField(
          controller: namaOrganisasiController,
          decoration: const InputDecoration(labelText: 'Nama Organisasi'),
        ),
        TextField(
          controller: teleponController,
          decoration: const InputDecoration(labelText: 'Telepon'),
        ),
        TextField(
          controller: alamatController,
          decoration: const InputDecoration(labelText: 'Alamat'),
        ),
        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () => setState(() => currentStep = 3),
          child: const Text('Next'),
        ),
      ],
    );
  }

  // ================= UI STEP 3 =================
  Widget _stepThree() {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _pickFile('permohonan'),
          child: Text(suratPermohonan),
        ),
        ElevatedButton(
          onPressed: () => _pickFile('kuasa'),
          child: Text(suratKuasa),
        ),
        ElevatedButton(
          onPressed: () => _pickFile('penunjukan'),
          child: Text(suratPenunjukan),
        ),
        ElevatedButton(
          onPressed: () => _pickFile('pegawai'),
          child: Text(kartuPegawai),
        ),
        ElevatedButton(
          onPressed: () => _pickFile('hukum'),
          child: Text(dasarHukum),
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () => setState(() => currentStep = 4),
          child: const Text('Next'),
        ),
      ],
    );
  }

  // ================= UI STEP 4 =================
  Widget _stepFour() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Domain: ${namaDomainController.text}.desa.id"),
        Text("Organisasi: ${namaOrganisasiController.text}"),
        Text("Telepon: ${teleponController.text}"),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: isLoading ? null : _submit,
          child: isLoading
              ? const CircularProgressIndicator()
              : const Text('Kirim'),
        ),
      ],
    );
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 1:
        return _stepOne();
      case 2:
        return _stepTwo();
      case 3:
        return _stepThree();
      default:
        return _stepFour();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: const Text('Pendaftaran Domain')),
          body: Padding(padding: const EdgeInsets.all(16), child: _buildStep()),
        ),

        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.3),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
