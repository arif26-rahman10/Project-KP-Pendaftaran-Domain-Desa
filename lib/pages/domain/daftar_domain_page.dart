import 'package:flutter/material.dart';

import '../../services/perpanjangan_service.dart';
import 'detail_domain_page.dart';

class DaftarDomainPage extends StatefulWidget {
  final int idUser;

  const DaftarDomainPage({super.key, required this.idUser});

  @override
  State<DaftarDomainPage> createState() => _DaftarDomainPageState();
}

class _DaftarDomainPageState extends State<DaftarDomainPage> {
  List domains = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      // Cek apakah widget masih mounted sebelum melakukan request
      if (!mounted) return;

      final data = await PerpanjanganService.getDomainAktif();

      // Cek lagi apakah widget masih mounted sebelum setState
      if (!mounted) return;

      setState(() {
        domains = data;
        loading = false;
      });
    } catch (e) {
      // Cek mounted sebelum setState di error handler
      if (!mounted) return;

      setState(() {
        loading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Domain'), elevation: 0),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : domains.isEmpty
          ? const Center(
              child: Text(
                'Tidak ada domain aktif',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: domains.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final item = domains[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  elevation: 2,
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.language, color: Colors.blue),
                    ),
                    title: Text(
                      '${item['nama_domain']}.desa.id',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Nama Desa: ${item['nama_desa'] ?? '-'}',
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Masa Aktif: ${item['aktivasi_terakhir']?['masa_berlaku'] ?? '-'}',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: Colors.grey,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetailDomainPage(data: item),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
