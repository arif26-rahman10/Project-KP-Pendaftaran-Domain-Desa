import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../data/verifikasi_dokumen_data.dart';

class DetailVerifikasiDokumenPage extends StatefulWidget {
  final int id;
  final String status;

  const DetailVerifikasiDokumenPage({
    super.key,
    required this.id,
    required this.status,
  });

  @override
  State<DetailVerifikasiDokumenPage> createState() =>
      _DetailVerifikasiDokumenPageState();
}

class _DetailVerifikasiDokumenPageState
    extends State<DetailVerifikasiDokumenPage> {
  final TextEditingController namaOrganisasiController = TextEditingController(
    text: 'Pemerintah Desa XXX',
  );
  final TextEditingController teleponController = TextEditingController(
    text: '081234567890',
  );
  final TextEditingController faksimiliController = TextEditingController(
    text: '-',
  );
  final TextEditingController alamatController = TextEditingController(
    text: 'Jl. Kelapapati',
  );
  final TextEditingController kodePosController = TextEditingController(
    text: '27011',
  );
  final TextEditingController deskripsiController = TextEditingController();

  String klasifikasiInstansi = 'KELURAHAN/DESA';
  String provinsi = 'Riau';
  String kotaKabupaten = 'Bengkallis';
  String kecamatan = 'Bengkalis';
  String desaKelurahan = 'Kelapapati';
  String masaBerlaku = '1 Tahun (Rp 50,000)';

  String suratPermohonan = 'Upload Dokumen.pdf';
  String suratKuasa = 'Upload Dokumen.pdf';
  String suratPenunjukan = 'Upload Dokumen.pdf';
  String kartuPegawai = 'Upload Dokumen.pdf';
  String dasarHukum = 'Upload Dokumen.pdf';

  late String currentStatus;

  bool get showEditIcon =>
      currentStatus == 'Draft' || currentStatus == 'Perlu Perbaikan';

  bool get showKirimButton =>
      currentStatus == 'Draft' || currentStatus == 'Perlu Perbaikan';

  @override
  void initState() {
    super.initState();
    currentStatus = widget.status;
  }

  @override
  void dispose() {
    namaOrganisasiController.dispose();
    teleponController.dispose();
    faksimiliController.dispose();
    alamatController.dispose();
    kodePosController.dispose();
    deskripsiController.dispose();
    super.dispose();
  }

  Future<void> _pickFile(String type) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
    );

    if (result != null) {
      final fileName = result.files.single.name;

      setState(() {
        if (type == 'permohonan') {
          suratPermohonan = fileName;
        } else if (type == 'kuasa') {
          suratKuasa = fileName;
        } else if (type == 'penunjukan') {
          suratPenunjukan = fileName;
        } else if (type == 'pegawai') {
          kartuPegawai = fileName;
        } else if (type == 'hukum') {
          dasarHukum = fileName;
        }
      });
    }
  }

  Color _statusColor() {
    switch (currentStatus) {
      case 'Disetujui':
        return const Color(0xFF69C17A);
      case 'Ditinjau':
        return const Color(0xFFF59B23);
      case 'Perlu Perbaikan':
        return const Color(0xFFE8262A);
      case 'Draft':
        return const Color(0xFF32485B);
      default:
        return Colors.grey;
    }
  }

  double _statusWidth() {
    switch (currentStatus) {
      case 'Disetujui':
        return 92;
      case 'Ditinjau':
        return 88;
      case 'Perlu Perbaikan':
        return 126;
      case 'Draft':
        return 74;
      default:
        return 80;
    }
  }

  Widget _statusBadge() {
    if (currentStatus == 'Disetujui') {
      return Container(
        width: _statusWidth(),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: _statusColor(),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 13),
            SizedBox(width: 4),
            Text(
              'Disetujui',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return Container(
      width: _statusWidth(),
      padding: const EdgeInsets.symmetric(vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: _statusColor(),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        currentStatus,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _customField({
    required String label,
    required TextEditingController controller,
    bool requiredField = false,
    String? hint,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: requiredField
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kPrimary),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _customDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    bool requiredField = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              children: requiredField
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]
                  : [],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items
                    .map(
                      (item) => DropdownMenuItem<String>(
                        value: item,
                        child: Text(item, style: const TextStyle(fontSize: 14)),
                      ),
                    )
                    .toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _fileField({
    required String label,
    required String fileName,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    child: Text(
                      fileName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onTap,
                  child: const Text(
                    'Pilih File',
                    style: TextStyle(
                      color: kPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusTable() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: Color(0xFFAF252B),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
          child: const Text(
            'Status Verifikasi Dokumen',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                const Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Text(
                      'Status',
                      style: TextStyle(color: Color(0xFF4B5BD7), fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: _statusBadge(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _submitDokumen() {
    VerifikasiDokumenData.updateStatus(widget.id, 'Ditinjau');

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16, topSafe + 10, 16, 14),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE01925), Color(0xFF861018)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Verifikasi Dokumen',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Detail Dokumen',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      if (showEditIcon)
                        const Icon(
                          Icons.edit_outlined,
                          color: Color(0xFF4C2E2E),
                          size: 26,
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _statusTable(),
                  const SizedBox(height: 18),
                  _sectionTitle('Informasi Instansi'),
                  _customField(
                    label: 'Nama Organisasi',
                    controller: namaOrganisasiController,
                  ),
                  _customDropdown(
                    label: 'Klasifikasi Instansi',
                    value: klasifikasiInstansi,
                    items: const ['KELURAHAN/DESA'],
                    onChanged: (value) {
                      setState(() {
                        klasifikasiInstansi = value!;
                      });
                    },
                  ),
                  _customField(label: 'Telepon', controller: teleponController),
                  _customField(
                    label: 'Faksimili',
                    controller: faksimiliController,
                  ),
                  _customField(label: 'Alamat', controller: alamatController),
                  _customDropdown(
                    label: 'Provinsi',
                    value: provinsi,
                    requiredField: true,
                    items: const ['Riau'],
                    onChanged: (value) {
                      setState(() {
                        provinsi = value!;
                      });
                    },
                  ),
                  _customDropdown(
                    label: 'Kota/Kabupaten',
                    value: kotaKabupaten,
                    requiredField: true,
                    items: const ['Bengkallis'],
                    onChanged: (value) {
                      setState(() {
                        kotaKabupaten = value!;
                      });
                    },
                  ),
                  _customDropdown(
                    label: 'Kecamatan',
                    value: kecamatan,
                    items: const ['Bengkalis'],
                    onChanged: (value) {
                      setState(() {
                        kecamatan = value!;
                      });
                    },
                  ),
                  _customDropdown(
                    label: 'Desa / Kelurahan',
                    value: desaKelurahan,
                    items: const ['Kelapapati'],
                    onChanged: (value) {
                      setState(() {
                        desaKelurahan = value!;
                      });
                    },
                  ),
                  _customField(
                    label: 'Kode Pos',
                    controller: kodePosController,
                  ),
                  const SizedBox(height: 6),
                  _sectionTitle('Persyaratan Domain'),
                  _customDropdown(
                    label: 'Masa Berlaku',
                    value: masaBerlaku,
                    items: const ['1 Tahun (Rp 50,000)'],
                    onChanged: (value) {
                      setState(() {
                        masaBerlaku = value!;
                      });
                    },
                  ),
                  _customField(
                    label: 'Deskripsi',
                    controller: deskripsiController,
                  ),
                  _fileField(
                    label: 'Surat Permohonan',
                    fileName: suratPermohonan,
                    onTap: () => _pickFile('permohonan'),
                  ),
                  _fileField(
                    label: 'Surat Kuasa',
                    fileName: suratKuasa,
                    onTap: () => _pickFile('kuasa'),
                  ),
                  _fileField(
                    label: 'Surat Penunjukan Jabatan',
                    fileName: suratPenunjukan,
                    onTap: () => _pickFile('penunjukan'),
                  ),
                  _fileField(
                    label: 'Kartu Pegawai',
                    fileName: kartuPegawai,
                    onTap: () => _pickFile('pegawai'),
                  ),
                  _fileField(
                    label: 'Dasar Hukum Pembentukan Desa',
                    fileName: dasarHukum,
                    onTap: () => _pickFile('hukum'),
                  ),
                  if (showKirimButton) ...[
                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerRight,
                      child: SizedBox(
                        width: 110,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFAF252B),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: _submitDokumen,
                          child: const Text(
                            'Kirim',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
