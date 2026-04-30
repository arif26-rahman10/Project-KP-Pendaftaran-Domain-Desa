import 'package:flutter/material.dart';
import '../../main.dart';
import '../../services/local_auth_service.dart';
import '../../services/api_service.dart';

class InformasiInstansiPage extends StatefulWidget {
  const InformasiInstansiPage({super.key});

  @override
  State<InformasiInstansiPage> createState() => _InformasiInstansiPageState();
}

class _InformasiInstansiPageState extends State<InformasiInstansiPage> {
  final TextEditingController namaDesaController = TextEditingController();
  final TextEditingController namaKepalaDesaController =
      TextEditingController();
  final TextEditingController nipKepalaDesaController = TextEditingController();
  final TextEditingController noHpKepalaDesaController =
      TextEditingController();
  final TextEditingController alamatKantorDesaController =
      TextEditingController();

  bool isLoading = true;
  int? idUser;

  @override
  void initState() {
    super.initState();
    _loadInstitutionData();
  }

  Future<void> _loadInstitutionData() async {
    try {
      final user = await LocalAuthService.getRegisteredUser();
      idUser = int.tryParse(user['id_user'].toString());

      if (idUser == null) {
        if (!mounted) return;
        setState(() => isLoading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('ID user tidak ditemukan. Silakan login ulang.'),
          ),
        );
        return;
      }

      final response = await ApiService.getInstansi(idUser: idUser!);
      final desa = response['desa'];

      if (desa != null) {
        namaDesaController.text = desa['nama_desa']?.toString() ?? '';
        namaKepalaDesaController.text =
            desa['nama_kepala_desa']?.toString() ?? '';
        nipKepalaDesaController.text =
            desa['nip_kepala_desa']?.toString() ?? '';
        noHpKepalaDesaController.text =
            desa['no_hp_kepala_desa']?.toString() ?? '';
        alamatKantorDesaController.text = desa['alamat']?.toString() ?? '';
      }
    } catch (e) {
      debugPrint("LOAD INSTANSI ERROR: $e");
    }

    if (!mounted) return;
    setState(() => isLoading = false);
  }

  @override
  void dispose() {
    namaDesaController.dispose();
    namaKepalaDesaController.dispose();
    nipKepalaDesaController.dispose();
    noHpKepalaDesaController.dispose();
    alamatKantorDesaController.dispose();
    super.dispose();
  }

  Future<void> _simpanPerubahan() async {
    final namaDesa = namaDesaController.text.trim();
    final namaKepalaDesa = namaKepalaDesaController.text.trim();
    final nipKepalaDesa = nipKepalaDesaController.text.trim();
    final noHpKepalaDesa = noHpKepalaDesaController.text.trim();
    final alamatKantorDesa = alamatKantorDesaController.text.trim();

    if (idUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ID user tidak ditemukan. Silakan login ulang.'),
        ),
      );
      return;
    }

    if (namaDesa.isEmpty ||
        namaKepalaDesa.isEmpty ||
        nipKepalaDesa.isEmpty ||
        noHpKepalaDesa.isEmpty ||
        alamatKantorDesa.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua data instansi wajib diisi')),
      );
      return;
    }

    try {
      await ApiService.updateInstansi(
        idUser: idUser!,
        namaDesa: namaDesa,
        namaKepalaDesa: namaKepalaDesa,
        nipKepalaDesa: nipKepalaDesa,
        noHpKepalaDesa: noHpKepalaDesa,
        alamat: alamatKantorDesa,
      );

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("UPDATE INSTANSI ERROR: $e");

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal menyimpan data: $e')));
    }
  }

  Widget _instansiField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: const TextStyle(fontSize: 13, color: Colors.black87),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide(color: Colors.grey.shade500),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: kPrimary),
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final topSafe = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: kBg,
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(12, topSafe + 8, 12, 12),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFE01925), Color(0xFF7F1118)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                const Text(
                  'Informasi Instansi',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 26, 24, 24),
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.person,
                                size: 62,
                                color: Colors.grey.shade500,
                              ),
                            ),
                            Positioned(
                              right: -2,
                              bottom: 6,
                              child: Container(
                                width: 24,
                                height: 24,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(1.5),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.fromBorderSide(
                                      BorderSide(color: kPrimary, width: 2),
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    size: 16,
                                    color: kPrimary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 26),
                        _instansiField(
                          label: 'Nama Desa',
                          controller: namaDesaController,
                        ),
                        _instansiField(
                          label: 'Nama Kepala Desa',
                          controller: namaKepalaDesaController,
                        ),
                        _instansiField(
                          label: 'NIP Kepala Desa',
                          controller: nipKepalaDesaController,
                          keyboardType: TextInputType.number,
                        ),
                        _instansiField(
                          label: 'No HP Kepala Desa',
                          controller: noHpKepalaDesaController,
                          keyboardType: TextInputType.phone,
                        ),
                        _instansiField(
                          label: 'Alamat Kantor Desa',
                          controller: alamatKantorDesaController,
                        ),
                        const SizedBox(height: 6),
                        SizedBox(
                          width: double.infinity,
                          height: 42,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimary,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _simpanPerubahan,
                            child: const Text(
                              'Simpan Perubahan',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
