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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Text(title, style: const TextStyle(fontSize: 13, color: Colors.grey)),

          const SizedBox(height: 4),

          Text(
            value.isEmpty ? '-' : value,

            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),

          const Divider(height: 24),
        ],
      ),
    );
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

          final bool adaBukti = itemData.buktiPembayaran.isNotEmpty;

          return ListView(
            padding: const EdgeInsets.all(16),

            children: [
              // ================= HEADER =================
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.red.shade50,

                  borderRadius: BorderRadius.circular(16),
                ),

                child: Column(
                  children: [
                    const Icon(Icons.receipt_long, size: 60, color: Colors.red),

                    const SizedBox(height: 12),

                    Text(
                      itemData.noInvoice,

                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      itemData.tipe == 'perpanjangan'
                          ? 'Faktur Perpanjangan Domain'
                          : 'Faktur Pendaftaran Domain',

                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================= DETAIL =================
              item("Nama Desa", itemData.namaDesa),

              item("Nama Domain", "${itemData.namaDomain}.desa.id"),

              item("Status Pembayaran", itemData.status),

              item("Tipe Faktur", itemData.tipe),

              item("Tanggal Konfirmasi", itemData.tanggal),

              const SizedBox(height: 20),

              // ================= BUKTI =================
              const Text(
                "Bukti Pembayaran",

                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 12),

              if (adaBukti)
                ClipRRect(
                  borderRadius: BorderRadius.circular(14),

                  child: Image.network(
                    itemData.buktiPembayaran,

                    fit: BoxFit.cover,

                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }

                      return const Padding(
                        padding: EdgeInsets.all(30),

                        child: Center(child: CircularProgressIndicator()),
                      );
                    },

                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,

                        alignment: Alignment.center,

                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,

                          borderRadius: BorderRadius.circular(14),
                        ),

                        child: const Text("Gagal memuat gambar"),
                      );
                    },
                  ),
                )
              else
                Container(
                  height: 150,

                  alignment: Alignment.center,

                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,

                    borderRadius: BorderRadius.circular(14),
                  ),

                  child: const Text("Belum ada bukti pembayaran"),
                ),

              const SizedBox(height: 30),
            ],
          );
        },
      ),
    );
  }
}
