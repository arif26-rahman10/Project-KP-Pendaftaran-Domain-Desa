import 'package:flutter/material.dart';
import '../../../services/pengajuan_service.dart';
import '../../../models/pengajuan_model.dart';
import '../../../widgets/domain_card.dart';
import '../../../widgets/admin_bottom_nav.dart';
import 'admin_detail_domain.dart';

class DomainPage extends StatefulWidget {
  const DomainPage({super.key});

  @override
  State<DomainPage> createState() => _DomainPageState();
}

class _DomainPageState extends State<DomainPage> {
  List<Pengajuan> list = [];
  bool isLoading = true;

  String selectedStatus = "semua";

  @override
  void initState() {
    super.initState();
    getData();
  }

  // ================= GET DATA =================
  Future<void> getData() async {
    setState(() => isLoading = true);

    final res = await PengajuanService().getPengajuanAdmin();

    // 🔥 SORT TERBARU DI ATAS
    res.sort((a, b) => b.id.compareTo(a.id));

    setState(() {
      list = res;
      isLoading = false;
    });
  }

  // ================= FILTER =================
  List<Pengajuan> get filteredList {
    if (selectedStatus == "semua") return list;

    return list.where((e) => e.status == selectedStatus).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),

      appBar: AppBar(
        title: const Text("Pengajuan Domain"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      bottomNavigationBar: const AdminBottomNav(currentIndex: 1),

      body: Column(
        children: [
          // ================= FILTER =================
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _filterChip("Semua", "semua"),
                  _filterChip("Ditinjau", "ditinjau"),
                  _filterChip("Diproses", "diproses"),
                  _filterChip("Perbaikan", "perlu_perbaikan"),
                  _filterChip("Aktif", "aktif"),
                ],
              ),
            ),
          ),

          // ================= LIST =================
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredList.isEmpty
                ? const Center(child: Text("Tidak ada data"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredList.length,
                    itemBuilder: (context, index) {
                      final item = filteredList[index];

                      return DomainCard(
                        item: item,
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailDomainPage(data: item),
                            ),
                          );

                          if (result == true) {
                            getData(); // reload
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // ================= FILTER CHIP =================
  Widget _filterChip(String label, String value) {
    final isActive = selectedStatus == value;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: isActive,
        onSelected: (_) {
          setState(() => selectedStatus = value);
        },
        selectedColor: Colors.red,
        labelStyle: TextStyle(color: isActive ? Colors.white : Colors.black),
      ),
    );
  }
}
