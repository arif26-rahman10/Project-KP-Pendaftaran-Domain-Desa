import 'package:flutter/material.dart';

import '../../../main.dart';

class BuktiSudahUploadWidget extends StatelessWidget {
  final VoidCallback onLihatBukti;

  const BuktiSudahUploadWidget({super.key, required this.onLihatBukti});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.green.shade200),
          ),
          child: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),

              SizedBox(width: 10),

              Expanded(
                child: Text(
                  'Bukti pembayaran sudah dikirim',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        SizedBox(
          width: double.infinity,
          height: 46,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
            ),
            onPressed: onLihatBukti,
            icon: const Icon(Icons.visibility),
            label: const Text('Lihat Bukti Pembayaran'),
          ),
        ),
      ],
    );
  }
}
