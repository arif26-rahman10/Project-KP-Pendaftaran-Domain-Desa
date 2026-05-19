import 'package:flutter/material.dart';

import '../../../models/domain_terdaftar_model.dart';
import '../../../services/domain_terdaftar_service.dart';

class DomainTerdaftarPage extends StatefulWidget {
  const DomainTerdaftarPage({super.key});

  @override
  State<DomainTerdaftarPage> createState() => _DomainTerdaftarPageState();
}

class _DomainTerdaftarPageState extends State<DomainTerdaftarPage> {
  late Future<List<DomainTerdaftar>> future;

  @override
  void initState() {
    super.initState();

    future = DomainTerdaftarService().getData();
  }

  Color statusColor(String status) {
    switch (status) {
      case 'aktif':
        return Colors.green;

      case 'kadaluarsa':
        return Colors.red;

      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f7fb),

      appBar: AppBar(
        title: const Text("Domain Terdaftar"),
        elevation: 0,
        centerTitle: true,
      ),

      body: FutureBuilder<List<DomainTerdaftar>>(
        future: future,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(fontSize: 16),
              ),
            );
          }

          final data = snapshot.data ?? [];

          if (data.isEmpty) {
            return const Center(
              child: Text("Tidak ada data", style: TextStyle(fontSize: 16)),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16),

            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),

              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),

                child: Scrollbar(
                  thumbVisibility: true,

                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,

                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,

                      child: DataTable(
                        headingRowColor: MaterialStateProperty.all(
                          Colors.blue.shade50,
                        ),

                        dataRowMinHeight: 65,
                        dataRowMaxHeight: 70,

                        columnSpacing: 40,

                        headingTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                          fontSize: 14,
                        ),

                        columns: const [
                          DataColumn(label: Text("Desa")),

                          DataColumn(label: Text("Domain")),

                          DataColumn(label: Text("Status")),

                          DataColumn(label: Text("Expired")),
                        ],

                        rows: data.map((item) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  item.namaDesa,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),

                              DataCell(
                                Text(
                                  "${item.namaDomain}.desa.id",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),

                                  decoration: BoxDecoration(
                                    color: statusColor(
                                      item.status,
                                    ).withOpacity(.15),

                                    borderRadius: BorderRadius.circular(20),
                                  ),

                                  child: Text(
                                    item.status.toUpperCase(),

                                    style: TextStyle(
                                      color: statusColor(item.status),

                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),

                              DataCell(
                                Text(
                                  item.masaBerlaku,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
