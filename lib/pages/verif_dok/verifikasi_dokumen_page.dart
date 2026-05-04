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
  List<Pengajuan> filteredList = [];

  bool isLoading = true;

  String search = "";
  String selectedFilter = "Semua";

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
      applyFilter();
      isLoading = false;
    });
  }

  void applyFilter() {
    filteredList = list.where((item) {
      final matchSearch = item.domain.toLowerCase().contains(
        search.toLowerCase(),
      );

      final matchFilter = selectedFilter == "Semua"
          ? true
          : item.status == selectedFilter;

      return matchSearch && matchFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verifikasi Dokumen"),
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Colors.red, Color(0xFFB71C1C)]),
          ),
        ),
      ),

      body: Container(
        color: Colors.grey.shade100,
        child: RefreshIndicator(
          onRefresh: getData,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    const SizedBox(height: 16),

                    // ================= SEARCH + FILTER =================
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          // SEARCH
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  search = value;
                                  applyFilter();
                                });
                              },
                              decoration: InputDecoration(
                                hintText: "Search...",
                                prefixIcon: const Icon(Icons.search),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 10),

                          // FILTER
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                            ),
                            child: DropdownButton<String>(
                              value: selectedFilter,
                              underline: const SizedBox(),
                              items: const [
                                DropdownMenuItem(
                                  value: "Semua",
                                  child: Text("Type"),
                                ),
                                DropdownMenuItem(
                                  value: "ditinjau",
                                  child: Text("Ditinjau"),
                                ),
                                DropdownMenuItem(
                                  value: "diproses",
                                  child: Text("Diproses"),
                                ),
                                DropdownMenuItem(
                                  value: "perlu_perbaikan",
                                  child: Text("Perbaikan"),
                                ),
                                DropdownMenuItem(
                                  value: "aktif",
                                  child: Text("Domain Aktif"),
                                ),
                                DropdownMenuItem(
                                  value: "menunggu_aktifasi",
                                  child: Text("Menunggu Aktifasi"),
                                ),
                                DropdownMenuItem(
                                  value: "draft",
                                  child: Text("Draft"),
                                ),
                              ],
                              onChanged: (v) {
                                setState(() {
                                  selectedFilter = v!;
                                  applyFilter();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ================= LIST =================
                    Expanded(
                      child: filteredList.isEmpty
                          ? const Center(child: Text("Belum ada data"))
                          : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: filteredList.length,
                              itemBuilder: (context, i) {
                                final item = filteredList[i];

                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.05),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // DOMAIN
                                      Expanded(
                                        child: Text(
                                          item.domain,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),

                                      // STATUS
                                      _statusBadge(item.status),

                                      const SizedBox(width: 8),

                                      // ACTION
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
                                                  DetailVerifikasiPage(
                                                    data: item,
                                                  ),
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
                                );
                              },
                            ),
                    ),

                    // ================= PAGINATION =================
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _pageButton("1", true),
                          const SizedBox(width: 8),
                          _pageButton("2", false),
                          const SizedBox(width: 8),
                          _pageButton("...", false),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  // ================= STATUS =================
  Widget _statusBadge(String status) {
    Color color;
    String text;

    switch (status) {
      case 'ditinjau':
        color = Colors.yellow;
        text = "Ditinjau";
        break;
      case 'diproses':
        color = Colors.blue;
        text = "Diproses";
        break;
      case 'perlu_perbaikan':
        color = Colors.red;
        text = "Perlu Perbaikan";
        break;
      case 'aktif':
        color = Colors.green;
        text = "Domain Aktif";
        break;
      case 'menunggu_aktifasi':
        color = Colors.orange;
        text = "Menunggu Aktifasi";
        break;
      case 'draft':
        color = Colors.grey;
        text = "Draft";
        break;
      default:
        color = Colors.grey;
        text = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }

  // ================= PAGINATION =================
  Widget _pageButton(String text, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? Colors.red : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(color: active ? Colors.white : Colors.black),
      ),
    );
  }
}
