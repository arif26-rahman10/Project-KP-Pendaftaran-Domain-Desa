import 'package:flutter/material.dart';

import '../../../models/faktur_model.dart';
import '../../../services/faktur_service.dart';

class DetailFakturPage extends StatefulWidget {
  final int id;

  const DetailFakturPage({super.key, required this.id});

  @override
  State<DetailFakturPage> createState() => _DetailFakturPageState();
}

class _DetailFakturPageState extends State<DetailFakturPage> {
  late Future<FakturModel> future;

  @override
  void initState() {
    super.initState();

    future = FakturService().getDetail(widget.id);
  }

  Widget item(String title, String value) {
    return ListTile(title: Text(title), subtitle: Text(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Faktur")),

      body: FutureBuilder<FakturModel>(
        future: future,

        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final itemData = snapshot.data!;

          return ListView(
            children: [
              item("No Invoice", itemData.noInvoice),

              item("Nama Desa", itemData.namaDesa),

              item("Domain", itemData.namaDomain),

              item("Status", itemData.status),

              item("Tipe", itemData.tipe),

              item("Tanggal", itemData.tanggal),

              const SizedBox(height: 20),

              Image.network(
                itemData.buktiPembayaran,
                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("Gagal memuat gambar"),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
