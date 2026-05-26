import 'package:flutter/material.dart';

class RekeningWidget extends StatelessWidget {
  const RekeningWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Mohon mencantumkan nomor invoice saat melakukan pembayaran.'),

        SizedBox(height: 6),

        Text(
          'Silakan lakukan pembayaran melalui transfer ke rekening berikut:',
        ),

        SizedBox(height: 14),

        Text(
          'Diskominfo Bengkalis',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF3F51B5),
          ),
        ),

        SizedBox(height: 4),

        Text('Bank BRI'),

        SizedBox(height: 4),

        Text('88-888-888'),
      ],
    );
  }
}
