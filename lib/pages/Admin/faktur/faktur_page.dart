import 'package:flutter/material.dart';

import '../../../models/faktur_model.dart';
import '../../../services/faktur_service.dart';
import '../../../widgets/admin_bottom_nav.dart';
import 'detail_faktur_page.dart';

class AdminFakturPage extends StatefulWidget {
  const AdminFakturPage({super.key});

  @override
  State<AdminFakturPage> createState() => _AdminFakturPageState();
}

class _AdminFakturPageState extends State<AdminFakturPage> {
  late Future<List<FakturModel>> future;

  @override
  void initState() {
    super.initState();

    future = FakturService().getData();
  }

  Color statusColor(String status) {
    switch (status) {
      case 'sudah_bayar':
        return Colors.green;

      case 'belum_bayar':
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  String statusText(String status) {
    switch (status) {
      case 'sudah_bayar':
        return 'Sudah Bayar';

      case 'belum_bayar':
        return 'Belum Bayar';

      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      bottomNavigationBar: const AdminBottomNav(currentIndex: 2),

      appBar: AppBar(
        title: const Text("Manajemen Faktur"),
        backgroundColor: const Color(0xFFE53935),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: FutureBuilder<List<FakturModel>>(
        future: future,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(child: Text("Belum ada faktur"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount: data.length,

            itemBuilder: (context, index) {
              final item = data[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 14),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),

                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),

                  title: Text(
                    item.namaDesa,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),

                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          "${item.namaDomain}.desa.id",
                          style: const TextStyle(color: Colors.black87),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          item.noInvoice,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  trailing: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),

                    decoration: BoxDecoration(
                      color: statusColor(item.status).withOpacity(.12),
                      borderRadius: BorderRadius.circular(30),
                    ),

                    child: Text(
                      statusText(item.status),

                      style: TextStyle(
                        color: statusColor(item.status),
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),

                  onTap: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(
                        builder: (_) => DetailFakturPage(id: item.id),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
