import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';

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

  String selectedProvinsi = "Riau";
  String selectedKabupaten = "Kabupaten Bengkalis";
  String? selectedKecamatan;
  String? selectedDesa;

  String? selectedKecamatanId;

  List<Map<String, dynamic>> kecamatanList = [];
  List<Map<String, dynamic>> desaList = [];

  bool isLoadingKecamatan = true;
  bool isLoadingDesa = false;

  @override
  void initState() {
    super.initState();

    namaDesaController = TextEditingController(text: widget.data.namaDesa);
    teleponController = TextEditingController(text: widget.data.telepon);
    alamatController = TextEditingController(text: widget.data.alamat);
    kodePosController = TextEditingController(text: widget.data.kodePos);
    faksimiliController = TextEditingController(text: widget.data.faksimili);

    fetchKecamatan();
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

  // ================= FORMAT TEXT =================
  String formatNama(String text) {
    return text
        .toLowerCase()
        .split(' ')
        .map((w) => w.isNotEmpty ? w[0].toUpperCase() + w.substring(1) : '')
        .join(' ');
  }

  // ================= API =================

  Future<void> fetchKecamatan() async {
    setState(() => isLoadingKecamatan = true);

    try {
      final res = await http.get(
        Uri.parse(
          "https://www.emsifa.com/api-wilayah-indonesia/api/districts/1408.json",
        ),
      );

      final data = jsonDecode(res.body);

      setState(() {
        kecamatanList = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      debugPrint("Error kecamatan: $e");
    }

    setState(() => isLoadingKecamatan = false);
  }

  Future<void> fetchDesa(String districtId) async {
    setState(() {
      isLoadingDesa = true;
      desaList = [];
    });

    try {
      final res = await http.get(
        Uri.parse(
          "https://www.emsifa.com/api-wilayah-indonesia/api/villages/$districtId.json",
        ),
      );

      final data = jsonDecode(res.body);

      setState(() {
        desaList = List<Map<String, dynamic>>.from(data);
      });
    } catch (e) {
      debugPrint("Error desa: $e");
    }

    setState(() => isLoadingDesa = false);
  }

  // ================= NEXT STEP =================

  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      widget.data.namaDesa = namaDesaController.text.trim();
      widget.data.telepon = teleponController.text.trim();
      widget.data.alamat = alamatController.text.trim();
      widget.data.kodePos = kodePosController.text.trim();
      widget.data.faksimili = faksimiliController.text.trim();

      widget.data.provinsi = selectedProvinsi;
      widget.data.kotaKabupaten = selectedKabupaten;
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

  // ================= UI =================

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

              _readonlyField("Provinsi", selectedProvinsi),
              _readonlyField("Kabupaten", selectedKabupaten),

              // ================= KECAMATAN SEARCH =================
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: isLoadingKecamatan
                    ? const CircularProgressIndicator()
                    : DropdownSearch<String>(
                        items: kecamatanList
                            .map((e) => e['name'] as String)
                            .toList(),
                        selectedItem: selectedKecamatan,
                        popupProps: const PopupProps.menu(showSearchBox: true),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: _decoration("Kecamatan"),
                        ),
                        itemAsString: (item) => "Kec. ${formatNama(item)}",
                        onChanged: (v) {
                          setState(() {
                            selectedKecamatan = v;
                            selectedDesa = null;

                            final selected = kecamatanList.firstWhere(
                              (e) => e['name'] == v,
                            );

                            selectedKecamatanId = selected['id'];

                            fetchDesa(selectedKecamatanId!);
                          });
                        },
                        validator: (v) => v == null ? "Wajib dipilih" : null,
                      ),
              ),

              // ================= DESA SEARCH =================
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: isLoadingDesa
                    ? const CircularProgressIndicator()
                    : DropdownSearch<String>(
                        items: desaList
                            .map((e) => e['name'] as String)
                            .toList(),
                        selectedItem: selectedDesa,
                        popupProps: const PopupProps.menu(showSearchBox: true),
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: _decoration("Desa"),
                        ),
                        itemAsString: (item) => formatNama(item),
                        onChanged: (v) {
                          setState(() {
                            selectedDesa = v;
                          });
                        },
                        validator: (v) => v == null ? "Wajib dipilih" : null,
                      ),
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
        decoration: _decoration(label, required),
        validator: (v) {
          if (required && (v == null || v.isEmpty)) {
            return 'Wajib diisi';
          }
          return null;
        },
      ),
    );
  }

  Widget _readonlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        decoration: _decoration(label),
      ),
    );
  }

  InputDecoration _decoration(String label, [bool required = true]) {
    return InputDecoration(
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
    );
  }
}
