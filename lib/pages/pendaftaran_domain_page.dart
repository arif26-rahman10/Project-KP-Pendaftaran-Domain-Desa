import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'verifikasi_dokumen_page.dart';

class PendaftaranDomainPage extends StatefulWidget {
  const PendaftaranDomainPage({super.key});

  @override
  State<PendaftaranDomainPage> createState() => _PendaftaranDomainPageState();
}

class _PendaftaranDomainPageState extends State<PendaftaranDomainPage> {
  int currentStep = 1;

  final TextEditingController namaDomainController = TextEditingController();

  final TextEditingController namaOrganisasiController = TextEditingController(
    text: 'Pemerintah Desa XXX',
  );
  final TextEditingController teleponController = TextEditingController(
    text: '081234567890',
  );
  final TextEditingController faksimiliController = TextEditingController();
  final TextEditingController alamatController = TextEditingController(
    text: 'Jl. Kelapapati',
  );
  final TextEditingController kodePosController = TextEditingController(
    text: 'Pemerintah Desa xxx',
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

  @override
  void dispose() {
    namaDomainController.dispose();
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

  void _nextStep() {
    if (currentStep < 4) {
      setState(() {
        currentStep++;
      });
    }
  }

  void _prevStep() {
    if (currentStep > 1) {
      setState(() {
        currentStep--;
      });
    }
  }

  Widget _buildHeader(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    return Container(
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
            child: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          const Text(
            'Pendaftaran Domain',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daftar Nama Domain',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 18),
        _stepRow(1, 'Cari Nama Domain'),
        const SizedBox(height: 12),
        _stepRow(2, 'Informasi Instansi'),
        const SizedBox(height: 12),
        _stepRow(3, 'Persyaratan Domain'),
        const SizedBox(height: 12),
        _stepRow(4, 'Pratinjau'),
        const SizedBox(height: 18),
        Container(height: 1.2, color: Colors.grey.shade400),
      ],
    );
  }

  Widget _stepRow(int step, String title) {
    final bool active = currentStep >= step;
    final Color circleColor = active
        ? const Color(0xFFAF252B)
        : const Color(0xFFE5BFC3);

    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          alignment: Alignment.center,
          decoration: BoxDecoration(color: circleColor, shape: BoxShape.circle),
          child: Text(
            '$step',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Text(
          title,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
      ],
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

  Widget _bottomButtons({
    required String leftText,
    required String rightText,
    required VoidCallback onLeftTap,
    required VoidCallback onRightTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAF252B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onLeftTap,
                child: Text(
                  leftText,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              height: 42,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFAF252B),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: onRightTap,
                child: Text(
                  rightText,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableBox({
    required String title,
    required List<Map<String, String>> rows,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: Column(
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
            child: Text(
              title,
              style: const TextStyle(
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
            child: Column(
              children: rows.map((row) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            row['label'] ?? '',
                            style: const TextStyle(
                              color: Color(0xFF4B5BD7),
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Text(
                            row['value'] ?? '',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stepOne() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Cari Nama Domain'),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.shade400),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: namaDomainController,
                  decoration: InputDecoration(
                    hintText: 'Nama Domain',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              Container(height: 22, width: 1, color: Colors.grey.shade300),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  '.desa.id',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: RichText(
                text: const TextSpan(
                  text: 'xxxx.desa.id ',
                  style: TextStyle(color: Colors.grey, fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'Tersedia',
                      style: TextStyle(
                        color: Color(0xFF4B5BD7),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 118,
              height: 38,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: _nextStep,
                child: const Text(
                  'Daftar',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _stepTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Informasi'),
        _customField(
          label: 'Nama Organisasi',
          controller: namaOrganisasiController,
          requiredField: true,
        ),
        _customDropdown(
          label: 'Klasifikasi Instansi',
          value: klasifikasiInstansi,
          items: const ['KELURAHAN/DESA'],
          requiredField: true,
          onChanged: (value) {
            setState(() {
              klasifikasiInstansi = value!;
            });
          },
        ),
        _customField(
          label: 'Telepon',
          controller: teleponController,
          requiredField: true,
        ),
        _customField(
          label: 'Faksimili',
          controller: faksimiliController,
          hint: 'Faksimili',
        ),
        _customField(
          label: 'Alamat',
          controller: alamatController,
          requiredField: true,
        ),
        _customDropdown(
          label: 'Provinsi',
          value: provinsi,
          items: const ['Riau'],
          requiredField: true,
          onChanged: (value) {
            setState(() {
              provinsi = value!;
            });
          },
        ),
        _customDropdown(
          label: 'Kota/Kabupaten',
          value: kotaKabupaten,
          items: const ['Bengkallis'],
          requiredField: true,
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
          requiredField: true,
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
          requiredField: true,
          onChanged: (value) {
            setState(() {
              desaKelurahan = value!;
            });
          },
        ),
        _customField(
          label: 'Kode Pos',
          controller: kodePosController,
          requiredField: true,
        ),
        _bottomButtons(
          leftText: '< Kembali',
          rightText: 'Berikutnya >',
          onLeftTap: _prevStep,
          onRightTap: _nextStep,
        ),
      ],
    );
  }

  Widget _stepThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Persyaratan Domain'),
        _customDropdown(
          label: 'Masa Berlaku',
          value: masaBerlaku,
          items: const ['1 Tahun (Rp 50,000)'],
          requiredField: true,
          onChanged: (value) {
            setState(() {
              masaBerlaku = value!;
            });
          },
        ),
        _customField(label: 'Deskripsi', controller: deskripsiController),
        _fileField(
          label: 'Surat Permohonan',
          fileName: suratPermohonan,
          requiredField: true,
          onTap: () => _pickFile('permohonan'),
        ),
        _fileField(
          label: 'Surat Kuasa',
          fileName: suratKuasa,
          requiredField: true,
          onTap: () => _pickFile('kuasa'),
        ),
        _fileField(
          label: 'Surat Penunjukan Jabatan',
          fileName: suratPenunjukan,
          requiredField: true,
          onTap: () => _pickFile('penunjukan'),
        ),
        _fileField(
          label: 'Kartu Pegawai',
          fileName: kartuPegawai,
          requiredField: true,
          onTap: () => _pickFile('pegawai'),
        ),
        _fileField(
          label: 'Dasar Hukum Pembentukan Desa',
          fileName: dasarHukum,
          requiredField: true,
          onTap: () => _pickFile('hukum'),
        ),
        const SizedBox(height: 6),
        const Text(
          '• Wajib Diisi.\n• Semua dokumen yang diunggah harus format png,\n  jpg, atau pdf. (Max 1024KB setiap dokumen.)',
          style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.35),
        ),
        _bottomButtons(
          leftText: '< Kembali',
          rightText: 'Berikutnya >',
          onLeftTap: _prevStep,
          onRightTap: _nextStep,
        ),
      ],
    );
  }

  Widget _stepFour() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle('Persyaratan Domain'),
        _tableBox(
          title: 'Informasi Instansi',
          rows: [
            {'label': 'Nama Organisasi', 'value': 'Desa Kelapapati'},
            {'label': 'Klasifikasi Instansi', 'value': klasifikasiInstansi},
            {'label': 'Nama Instansi', 'value': 'Kelapapati'},
            {'label': 'Telepon', 'value': teleponController.text},
            {'label': 'Faksimili', 'value': '-'},
            {'label': 'Email Registran', 'value': '081234567890'},
            {'label': 'Tanggal Pembuatan', 'value': '09 Maret 2026'},
            {'label': 'Provinsi', 'value': provinsi},
            {'label': 'Kota/Kabupaten', 'value': kotaKabupaten},
            {'label': 'Kecamatan', 'value': kecamatan},
            {'label': 'Desa / Kelurahan', 'value': desaKelurahan},
            {'label': 'Kode Pos', 'value': '28711'},
            {'label': 'Alamat', 'value': 'Jl. Kelapapati Tengah'},
          ],
        ),
        _tableBox(
          title: 'Informasi Domain',
          rows: [
            {'label': 'Nama Domain', 'value': 'xxx.desa.id'},
            {'label': 'Masa Aktif', 'value': '1 Tahun Rp.50.000'},
          ],
        ),
        _tableBox(
          title: 'Dokumen Persyaratan',
          rows: [
            {'label': 'Surat Permohonan', 'value': '01-doc.pdf'},
            {'label': 'Surat Kuasa', 'value': '02-doc.pdf'},
            {'label': 'Kartu Pegawai', 'value': '03-doc.pdf'},
            {'label': 'Dasar Hukum\nPembentukan Desa', 'value': '04-doc.pdf'},
            {'label': 'Surat Penunjukan\nPejabat', 'value': '05-doc.pdf'},
          ],
        ),
        _bottomButtons(
          leftText: '< Kembali',
          rightText: 'Kirim',
          onLeftTap: _prevStep,
          onRightTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const VerifikasiDokumenPage()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCurrentStep() {
    if (currentStep == 1) return _stepOne();
    if (currentStep == 2) return _stepTwo();
    if (currentStep == 3) return _stepThree();
    return _stepFour();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F3F3),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStepper(),
                  const SizedBox(height: 16),
                  _buildCurrentStep(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
