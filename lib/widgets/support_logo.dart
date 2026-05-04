import 'package:flutter/material.dart';

class SupportLogo extends StatelessWidget {
  const SupportLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Support By:',
          style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        ),
        const SizedBox(height: 10),
        Image.asset(
          'assets/images/logo_diskominfotik.png',
          width: 170,
          fit: BoxFit.contain,
        ),
      ],
    );
  }
}
