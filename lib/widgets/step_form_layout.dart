import 'package:flutter/material.dart';

class StepFormLayout extends StatelessWidget {
  final Widget content;
  final int activeStep;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final String title;
  final String nextButtonText;

  const StepFormLayout({
    super.key,
    required this.content,
    required this.activeStep,
    this.onNext,
    this.onBack,
    this.title = "Pendaftaran Domain",
    this.nextButtonText = "Berikutnya >",
  });

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      resizeToAvoidBottomInset: true,
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
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25),
                  ),
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

                    Expanded(
                      child: SingleChildScrollView(
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        child: content,
                      ),
                    ),

                    AnimatedPadding(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.only(
                        top: 12,
                        bottom: isKeyboardOpen ? 8 : 0,
                      ),
                      child: _buildBottomButtons(),
                    ),
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
        gradient: LinearGradient(
          colors: [Colors.red, Colors.redAccent],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
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
                backgroundColor:
                    isActive ? Colors.red : Colors.red.withOpacity(0.3),
                child: Text(
                  "${i + 1}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  steps[i],
                  style: TextStyle(
                    fontSize: 13,
                    color: isActive ? Colors.black : Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ================= BUTTON (SUDAH FIX) =================
  Widget _buildBottomButtons() {
    return Row(
      mainAxisAlignment: onBack == null
          ? MainAxisAlignment.end
          : MainAxisAlignment.spaceBetween,
      children: [
        if (onBack != null)
          OutlinedButton(
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 14,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text("Kembali"),
          ),

        ElevatedButton(
          onPressed: onNext,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
            elevation: 2,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: Text(nextButtonText),
        ),
      ],
    );
  }
}