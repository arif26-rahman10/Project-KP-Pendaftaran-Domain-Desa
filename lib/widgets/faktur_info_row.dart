// widgets/faktur_info_row.dart

import 'package:flutter/material.dart';

class FakturInfoRow extends StatelessWidget {
  final String title;
  final String value;

  const FakturInfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                title,
                style: const TextStyle(color: Color(0xFF3F51B5)),
              ),
            ),
          ),

          Expanded(
            flex: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Text(value, textAlign: TextAlign.right),
            ),
          ),
        ],
      ),
    );
  }
}
