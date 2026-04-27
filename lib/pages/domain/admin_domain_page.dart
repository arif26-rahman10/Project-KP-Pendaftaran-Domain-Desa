import 'package:flutter/material.dart';
import '../../services/pengajuan_service.dart';
import '../../models/pengajuan_model.dart';
import '../../widgets/domain_card.dart';
import '../../widgets/admin_bottom_nav.dart';
import 'admin_detail_domain.dart';

class DomainPage extends StatefulWidget {
  const DomainPage({super.key});

  @override
  State<DomainPage> createState() => _DomainPageState();
}

class _DomainPageState extends State<DomainPage> {
  List<Pengajuan> list = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  // 🔥 FUNCTION RELOAD DATA
  Future<void> getData() async {
    setState(() => isLoading = true);

    final res = await PengajuanService().getPengajuanAdmin();

    setState(() {
      list = res;
      isLoading = false;
    });
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

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : list.isEmpty
          ? const Center(child: Text("Tidak ada data"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              itemBuilder: (context, index) {
                final item = list[index];

                return DomainCard(
                  item: item,
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailDomainPage(data: item),
                      ),
                    );

                    // 🔥 INI KUNCINYA
                    if (result == true) {
                      getData(); // reload dari API
                    }
                  },
                );
              },
            ),
    );
  }
}
