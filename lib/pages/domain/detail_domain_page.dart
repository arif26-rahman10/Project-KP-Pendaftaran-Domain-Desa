import 'package:flutter/material.dart';

import '../../services/perpanjangan_service.dart';

class DetailDomainPage extends StatelessWidget {
  final Map data;

  const DetailDomainPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Domain')),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              '${data['nama_domain']}.desa.id',

              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              'Masa aktif: '
              '${data['aktivasi']?['masa_berlaku'] ?? '-'}',
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () async {
                  final result = await PerpanjanganService.ajukanPerpanjangan(
                    data['id_pengajuan'],
                  );

                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(result['message'])));
                },

                child: const Text('Perpanjang Domain'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
