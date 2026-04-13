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
  late final TextEditingController kepalaDesaController;
  late final TextEditingController teleponController;
  late final TextEditingController alamatController;
  late final TextEditingController kodePosController;
  late final TextEditingController faksimiliController;

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
  }

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      widget.data.namaDesa = namaDesaController.text;
      widget.data.namaKepalaDesa = kepalaDesaController.text;
      widget.data.telepon = teleponController.text;
      widget.data.alamat = alamatController.text;
      widget.data.kodePos = kodePosController.text;
      widget.data.faksimili = faksimiliController.text;

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
              _input(teleponController, "Telepon *", true),
              _input(faksimiliController, "Faksimili", false),
              _input(alamatController, "Alamat *", true, maxLines: 3),

              _dropdown("Provinsi", [
                "Riau",
              ], (v) => widget.data.provinsi = v ?? ''),

              _dropdown("Kabupaten", [
                "Bengkalis",
              ], (v) => widget.data.kotaKabupaten = v ?? ''),

              _dropdown("Kecamatan", [
                "Bengkalis",
                "Bantan",
              ], (v) => widget.data.kotaKabupaten = v ?? ''),

              _input(kodePosController, "Kode Pos *", true),
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
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(fontSize: 14),
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.08),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
        validator: (v) =>
            required && (v == null || v.isEmpty) ? 'Wajib diisi' : null,
      ),
    );
  }

  // ================= DROPDOWN =================
  Widget _dropdown(
    String label,
    List<String> items,
    Function(String?)? onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: label,
          hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
          filled: true,
          fillColor: Colors.grey.withOpacity(0.08),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(value: e, child: Text(e)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }
}
