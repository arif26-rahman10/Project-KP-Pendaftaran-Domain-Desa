import 'package:flutter/material.dart';
import '../../services/registration_data.dart';
import '../../widgets/step_form_layout.dart';
import 'step3_persyaratan_domain.dart';

class Step2InformasiInstansi extends StatefulWidget {
  final RegistrationData data;

  const Step2InformasiInstansi({super.key, required this.data});

  @override
  State<Step2InformasiInstansi> createState() => _Step2InformasiInstansiState();
}

class _Step2InformasiInstansiState extends State<Step2InformasiInstansi> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController namaDesaController;
  late final TextEditingController teleponController;
  late final TextEditingController alamatController;
  late final TextEditingController kodePosController;
  late final TextEditingController faksimiliController;

  String? selectedProvinsi;
  String? selectedKabupaten;
  String? selectedKecamatan;
  String? selectedDesa;

  // ================= DATA WILAYAH =================
  final Map<String, dynamic> addressData = {
    "Riau": {
      "Bengkalis": {
        "Bengkalis": [
          "Air Putih",
          "Damai",
          "Kelapapati",
          "Kelebuk",
          "Kelemantan",
          "Kelemantan Barat",
        ],
        "Mandau": ["Duri", "Balik Alam", "Pematang Pudu", "Guntung"],
      },
      "Pekanbaru": {
        "Sukajadi": ["Sukajadi", "Paledang"],
        "Rumbai": ["Umban Sari", "Sri Meranti"],
      },
    },
  };

  List<String> provinsiList = [];
  List<String> kabupatenList = [];
  List<String> kecamatanList = [];
  List<String> desaList = [];

  @override
  void initState() {
    super.initState();

    namaDesaController = TextEditingController(text: widget.data.namaDesa);
    teleponController = TextEditingController(text: widget.data.telepon);
    alamatController = TextEditingController(text: widget.data.alamat);
    kodePosController = TextEditingController(text: widget.data.kodePos);
    faksimiliController = TextEditingController(text: widget.data.faksimili);

    provinsiList = addressData.keys.toList();
  }

  @override
  void dispose() {
    namaDesaController.dispose();
    teleponController.dispose();
    alamatController.dispose();
    kodePosController.dispose();
    faksimiliController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      widget.data.namaDesa = namaDesaController.text.trim();
      widget.data.telepon = teleponController.text.trim();
      widget.data.alamat = alamatController.text.trim();
      widget.data.kodePos = kodePosController.text.trim();
      widget.data.faksimili = faksimiliController.text.trim();

      widget.data.provinsi = selectedProvinsi ?? '';
      widget.data.kotaKabupaten = selectedKabupaten ?? '';
      widget.data.kecamatan = selectedKecamatan ?? '';
      widget.data.desaKelurahan = selectedDesa ?? '';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => Step3PersyaratanDomain(data: widget.data),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StepFormLayout(
      activeStep: 1,
      onBack: () => Navigator.pop(context),
      onNext: _nextStep,
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _input(namaDesaController, "Nama Desa", true),
              _input(
                teleponController,
                "Telepon",
                true,
                keyboardType: TextInputType.phone,
              ),
              _input(faksimiliController, "Faksimili", false),
              _input(alamatController, "Alamat", true, maxLines: 3),

              // ================= PROVINSI =================
              _dropdown(
                label: "Provinsi",
                value: selectedProvinsi,
                items: provinsiList,
                onChanged: (v) {
                  setState(() {
                    selectedProvinsi = v;
                    selectedKabupaten = null;
                    selectedKecamatan = null;
                    selectedDesa = null;

                    kabupatenList = (addressData[v] as Map<String, dynamic>)
                        .keys
                        .toList();

                    kecamatanList = [];
                    desaList = [];
                  });
                },
              ),

              // ================= KABUPATEN =================
              _dropdown(
                label: "Kabupaten",
                value: selectedKabupaten,
                items: kabupatenList,
                onChanged: (v) {
                  setState(() {
                    selectedKabupaten = v;
                    selectedKecamatan = null;
                    selectedDesa = null;

                    kecamatanList =
                        (addressData[selectedProvinsi]![v]
                                as Map<String, dynamic>)
                            .keys
                            .toList();

                    desaList = [];
                  });
                },
              ),

              // ================= KECAMATAN =================
              _dropdown(
                label: "Kecamatan",
                value: selectedKecamatan,
                items: kecamatanList,
                onChanged: (v) {
                  setState(() {
                    selectedKecamatan = v;
                    selectedDesa = null;

                    desaList = List<String>.from(
                      addressData[selectedProvinsi]![selectedKabupaten]![v],
                    );
                  });
                },
              ),

              // ================= DESA =================
              _dropdown(
                label: "Desa / Kelurahan",
                value: selectedDesa,
                items: desaList,
                onChanged: (v) {
                  setState(() {
                    selectedDesa = v;
                  });
                },
              ),

              _input(
                kodePosController,
                "Kode Pos",
                true,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= INPUT =================
  Widget _input(
    TextEditingController controller,
    String label,
    bool required, {
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black),
              children: required
                  ? const [
                      TextSpan(
                        text: ' *',
                        style: TextStyle(color: Colors.red),
                      ),
                    ]
                  : [],
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) {
          if (required && (v == null || v.isEmpty)) {
            return 'Wajib diisi';
          }
          return null;
        },
      ),
    );
  }

  // ================= DROPDOWN =================
  Widget _dropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          label: RichText(
            text: TextSpan(
              text: label,
              style: const TextStyle(color: Colors.black),
              children: const [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        validator: (v) => v == null || v.isEmpty ? 'Wajib dipilih' : null,
      ),
    );
  }
}
