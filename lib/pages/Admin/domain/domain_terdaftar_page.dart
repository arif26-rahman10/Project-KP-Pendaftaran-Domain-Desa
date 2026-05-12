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
      appBar: AppBar(title: const Text("Domain Terdaftar")),

      body: FutureBuilder<List<DomainTerdaftar>>(
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
            return const Center(child: Text("Tidak ada data"));
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,

            child: DataTable(
              columns: const [
                DataColumn(label: Text("Desa")),

                DataColumn(label: Text("Domain")),

                DataColumn(label: Text("Status")),

                DataColumn(label: Text("Expired")),
              ],

              rows: data.map((item) {
                return DataRow(
                  cells: [
                    DataCell(Text(item.namaDesa)),

                    DataCell(Text("${item.namaDomain}.desa.id")),

                    DataCell(
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),

                        decoration: BoxDecoration(
                          color: statusColor(item.status).withOpacity(.15),

                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Text(
                          item.status,

                          style: TextStyle(
                            color: statusColor(item.status),

                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    DataCell(Text(item.masaBerlaku)),
                  ],
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }
}
