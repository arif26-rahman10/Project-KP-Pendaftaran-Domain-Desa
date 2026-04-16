import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/step_form_layout.dart';
import 'step2_informasi_instansi.dart';
import '../../services/registration_data.dart';

class Step1CheckDomain extends StatefulWidget {
  final RegistrationData data;

  const Step1CheckDomain({
    super.key,
    required this.data,
  });

  @override
  State<Step1CheckDomain> createState() => _Step1CheckDomainState();
}

class _Step1CheckDomainState extends State<Step1CheckDomain> {
  final TextEditingController domainController = TextEditingController();

  Future<void> _openDomain() async {
    final Uri url = Uri.parse('https://domain.go.id/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Tidak bisa membuka link';
    }
  }

  @override
  void initState() {
    super.initState();
    domainController.text = widget.data.namaDomain ?? '';
  }

  @override
  void dispose() {
    domainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: StepFormLayout(
        activeStep: 0,
        onNext: () {
          if (domainController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Nama domain wajib diisi'),
              ),
            );
            return;
          }

          widget.data.namaDomain = domainController.text.trim();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => Step2InformasiInstansi(data: widget.data),
            ),
          );
        },
        content: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: keyboardHeight + 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Cek Ketersediaan Domain",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Lakukan pengecekan di website lalu isi domain yang ingin diajukan",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openDomain,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text("Cek di domain.go.id"),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                "Nama Domain",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),

              TextField(
                controller: domainController,
                textInputAction: TextInputAction.done,
                onTapOutside: (_) => FocusScope.of(context).unfocus(),
                decoration: InputDecoration(
                  hintText: "contoh: desaku.id",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}