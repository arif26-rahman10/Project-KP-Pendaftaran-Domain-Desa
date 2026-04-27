import 'package:flutter/material.dart';
import '../../services/pengajuan_service.dart';
import '../../models/pengajuan_model.dart';
import '../../widgets/domain_card.dart';
import '../../widgets/admin_bottom_nav.dart';

class DomainPage extends StatefulWidget {
  const DomainPage({super.key});

  @override
  State<DomainPage> createState() => _DomainPageState();
}

class _DomainPageState extends State<DomainPage> {
  late Future<List<Pengajuan>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = PengajuanService().getPengajuanAdmin();
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

      body: FutureBuilder<List<Pengajuan>>(
        future: futureData,
        builder: (context, snapshot) {
          // LOADING
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // ERROR
          if (snapshot.hasError) {
            return const Center(child: Text("Terjadi kesalahan"));
          }

          // KOSONG
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Tidak ada data"));
          }

          final data = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return DomainCard(item: data[index]);
            },
          );
        },
      ),
    );
  }
}
