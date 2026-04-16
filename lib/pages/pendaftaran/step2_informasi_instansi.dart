import 'package:flutter/material.dart';
import '../../services/registration_data.dart';
import '../../widgets/step_form_layout.dart';
import 'step3_persyaratan_domain.dart';

class Step2InformasiInstansi extends StatefulWidget {
  final RegistrationData data;

  const Step2InformasiInstansi({
    super.key,
    required this.data,
  });

  @override
  State<Step2InformasiInstansi> createState() => _Step2InformasiInstansiState();
}

class _Step2InformasiInstansiState extends State<Step2InformasiInstansi> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController namaDesaController;
  late final TextEditingController kepalaDesaController;
  late final TextEditingController teleponController;
  late final TextEditingController alamatController;
  late final TextEditingController kodePosController;
  late final TextEditingController faksimiliController;

  String? selectedProvinsi;
  String? selectedKabupaten;
  String? selectedKecamatan;

  @override
  void initState() {
    super.initState();

    namaDesaController = TextEditingController(text: widget.data.namaDesa);
    kepalaDesaController = TextEditingController(
      text: widget.data.namaKepalaDesa,
    );
    teleponController = TextEditingController(text: widget.data.telepon);
    alamatController = TextEditingController(text: widget.data.alamat);
    kodePosController = TextEditingController(text: widget.data.kodePos);
    faksimiliController = TextEditingController(text: widget.data.faksimili);

    selectedProvinsi =
        widget.data.provinsi.isNotEmpty ? widget.data.provinsi : null;
    selectedKabupaten = widget.data.kotaKabupaten.isNotEmpty
        ? widget.data.kotaKabupaten
        : null;
    selectedKecamatan =
        widget.data.kecamatan.isNotEmpty ? widget.data.kecamatan : null;
  }

  @override
  void dispose() {
    namaDesaController.dispose();
    kepalaDesaController.dispose();
    teleponController.dispose();
    alamatController.dispose();
    kodePosController.dispose();
    faksimiliController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      widget.data.namaDesa = namaDesaController.text.trim();
      widget.data.namaKepalaDesa = kepalaDesaController.text.trim();
      widget.data.telepon = teleponController.text.trim();
      widget.data.alamat = alamatController.text.trim();
      widget.data.kodePos = kodePosController.text.trim();
      widget.data.faksimili = faksimiliController.text.trim();

      widget.data.provinsi = selectedProvinsi ?? '';
      widget.data.kotaKabupaten = selectedKabupaten ?? '';
      widget.data.kecamatan = selectedKecamatan ?? '';

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
              _input(namaDesaController, "Nama Desa *", true),
              _input(kepalaDesaController, "Nama Kepala Desa *", true),
              _input(
                teleponController,
                "Telepon *",
                true,
                keyboardType: TextInputType.phone,
              ),
              _input(
                faksimiliController,
                "Faksimili",
                false,
                keyboardType: TextInputType.phone,
              ),
              _input(alamatController, "Alamat *", true, maxLines: 3),

              _dropdown(
                label: "Provinsi *",
                value: selectedProvinsi,
                items: const ["Riau"],
                onChanged: (v) {
                  setState(() {
                    selectedProvinsi = v;
                  });
                },
              ),

              _dropdown(
                label: "Kabupaten *",
                value: selectedKabupaten,
                items: const ["Bengkalis"],
                onChanged: (v) {
                  setState(() {
                    selectedKabupaten = v;
                  });
                },
              ),

              _dropdown(
                label: "Kecamatan *",
                value: selectedKecamatan,
                items: const ["Bengkalis", "Bantan"],
                onChanged: (v) {
                  setState(() {
                    selectedKecamatan = v;
                  });
                },
              ),

              _input(
                kodePosController,
                "Kode Pos *",
                true,
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }

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
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.65),
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
        validator: (v) {
          if (required && (v == null || v.trim().isEmpty)) {
            return 'Wajib diisi';
          }
          return null;
        },
      ),
    );
  }

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
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(
            color: Colors.grey.withOpacity(0.65),
          ),
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey.shade300,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
        items: items
            .map(
              (e) => DropdownMenuItem<String>(
                value: e,
                child: Text(e),
              ),
            )
            .toList(),
        onChanged: onChanged,
        validator: (v) {
          if (v == null || v.isEmpty) {
            return 'Wajib dipilih';
          }
          return null;
        },
      ),
    );
  }
}