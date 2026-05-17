import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FakturHeaderWidget extends StatelessWidget {
  final String invoiceNumber;
  final String tanggalTerbit;
  final String tanggalKadaluarsa;

  const FakturHeaderWidget({
    super.key,
    required this.invoiceNumber,
    required this.tanggalTerbit,
    required this.tanggalKadaluarsa,
  });

  String formatTanggal(String tanggal) {
    if (tanggal.isEmpty || tanggal == 'null') return '-';

    try {
      final date = DateTime.parse(tanggal.replaceAll(' ', 'T'));
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (_) {
      return tanggal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'INVOICE',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 8),

        Text(invoiceNumber),

        const SizedBox(height: 4),

        Text('Tanggal Terbit : ${formatTanggal(tanggalTerbit)}'),

        const SizedBox(height: 4),

        Text('Tanggal Kadaluarsa : ${formatTanggal(tanggalKadaluarsa)}'),
      ],
    );
  }
}
