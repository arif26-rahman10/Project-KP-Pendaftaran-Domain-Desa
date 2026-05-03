import 'package:flutter/material.dart';
import '../../models/pengajuan_model.dart';
import '../../services/pengajuan_service.dart';
import 'detail_verifikasi_page.dart';

class VerifikasiDokumenPage extends StatefulWidget {
  const VerifikasiDokumenPage({super.key});

  @override
  State<VerifikasiDokumenPage> createState() => _VerifikasiDokumenPageState();
}

class _VerifikasiDokumenPageState extends State<VerifikasiDokumenPage> {
  List<Pengajuan> list = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    setState(() => isLoading = true);

    final res = await PengajuanService().getPengajuanUser();

    setState(() {
      list = res;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi Dokumen"),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: getData,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : list.isEmpty
            ? const Center(child: Text("Belum ada pengajuan"))
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columnSpacing: 20,
                  headingRowColor: MaterialStateProperty.all(
                    Colors.grey.shade200,
                  ),
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columns: const [
                    DataColumn(label: Text("Nama Domain")),
                    DataColumn(label: Text("Status Dokumen")),
                    DataColumn(label: Text("Aksi")),
                  ],
                  rows: list.map((item) {
                    return DataRow(
                      cells: [
                        DataCell(Text(item.domain)),

                        DataCell(_statusBadge(item.status)),

                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.description,
                                  color: Colors.blue,
                                ),
                                onPressed: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          DetailVerifikasiPage(data: item),
                                    ),
                                  );
                                  getData();
                                },
                              ),

                              if (item.status == 'draft')
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    // TODO delete
                                  },
                                ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
      ),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'ditinjau':
        return "Menunggu Verifikasi";
      case 'diproses':
        return "Sedang Diproses";
      case 'perlu_perbaikan':
        return "Perlu Perbaikan";
      case 'aktif':
        return "Domain Aktif";
      case 'draft':
        return "Draft";
      default:
        return status;
    }
  }

  Widget _statusBadge(String status) {
    Color color;

    switch (status) {
      case 'ditinjau':
        color = Colors.orange;
        break;
      case 'diproses':
        color = Colors.blue;
        break;
      case 'perlu_perbaikan':
        color = Colors.red;
        break;
      case 'aktif':
        color = Colors.green;
        break;
      case 'draft':
        color = Colors.grey;
        break;
      default:
        color = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _statusText(status),
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}
