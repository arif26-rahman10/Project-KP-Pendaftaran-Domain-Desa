import 'package:flutter/material.dart';
import '../models/pengajuan_model.dart';

class DomainCard extends StatelessWidget {
  final Pengajuan item;

  const DomainCard({super.key, required this.item});

  Color getStatusColor(String status) {
    switch (status) {
      case 'ditinjau':
        return Colors.blue;
      case 'diproses':
        return Colors.orange;
      case 'aktif':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String getStatusText(String status) {
    switch (status) {
      case 'ditinjau':
        return "Ditinjau";
      case 'diproses':
        return "diproses";
      case 'aktif':
        return "aktif";
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nama desa + tanggal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                item.namaDesa,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                item.tanggal,
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),

          SizedBox(height: 4),

          Text(item.domain, style: TextStyle(color: Colors.grey)),

          SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: getStatusColor(item.status),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  getStatusText(item.status),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  // ke detail
                },
                child: Text("Lihat Detail"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
