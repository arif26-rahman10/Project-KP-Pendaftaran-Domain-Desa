import 'package:flutter/material.dart';

class StepFormLayout extends StatelessWidget {
  final Widget content;
  final int activeStep;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final String title;

  const StepFormLayout({
    super.key,
    required this.content,
    required this.activeStep,
    this.onNext,
    this.onBack,
    this.title = "Pendaftaran Domain",
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),

            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 10),
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Daftar Nama Domain",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _buildStepper(),

                    const Divider(height: 30),

                    Expanded(child: content),

                    _buildBottomButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= HEADER =================
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Colors.red, Colors.redAccent]),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ================= STEPPER =================
  Widget _buildStepper() {
    final steps = [
      "Cek ketersediaan domain",
      "Informasi Instansi",
      "Persyaratan Domain",
      "Pratinjau",
    ];

    return Column(
      children: List.generate(steps.length, (i) {
        final isActive = i == activeStep;

        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              CircleAvatar(
                radius: 12,
                backgroundColor: isActive
                    ? Colors.red
                    : Colors.red.withOpacity(0.3),
                child: Text(
                  "${i + 1}",
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                steps[i],
                style: TextStyle(
                  fontSize: 13,
                  color: isActive ? Colors.black : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ================= BUTTON =================
  Widget _buildBottomButtons() {
    return Row(
      children: [
        if (onBack != null)
          OutlinedButton(onPressed: onBack, child: const Text("Kembali")),

        const Spacer(),

        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text("Berikutnya >"),
        ),
      ],
    );
  }
}
